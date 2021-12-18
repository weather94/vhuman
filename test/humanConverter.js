const HumanGovernor = artifacts.require("HumanGovernor");
const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");
const HumanERC20Staker = artifacts.require("HumanERC20Staker");
const HumanConverter = artifacts.require("HumanConverter");

contract("HumanConverter", (accounts) => {
  it("test convert", async () => {
    const humanERC20Instance = await HumanERC20.deployed();
    const humanNFT = await Human.deployed();
    const shumanERC20Instance = await SHumanERC20.deployed();
    const humanERC20Staker = await HumanERC20Staker.deployed();
    const humanGovernor = await HumanGovernor.deployed();
    const humanConverter = await HumanConverter.deployed();

    await humanNFT.mint(accounts[0], "Eunha", "i am eunha", "0xfffff", {
      from: accounts[0],
    });
    await humanNFT.approve(humanConverter.address, 1, {
      from: accounts[0],
    });
    await humanConverter.stake(1, 50000, false, {
      from: accounts[0],
    });
    await humanERC20Instance.approve(humanConverter.address, 50000, {
      from: accounts[0],
    });
    await humanConverter.request(1, "test", accounts[0], "3", {
      from: accounts[0],
    });

    assert.equal(1, 2, "sibla");
  });
});
