// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

interface IYVaultInfoMap {
    function isYVaultInfoMap() external pure returns (bool);
    function getInfo(address _vault) external view;
}
