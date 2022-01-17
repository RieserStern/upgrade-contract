import { ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("Test upgrade", () => {
    let proxyAddress: string;
    // let signer: SignerWithAddress;

    it("test Box v1", async () => {
        // deploy Box v1
        const Box = await ethers.getContractFactory("BoxV1");
        const box = await upgrades.deployProxy(Box, [42], { initializer: "setPrice"});
        await box.deployed();
        proxyAddress = box.address;
        // [signer] = await ethers.getSigners();

        // const boxV1Abi = [
        //     "function store(uint256)",
        //     "function retrieve() external view returns(uint256)"
        // ]

        // const boxV1Abi = [
        //     "function setPrice(uint _price)"
        // ]

        // const v1Instance = new ethers.Contract(proxyAddress, boxV1Abi, signer)
        // expect(await v1Instance.callStatic.retrieve()).to.eq(42);
        // await v1Instance.functions.setPrice(11);
        // expect(await v1Instance.callStatic.retrieve()).to.eq(11);
    })

    it("test Box v2", async () => {
        // deploy Box v2
        const BoxV2 = await ethers.getContractFactory("BoxV2");
        const boxV2 = await upgrades.upgradeProxy(proxyAddress, BoxV2);
        await boxV2.deployed();
        // const boxV2Abi = [
        //     // v1
        //     "function store(uint256)",
        //     "function retrieve() external view returns(uint256)",
        //     // v2
        //     "function increment()",
        //     "function getY() returns(uint256)",
        //     "function setY(uint256)"
        // ]
        // const boxV2Abi = [
        //     // v1
        //     "function setPrice(uint _price)",
        //     // v2
        //     "function setOwnerPrice(uint _price)",
        // ]

        // const v2Instance = new ethers.Contract(proxyAddress, boxV2Abi, signer)
        // expect(await v2Instance.callStatic.retrieve()).to.eq(11);
        // await v2Instance.functions.setOwnerPrice(12);
        // expect(await v2Instance.callStatic.retrieve()).to.eq(12);
        // await v2Instance.functions.increment();
        // expect(await v2Instance.callStatic.retrieve()).to.eq(13);
        // await v2Instance.functions.setY(21)
        // expect(await v2Instance.callStatic.getY()).to.eq(21);
    })
})