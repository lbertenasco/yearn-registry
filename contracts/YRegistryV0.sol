//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";

import "../interfaces/IController.sol";
import "../interfaces/IStrategy.sol";
import "../interfaces/IVault.sol";

contract YRegistryV0 {
  using Address for address;
  using SafeMath for uint256;
  using EnumerableSet for EnumerableSet.AddressSet;

  address governance;
  address owner;
  
  address pendingGovernance;
  address pendingOwner;

  EnumerableSet.AddressSet private vaults;
  EnumerableSet.AddressSet private controllers;

  constructor() public {
    owner = msg.sender;
    governance = msg.sender;
  }
  
  function isYRegistry() external pure returns (bool) {
    return true;
  }
  function isYRegistryV0() external pure returns (bool) {
    return true;
  }
  function getName() external pure returns (string memory) {
    return "YRegistryV0";
  }

  function addVault(address _vault) public onlyGovernance {
    require(_vault.isContract());
    // Checks if vault is already on the array
    require(!vaults.contains(_vault), "vault already exists");
    
    // Adds unique _vault to vaults array
    vaults.add(_vault);
    (address controller,,) = getVaultData(_vault);

    // Adds Controller to vault and to controllers array
    if (!controllers.contains(controller)) {
      controllers.add(controller);
    }

    // TODO Add and track tokens and strategies? [historical]
    // (current ones can be obtained via getVaults + getVaultInfo)
  }

  function getVaultData(address _vault) internal view returns (
    address controller,
    address token,
    address strategy
  ) {
    // Get values from controller
    controller = IVault(_vault).controller();
    token = IVault(_vault).token();
    strategy = IController(controller).strategies(token); 
    
    // Check if vault is set on controller for token  
    address vault = IController(controller).vaults(token);
    require(_vault == vault, "Controller vault address does not match"); // Should never happen
    
    // Check if strategy has the same token as vault
    address strategyToken = IStrategy(strategy).want();
    require(token == strategyToken, "Strategy token address does not match"); // Might happen?
    
    return (controller, token, strategy);
  }

  // Vaults getters
  function getVault(uint index) external view returns (address vault) {
    return vaults.at(index);
  }

  function getVaultsLength() external view returns (uint) {
    return vaults.length();
  }

  function getVaults() external view returns (address[] memory) {
    address[] memory vaultsArray = new address[](vaults.length());
    for (uint i = 0; i < vaults.length(); i++) {
      vaultsArray[i] = vaults.at(i);
    }
    return vaultsArray;
  }

  function getVaultInfo(address _vault) external view returns (
    address controller,
    address token,
    address strategy
  ) {
    (controller, token, strategy) = getVaultData(_vault);
    return (
      controller,
      token,
      strategy
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
