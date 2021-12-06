const HumanERC20 = artifacts.require("HumanERC20");

contract("HumanERC20", (accounts) => {
  it("should put 1000000000 * 10 ** 18 HumanERC20 in the first account", async () => {
    const humanERC20Instance = await HumanERC20.deployed();
    const balance = await humanERC20Instance.balanceOf(accounts[0]);

    assert.equal(
      balance.valueOf(),
      1000000000 * 10 ** 18,
      "1000000000 * 10 ** 18 wasn't in the first account"
    );
  });

  it("send token", async () => {
    const humanERC20Instance = await HumanERC20.deployed();
    const account0Balance = await humanERC20Instance.balanceOf(accounts[0]);
    await humanERC20Instance.transfer(accounts[1], 1000000, {
      from: accounts[0],
    });
    const account1Balance = await humanERC20Instance.balanceOf(accounts[1]);

    assert.equal(
      account0Balance.valueOf(),
      1000000000 * 10 ** 18 - 1000000,
      "1000000000 * 10 ** 18 wasn't in the first account"
    );
    assert.equal(account1Balance.valueOf(), 1000000, "error send!");
  });

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
