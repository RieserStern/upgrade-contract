import { ethers, upgrades } from "hardhat";

async function main() {
    let BoxV2 = await ethers.getContractFactory("BoxV2");
    let boxV2 = await upgrades.upgradeProxy("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", BoxV2);
    await boxV2.deployed();

    console.log("Box V2 upgraded");
}

main();