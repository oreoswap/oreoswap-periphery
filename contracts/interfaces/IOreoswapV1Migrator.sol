// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.6.2;


interface IOreoswapV1Migrator {
    function migrate(address token, uint amountTokenMin, uint amountBNBMin, address to, uint deadline) external;
}
