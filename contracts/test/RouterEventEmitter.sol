// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.6.2;

import '../interfaces/IOreoswapV1Router01.sol';

contract RouterEventEmitter {
    event Amounts(uint[] amounts);

    receive() external payable {}

    function swapExactTokensForTokens(
        address router,
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IOreoswapV1Router01(router).swapExactTokensForTokens.selector, amountIn, amountOutMin, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapTokensForExactTokens(
        address router,
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IOreoswapV1Router01(router).swapTokensForExactTokens.selector, amountOut, amountInMax, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapExactBNBForTokens(
        address router,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IOreoswapV1Router01(router).swapExactBNBForTokens.selector, amountOutMin, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapTokensForExactBNB(
        address router,
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IOreoswapV1Router01(router).swapTokensForExactBNB.selector, amountOut, amountInMax, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapExactTokensForBNB(
        address router,
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IOreoswapV1Router01(router).swapExactTokensForBNB.selector, amountIn, amountOutMin, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapBNBForExactTokens(
        address router,
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IOreoswapV1Router01(router).swapBNBForExactTokens.selector, amountOut, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }
}
