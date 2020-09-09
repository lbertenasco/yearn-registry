//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
 
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

  // Vault Mappings
  mapping(address => address) public vaultController;
  mapping(address => address[]) public vaultStrategies;
  mapping(address => address[]) public vaultTokens;

  // Token Mappings
  mapping(address => address[]) public tokenVaults;
  mapping(address => mapping(address => uint)) private tokenVaultIndex;

  // Strategies Mappings
  mapping(address => address[]) public strategyVaults;
  mapping(address => mapping(address => uint)) private strategyVaultIndex;

  // Enabled mappings
  mapping(address => bool) public enabledVault;


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

  function addVault(address _vault, address _controller, address[] memory _tokens, address[] memory _strategies) public onlyGovernance {
    require(_vault.isContract());
    require(!vaults.contains(_vault), "vault already exists"); // check if vault is already on the array
    // TODO Get & Check values from _controller
    
    // TODO add checks for controller, tokens and strategies
    // adds unique _vault to vaults array
    vaults.add(_vault);

    setVaultData(_vault, _controller, _tokens, _strategies);

   
   // TODO Add controller, tokens and strategies to array. (is this neccesary when you have all the data under vaults?)
  }
  function editVault(address _vault, address _controller, address[] memory _tokens, address[] memory _strategies) public onlyGovernance {
    require(vaults.contains(_vault));
    // TODO Get & Check values from _controller
    setVaultData(_vault, _controller, _tokens, _strategies);
  }
  
  function enableVault(address _vault) public onlyGovernance {
    require(enabledVault[_vault] == false, "vault already enabled");
    enabledVault[_vault] = true;
  }
  function disableVault(address _vault) public onlyGovernance {
    require(enabledVault[_vault] == true, "vault already disabled");
    enabledVault[_vault] = false;
  }

  function setVaultData(address _vault, address _controller, address[] memory _tokens, address[] memory _strategies) internal {
    // Adds Controller to vault and to controllers array
    vaultController[_vault] = _controller;
    if (!controllers.contains(_controller)) {
      controllers.add(_controller);
    }

    // Adds Tokens to vault and to tokens array
    vaultTokens[_vault] = _tokens;
    for (uint i = 0; i < _tokens.length; i++) {
      if (tokenVaults[_tokens[i]].length == 0 ||
          tokenVaults[_tokens[i]][tokenVaultIndex[_tokens[i]][_vault]] != _vault) {
        tokenVaults[_tokens[i]].push(_vault);
        tokenVaultIndex[_tokens[i]][_vault] = tokenVaults[_tokens[i]].length.sub(1);
      }
    }

    // Adds Strategies to vault and to strategyVaults array
    vaultStrategies[_vault] = _strategies;
    for (uint i = 0; i < _strategies.length; i++) {
      if (strategyVaults[_strategies[i]].length == 0 ||
          strategyVaults[_strategies[i]][strategyVaultIndex[_strategies[i]][_vault]] != _vault) {
        strategyVaults[_strategies[i]].push(_vault);
        strategyVaultIndex[_strategies[i]][_vault] = strategyVaults[_strategies[i]].length.sub(1);
      }
    }

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

  // Tokens getters
  function getTokenVaults(address _token) external view returns (
    address[] memory tokenVaultsList
  ) {
    return tokenVaults[_token];
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
