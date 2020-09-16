const bre = require("@nomiclabs/buidler");
const ethers = bre.ethers;
const vaultsConfig = require('../mocks/vaults-config.json');

async function main() {
  await bre.run('compile');
  const [owner] = await ethers.getSigners();

  // We get the contract to deploy
  const YRegistry = await ethers.getContractFactory("YRegistry");
  const yRegistry = await YRegistry.deploy(owner._address);

  console.log("YRegistry deployed to:", yRegistry.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
