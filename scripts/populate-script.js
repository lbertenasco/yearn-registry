const bre = require("@nomiclabs/buidler");
const ethers = bre.ethers;
const vaultsConfig = require('../mocks/vaults-config.json');

async function main() {
  await bre.run('compile');
  const [owner] = await ethers.getSigners();

  // We get the contract to deploy
  const YRegistryV1 = await ethers.getContractFactory("YRegistryV1");
  const yRegistryV1 = await YRegistryV1.attach("0x3eE41C098f9666ed2eA246f4D2558010e59d63A0");


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
  console.log('Done');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
