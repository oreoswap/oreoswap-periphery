// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;


interface IOreoswapV1Migrator {
    function migrate(address token, uint amountTokenMin, uint amountBNBMin, address to, uint deadline) external;
}
