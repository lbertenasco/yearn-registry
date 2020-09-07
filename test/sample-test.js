const { expect } = require("chai");

describe("YRegistry", function() {
  it("Should return the new greeting once it's changed", async function() {
    const YRegistry = await ethers.getContractFactory("YRegistry");
    const yRegistry = await YRegistry.deploy();
    
    await yRegistry.deployed();

  });
});
