//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
 
contract YRegistryV2 {
  using Address for address;
  using SafeMath for uint256;

  address governance;
  address owner;
  
  address pendingGovernance;
  address pendingOwner;

  // are this arrays neccesary?
  // address[] controllers;
  // address[] strategies;
  // address[] tokens;
  address[] vaults;

  // mapping(address => bool) public enabledController;
  // mapping(address => bool) public enabledStrategy;
  // mapping(address => bool) public enabledToken;
  mapping(address => bool) public enabledVault;

  mapping(address => address) public vaultController;
  mapping(address => address[]) public vaultTokens;
  mapping(address => address[]) public vaultStrategies;
  mapping(address => uint) public vaultIndex;


  constructor() public {
    owner = msg.sender;
    governance = msg.sender;
  }
  
  function isYRegistryV2() external pure returns (bool) {
    return true;
  }
  function getName() external pure returns (string memory) {
    return "YRegistryV2";
  }

  function addVault(address _vault, address _controller, address[] memory _tokens, address[] memory _strategies) public onlyGovernance {
    require(_vault.isContract());
    require(vaults.length == 0 || vaults[vaultIndex[_vault]] != _vault, "vault already exists"); // check if vault is already on the array

    // TODO add checks for controller, tokens and strategies
    // adds unique _vault to vaults array
    vaults.push(_vault);
    vaultIndex[_vault] = vaults.length - 1;

    vaultController[_vault] = _controller;
    vaultTokens[_vault] = _tokens;
    vaultStrategies[_vault] = _strategies;
   
   // TODO Add controller, tokens and strategies to array. (is this neccesary when you have all the data under vaults?)
  }

  function editVaultController(address _vault, address _controller) public onlyGovernance {
    require(vaults[vaultIndex[_vault]] == _vault);
    vaultController[_vault] = _controller;
  }
  function enableVault(address _vault) public onlyGovernance {
    require(enabledVault[_vault] == false, "vault already enabled");
    enabledVault[_vault] = true;
  }
  function disableVault(address _vault) public onlyGovernance {
    require(enabledVault[_vault] == true, "vault not enabled");
    enabledVault[_vault] = false;
  }


  // Vaults getters
  function getVaultsLength() external view returns (uint) {
    return vaults.length;
  }
  function getVaults() external view returns (address[] memory) {
    return vaults;
  }
  function getVaultInfo(address _vault) external view returns (
    bool enabled,
    address controller,
    address[] memory tokens,
    address[] memory strategies
  ) {
    return (
      enabledVault[_vault],
      vaultController[_vault],
      vaultTokens[_vault],
      vaultStrategies[_vault]
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
