// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

//This was not working. IDE could not import file. So I added the library from @uniswap library using:
        //   yarn add @uniswap/lib
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import './interfaces/IOreoswapV1Migrator.sol';
import './interfaces/V1/IOreoswapV1Factory.sol';
import './interfaces/V1/IOreoswapV1Exchange.sol';
import './interfaces/IOreoswapV1Router01.sol';
import './interfaces/IBEP20.sol';

contract OreoswapV1Migrator is IOreoswapV1Migrator {
    
    IOreoswapV1Factory immutable factoryV1;
    IOreoswapV1Router01 immutable router;

    //Removed the public visibility as it is ignored. Not required by the current compiler.
    constructor(address _factoryV1, address _router) {
        factoryV1 = IOreoswapV1Factory(_factoryV1);
        router = IOreoswapV1Router01(_router);
    }

    // needs to accept BNB from any v1 exchange and the router. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    receive() external payable {}

    function migrate(address token, uint amountTokenMin, uint amountBNBMin, address to, uint deadline)
        external
        override
    {
        IOreoswapV1Exchange exchangeV1 = IOreoswapV1Exchange(factoryV1.getExchange(token));
        uint liquidityV1 = exchangeV1.balanceOf(msg.sender);
        require(exchangeV1.transferFrom(msg.sender, address(this), liquidityV1), 'TRANSFER_FROM_FAILED');
        (uint amountBNBV1, uint amountTokenV1) = exchangeV1.removeLiquidity(liquidityV1, 1, 1, uint(int(-1))); //@team, I recasted the signed integer using the int() type. Current compiler not permitted to cast explicitly from int-const to uint256
        TransferHelper.safeApprove(token, address(router), amountTokenV1);
        (uint amountTokenV2, uint amountBNBV2,) = router.addLiquidityBNB{value: amountBNBV1}(
            token,
            amountTokenV1,
            amountTokenMin,
            amountBNBMin,
            to,
            deadline
        );
        if (amountTokenV1 > amountTokenV2) {
            TransferHelper.safeApprove(token, address(router), 0); // be a good blockchain citizen, reset allowance to 0
            TransferHelper.safeTransfer(token, msg.sender, amountTokenV1 - amountTokenV2);
        } else if (amountBNBV1 > amountBNBV2) {
            // addLiquidityBNB guarantees that all of amountBNBV1 or amountTokenV1 will be used, hence this else is safe
            TransferHelper.safeTransferBNB(msg.sender, amountBNBV1 - amountBNBV2);
        }
    }
}
