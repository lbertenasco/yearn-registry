//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "@nomiclabs/buidler/console.sol";

import "../interfaces/IVault.sol";
import "../interfaces/IYVaultInfoMap.sol";


  /**
   * Description:
   * 
   * 
   * For Vaults: should return all vaults with following information: 
   * vault: (address, name, decimals, symbol, strategies[], archivedStrategies[], tokens[], governance) [getPricePerFullShare]
   * strategy: (address, name, strategist, harvester, withdrawalFee, performanceFee, strategistReward, governance) [balanceOfWant, balanceOfPool, getExchangeRate, balanceOfD, balanceOf]
   * token: (address, name, decimals, symbol)
   *
   *
   *
   *
   */
  /**
   * Relation:
   * 
   * Vaults m:n Strategies
   * Vaults m:n Tokens
   *
   * Controller 1:n Vault
   * Controller 1:n Strategies
   *
   * Token m:n Strategies
   *
   */
 
contract YRegistry {
  using Address for address;
  using SafeMath for uint256;

  address governance;
  address pendingGovernance;
  
  address owner;
  address pendingOwner;

  address[] controllers; // TODO
  address[] strategies; // TODO
  address[] tokens; // TODO
  address[] vaults;

  mapping(address => uint) public controllerIndex; // TODO
  mapping(address => uint) public strategyIndex; // TODO
  mapping(address => uint) public tokenIndex; // TODO
  mapping(address => uint) public vaultIndex;

  mapping(address => address) internal infoMap;
  
  constructor() public {
    console.log("Deploying YRegistry");
    owner = msg.sender;
    governance = msg.sender;
  }
  
  function isYRegistry() external pure returns (bool) {
    return true;
  }
  function getName() external pure returns (string memory) {
    return "YRegistry";
  }

  function addVault(address _vault, address _vaultInfoMap) public onlyGovernance {
    require(_vault.isContract());
    require(vaults.length == 0 || vaults[vaultIndex[_vault]] != _vault);
    // adds unique _vault to vaults array
    vaults.push(_vault);
    vaultIndex[_vault] = vaults.length - 1;

    if (_vaultInfoMap != address(0) && IYVaultInfoMap(_vaultInfoMap).isYVaultInfoMap()) {
      infoMap[_vault] = _vaultInfoMap;
    }
  }
  function editVault(address _vault, address _vaultInfoMap) public onlyGovernance {
    require(vaults[vaultIndex[_vault]] == _vault);

    if (_vaultInfoMap != address(0) && IYVaultInfoMap(_vaultInfoMap).isYVaultInfoMap()) {
      infoMap[_vault] = _vaultInfoMap;
    } else {
      infoMap[_vault] = address(0);
    }
  }
  function removeVault(address _vault) public onlyGovernance {
    uint index = vaultIndex[_vault];
    require(vaults[index] == _vault);
    
    if (index != vaults.length - 1) {
      // If vault is not the last on the array
      address lastVault = vaults[vaults.length - 1];
      // Swaps with last Vault
      vaults[index] = lastVault;
      // Edit lastVault index
      vaultIndex[lastVault] = index;
    }

    vaults.pop();

    delete vaultIndex[_vault];
    delete infoMap[_vault];
  }


  // Vaults getters
  function getVaultsLength() external view returns (uint) {
    return vaults.length;
  }
  function getVaults() external view returns (address[] memory, address[] memory) {
    address[] memory vaultsInfoMaps = new address[](vaults.length);
    for (uint index = 0; index < vaults.length; index++) {
      vaultsInfoMaps[index] = infoMap[vaults[index]];
    }
    return (
      vaults,
      vaultsInfoMaps
    );
  }


 // Governance setters
  function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
    pendingGovernance = _pendingGovernance;
  }
  function acceptGovernance() external onlyPendingGovernance {
    governance = msg.sender;
  }
 // Owner setters
  function setPendingOwner(address _pendingOwner) external onlyOwner {
    pendingOwner = _pendingOwner;
  }
  function acceptOwner() external onlyPendingOwner {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Only owner can call this function.");
    _;
  }
  modifier onlyPendingOwner {
    require(msg.sender == pendingOwner, "Only pendingOwner can call this function.");
    _;
  }
  modifier onlyGovernance {
    require(msg.sender == governance, "Only governance can call this function.");
    _;
  }
  modifier onlyPendingGovernance {
    require(msg.sender == pendingGovernance, "Only pendingGovernance can call this function.");
    _;
  }
}
