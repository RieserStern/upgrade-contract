import { expect } from "chai";
import { ethers } from "hardhat";

describe("DefiAVGPrice", function () {
  it("DefiAVGPrice", async function () {
    const DefiAVGPrice = await ethers.getContractFactory("DefiAVGPrice");
    const defiAVGPrice = await DefiAVGPrice.deploy();
    await defiAVGPrice.deployed();

    const setPriceTx = await defiAVGPrice.setPrice(20);

    // wait until the transaction is mined
    await setPriceTx.wait();

    // setCurrent Timestamp
    expect(await defiAVGPrice.getPrice(1640626812)).to.equal(20);
  });

  it("DefiAVGPriceV2", async function () {
    const DefiAVGPriceV2 = await ethers.getContractFactory("DefiAVGPriceV2");
    const defiAVGPriceV2 = await DefiAVGPriceV2.deploy();
    await defiAVGPriceV2.deployed();

    const setPriceTxV2 = await defiAVGPriceV2.setPrice(20);

    // wait until the transaction is mined
    await setPriceTxV2.wait();

    // setCurrent Timestamp
    expect(await defiAVGPriceV2.getPrice(1640626812)).to.equal(20);
  });

  it("DefiAVGPriceV3", async function () {
    const DefiAVGPriceV3 = await ethers.getContractFactory("DefiAVGPriceV3");
    const defiAVGPriceV3 = await DefiAVGPriceV3.deploy();
    await defiAVGPriceV3.deployed();

    const setPriceTxV3 = await defiAVGPriceV3.setPrice(20);

    // wait until the transaction is mined
    await setPriceTxV3.wait();

    // setCurrent Timestamp
    expect(await defiAVGPriceV3.getPrice(1640626812)).to.equal(20);
  });

  it("After Upgrade DefiAVGPriceV2", async function () {
    const DefiAVGPrice = await ethers.getContractFactory("DefiAVGPrice");
    const DefiAVGPriceV2 = await ethers.getContractFactory("DefiAVGPriceV2");
    const DefiAVGPriceV3 = await ethers.getContractFactory("DefiAVGPriceV3");

    const Resolver = await ethers.getContractFactory("Resolver");
    const defiAVGPrice = await DefiAVGPrice.deploy();
    const defiAVGPriceV2 = await DefiAVGPriceV2.deploy();
    const defiAVGPriceV3 = await DefiAVGPriceV3.deploy();
    const resolver = await Resolver.deploy();

    await defiAVGPrice.deployed();
    await defiAVGPriceV2.deployed();
    await defiAVGPriceV3.deployed();
    await resolver.deployed();

    const EtherRouter = await ethers.getContractAt("EtherRouter", resolver.address);
    const etherRouter = await EtherRouter.deploy();
    await etherRouter.deployed();
    const DelegationContract = await ethers.getContractAt("DefiAVGInterface", etherRouter.address);
    const delegationContract = await DelegationContract.deploy();
    await delegationContract.deployed();


    await resolver.Register("setPrice(uint256)", defiAVGPrice.address, 0);
    await resolver.Register("setPrice(uint256)", defiAVGPriceV2.address, 0);
    await resolver.Register("setPrice(uint256)", defiAVGPriceV3.address, 0);
    const setPriceTx = await delegationContract.setPrice(20);

    // wait until the transaction is mined
    await setPriceTx.wait();

    // setCurrent Timestamp
    expect(await delegationContract.getPrice(1640626812)).to.equal(20);
  });
});
