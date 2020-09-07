//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "@nomiclabs/buidler/console.sol";

import "../interfaces/IVault.sol";


contract YVaultV1InfoMap {
  using Address for address;
  using SafeMath for uint256;

  address[] controllers;
  address[] tokens;
  address[] vaults;

  mapping(address => bool) public enabledController;
  mapping(address => bool) public enabledToken;
  mapping(address => bool) public enabledVault;
  
  constructor() public {
    console.log("Deploying YVaultV1InfoMap");
  }
  
  function isYVaultInfoMap() external pure returns (bool) {
    return true;
  }
  function isYVaultV1InfoMap() external pure returns (bool) {
    return true;
  }
  function getName() external pure returns (string memory) {
    return "YVaultV1InfoMap";
  }

  // vault: (address, name, symbol, decimals, governance, strategies[], archivedStrategies[], tokens[]) [getPricePerFullShare]
  function getInfo(address _vault, address _registry) external view returns(
    address vaultAddress,
    string memory name,
    string memory symbol,
    uint decimals,
    address token,
    address governance,
    uint pricePerFullShare,
    address[] memory strategies
    ) {
    address[] memory currentStrategies = new address[](0); // TODO populate using _registry
    return (
      _vault,
      IVault(_vault).name(),
      IVault(_vault).symbol(),
      IVault(_vault).decimals(),
      IVault(_vault).token(),
      IVault(_vault).governance(),
      IVault(_vault).getPricePerFullShare(),
      currentStrategies
    );
  }

}
