const { expect } = require("chai");
const vaultsConfig = require('../mocks/vaults-config.json');
const ZERO = '0x0000000000000000000000000000000000000000';

describe("YRegistryV1", function() {
  let YRegistryV1, yRegistryV1;
  
  it("Should deploy YRegistryV1", async function() {
    YRegistryV1 = await ethers.getContractFactory("YRegistryV1");
    yRegistryV1 = await YRegistryV1.deploy();
    await yRegistryV1.deployed();
    console.log("YRegistryV1 deployed to:", yRegistryV1.address);
  })

  it("Should add current contracts", async function() {
    for (const vault of vaultsConfig) {
      console.log('Adding:', vault.name, vault.address);
      switch (vault.type) {
        case 'wrapped':
          await yRegistryV1.addWrappedVault(vault.address);
          break;
        case 'delegated':
          await yRegistryV1.addDelegatedVault(vault.address);
          break;
        default:
          await yRegistryV1.addVault(vault.address);
          break;
      }
    }
  });
  it("Should get current contracts data", async function() {
    for (const vault of vaultsConfig) {
      console.log('Getting data for:', vault.name, vault.address);
      const data = await yRegistryV1.getVaultInfo(vault.address);
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
