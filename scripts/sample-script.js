const bre = require("@nomiclabs/buidler");

async function main() {
  await bre.run('compile');

  // We get the contract to deploy
  const YRegistry = await ethers.getContractFactory("YRegistry");
  const yRegistry = await YRegistry.deploy();

  await yRegistry.deployed();

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
