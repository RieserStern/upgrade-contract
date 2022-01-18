import { ethers } from "hardhat";
const { getImplementationAddress } = require('@openzeppelin/upgrades-core');

async function main() {

  // We get the contract to deploy
  const Migrations = await ethers.getContractFactory("Migrations");
  const migrations = await Migrations.deploy();

  await migrations.deployed();

  const implementation1 = await getImplementationAddress(
    ethers.provider, migrations.address);

  console.log("AVGPriceV1 address:", migrations.address);
  console.log("implementation 1 address:", implementation1);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});