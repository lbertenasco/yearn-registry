const { expect } = require("chai");
const vaultsConfig = require('../mocks/vaults-config.json');
const ZERO = '0x0000000000000000000000000000000000000000';

describe("YRegistry", function() {
  let YRegistry, yRegistry;
  
  
  it("Should deploy YRegistry", async function() {
    const [owner] = await ethers.getSigners();
    YRegistry = await ethers.getContractFactory("YRegistry");
    yRegistry = await YRegistry.deploy(owner._address); // owner is governance
    await yRegistry.deployed();
    console.log("YRegistry deployed to:", yRegistry.address);
  })

  it("Should add current contracts", async function() {
    for (const vault of vaultsConfig) {
      console.log('Adding:', vault.name, vault.address);
      switch (vault.type) {
        case 'wrapped':
          await yRegistry.addWrappedVault(vault.address);
          break;
        case 'delegated':
          await yRegistry.addDelegatedVault(vault.address);
          break;
        default:
          await yRegistry.addVault(vault.address);
          break;
      }
    }
  });
  it("Should get current contracts data", async function() {
    for (const vault of vaultsConfig) {
      console.log('Getting data for:', vault.name, vault.address);
      const data = await yRegistry.getVaultInfo(vault.address);
      expect(data.token.toLowerCase()).to.equal(vault.token.address.toLowerCase());
      if (vault.type === 'delegated') {
        expect(data.isDelegated).to.equal(true);
      }
      if (vault.type === 'wrapped') { // TODO check for wrapped & delegated vaults
        expect(data.isWrapped).to.equal(true);
      }
      if (!vault.type) {
        expect(data.isDelegated).to.equal(false);
        expect(data.isWrapped).to.equal(false);
      }
    }
  });
  it("Should get all contracts data on 1 call", async function () {
    const data = await yRegistry.getVaultsInfo();
    for (const [i, vault] of vaultsConfig.entries()) {
      expect(data.tokenArray[i].toLowerCase()).to.equal(vault.token.address.toLowerCase());
      if (vault.type === 'delegated') {
        expect(data.isDelegatedArray[i]).to.equal(true);
      }
      if (vault.type === 'wrapped') { // TODO check for wrapped & delegated vaults
        expect(data.isWrappedArray[i]).to.equal(true);
      }
      if (!vault.type) {
        expect(data.isDelegatedArray[i]).to.equal(false);
        expect(data.isWrappedArray[i]).to.equal(false);
      }
    }
  });
});
