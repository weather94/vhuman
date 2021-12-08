const HumanGovernor = artifacts.require("HumanGovernor");
const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");
const HumanERC20Staker = artifacts.require("HumanERC20Staker");

contract("HumanGovernor", (accounts) => {
  it("test propose", async () => {
    const humanERC20Instance = await HumanERC20.deployed();
    const humanNFT = await Human.deployed();
    const shumanERC20Instance = await SHumanERC20.deployed();
    const humanERC20Staker = await HumanERC20Staker.deployed();
    const humanGovernor = await HumanGovernor.deployed();

    await humanERC20Instance.approve(
      humanERC20Staker.address,
      web3.utils.toWei("10000000", "ether"),
      {
        from: accounts[0],
      }
    );

    await humanERC20Staker.stake(web3.utils.toWei("1000000", "ether"), {
      from: accounts[0],
    });
    const balance = await shumanERC20Instance.balanceOf(accounts[0]);

    assert.equal(
      balance.valueOf(),
      web3.utils.toWei("1000000", "ether"),
      "shuman value 1,000,000"
    );

    assert.equal(await humanGovernor.votingDelay(), 1, "votingDelay");

    const calldata = web3.eth.abi.encodeFunctionCall(
      {
        name: "mint",
        type: "function",
        inputs: [
          {
            type: "address",
            name: "to",
          },
          {
            type: "string",
            name: "name",
          },
          {
            type: "string",
            name: "description",
          },
          {
            type: "string",
            name: "hash",
          },
        ],
      },
      [accounts[0], "Eunha", "19 years old, school girl", "0x123123123123"]
    );

    const result = await humanGovernor.propose(
      [humanNFT.address],
      [13],
      [calldata],
      "MINT HUMAN!",
      {
        from: accounts[0],
      }
    );

    proposalId = result?.logs[0]?.args?.proposalId;
    assert.equal(!!proposalId, true, " check proposalId => exist");
    // 0 = Against (반대), 1 = For (찬성), 2 = Abstain (기권),

    // afterEach(async () => {
    //   await web3.utils.advanceBlockAtTime(now.plus(20).toNumber());

    //   const voteBalance = await humanGovernor.castVote(proposalId, 1);
    // });

    // assert.equal(voteBalance, 100123, "voteBalance =? 100");
  });

  // it("send token", async () => {
  //   const humanERC20Instance = await HumanERC20.deployed();
  //   const account0Balance = await humanERC20Instance.balanceOf(accounts[0]);
  //   await humanERC20Instance.transfer(accounts[1], 1000000, {
  //     from: accounts[0],
  //   });
  //   const account1Balance = await humanERC20Instance.balanceOf(accounts[1]);

  //   assert.equal(
  //     account0Balance.valueOf(),
  //     1000000000 * 10 ** 18 - 1000000,
  //     "1000000000 * 10 ** 18 wasn't in the first account"
  //   );
  //   assert.equal(account1Balance.valueOf(), 1000000, "error send!");
  // });

  // it("should send coin correctly", async () => {
  //   const metaCoinInstance = await MetaCoin.deployed();

  //   // Setup 2 accounts.
  //   const accountOne = accounts[0];
  //   const accountTwo = accounts[1];

  //   // Get initial balances of first and second account.
  //   const accountOneStartingBalance = (
  //     await metaCoinInstance.getBalance.call(accountOne)
  //   ).toNumber();
  //   const accountTwoStartingBalance = (
  //     await metaCoinInstance.getBalance.call(accountTwo)
  //   ).toNumber();

  //   // Make transaction from first account to second.
  //   const amount = 10;
  //   await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

  //   // Get balances of first and second account after the transactions.
  //   const accountOneEndingBalance = (
  //     await metaCoinInstance.getBalance.call(accountOne)
  //   ).toNumber();
  //   const accountTwoEndingBalance = (
  //     await metaCoinInstance.getBalance.call(accountTwo)
  //   ).toNumber();

  //   assert.equal(
  //     accountOneEndingBalance,
  //     accountOneStartingBalance - amount,
  //     "Amount wasn't correctly taken from the sender"
  //   );
  //   assert.equal(
  //     accountTwoEndingBalance,
  //     accountTwoStartingBalance + amount,
  //     "Amount wasn't correctly sent to the receiver"
  //   );
  // });
});
