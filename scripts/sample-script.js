const bre = require("@nomiclabs/buidler");
const ethers = bre.ethers;
const vaultsConfig = require('../mocks/vaults-config.json');

async function main() {
  await bre.run('compile');
  const [owner] = await ethers.getSigners();

  // We get the contract to deploy
  const YRegistryV0 = await ethers.getContractFactory("YRegistryV0");
  const yRegistryV0 = await YRegistryV0.deploy();

  console.log('yRegistryV0.addVault')
  console.log(yRegistryV0.addVault)

  console.log("YRegistryV0 deployed to:", yRegistryV0.address);
  for (const vault of vaultsConfig) {
    console.log('Adding:',vault.name, vault.address);
    await yRegistryV0.addVault(vault.address);
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
