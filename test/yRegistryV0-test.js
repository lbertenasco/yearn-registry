const { expect } = require("chai");
const vaultsConfig = require('../mocks/vaults-config.json');
const ZERO = '0x0000000000000000000000000000000000000000';

describe("YRegistryV0", function() {
  let YRegistryV0, yRegistryV0;
  
  it("Should deploy YRegistryV0", async function() {
    YRegistryV0 = await ethers.getContractFactory("YRegistryV0");
    yRegistryV0 = await YRegistryV0.deploy();
    await yRegistryV0.deployed();
    console.log("YRegistryV0 deployed to:", yRegistryV0.address);
  })

  it("Should add current contracts", async function() {
    for (const vault of vaultsConfig) {
      console.log('Adding:', vault.name, vault.address);
      switch (vault.type) {
        case 'wrapped':
          await yRegistryV0.addWrappedVault(vault.address);
          break;
        case 'delegated':
          await yRegistryV0.addDelegatedVault(vault.address);
          break;
        default:
          await yRegistryV0.addVault(vault.address);
          break;
      }
    }
  });
  it("Should get current contracts data", async function() {
    for (const vault of vaultsConfig) {
      console.log('Getting data for:', vault.name, vault.address);
      const data = await yRegistryV0.getVaultInfo(vault.address);
      console.log(data)
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
});
