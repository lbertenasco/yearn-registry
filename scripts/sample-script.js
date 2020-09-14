const bre = require("@nomiclabs/buidler");
const ethers = bre.ethers;
const vaultsConfig = require('../mocks/vaults-config.json');

async function main() {
  await bre.run('compile');
  const [owner] = await ethers.getSigners();

  // We get the contract to deploy
  const YRegistryV1 = await ethers.getContractFactory("YRegistryV1");
  const yRegistryV1 = await YRegistryV1.deploy();

  console.log('yRegistryV1.addVault')
  console.log(yRegistryV1.addVault)

  console.log("YRegistryV1 deployed to:", yRegistryV1.address);
  for (const vault of vaultsConfig) {
    console.log('Adding:',vault.name, vault.address);
    await yRegistryV1.addVault(vault.address);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
