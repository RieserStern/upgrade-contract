import { ethers, upgrades } from "hardhat";

async function main() {
    const Box = await ethers.getContractFactory("Box");
    console.log("Deploying Box...");
    const box = await upgrades.deployProxy(Box, [42], { initializer: "setPrice"});
    await box.deployed();
    console.log("Box v1 deployed at: ", box.address);
    
    main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
}

main();