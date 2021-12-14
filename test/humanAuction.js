const HumanAuction = artifacts.require("HumanAuction");
const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");

contract("HumanAuction", (accounts) => {
  it("auction test", async () => {
    const humanAuctionInstance = await HumanAuction.deployed();
    const humanInstance = await Human.deployed();
    const humanERC20Instance = await HumanERC20.deployed();

    const account = accounts[0];

    await humanInstance.mint(
      account,
      "Eunha1",
      "My Name is Eunha1",
      "0x0000000"
    );

    await humanInstance.mint(
      account,
      "Eunha2",
      "My Name is Eunha2",
      "0x0000000"
    );

    await humanInstance.approve(humanAuctionInstance.address, 1, {
      from: accounts[0],
    });

    const result = await humanAuctionInstance.addAuction(
      1,
      new Date(new Date().getTime() + 3600 * 1000).getTime()
    );

    const balance = web3.utils.toWei("10000", "ether");
    // web3.utils.toWei("1000000", "ether")
    await humanERC20Instance.approve(humanAuctionInstance.address, balance, {
      from: accounts[0],
    });
    await humanAuctionInstance.bid(1, balance);

    assert.equal(result?.logs[0]?.args._tokenId, 2, " check tokenId => exist");
  });
});
