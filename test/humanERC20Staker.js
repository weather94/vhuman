const HumanERC20Staker = artifacts.require("HumanERC20Staker");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");

contract("HumanERC20Staker", (accounts) => {
  it("test stake", async () => {
    const humanERC20Instance = await HumanERC20.deployed();
    const shumanERC20Instance = await SHumanERC20.deployed();
    const humanERC20Staker = await HumanERC20Staker.deployed();

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

    await shumanERC20Instance.approve(
      humanERC20Staker.address,
      web3.utils.toWei("1000000", "ether"),
      {
        from: accounts[0],
      }
    );
    await humanERC20Staker.unstake(web3.utils.toWei("1000000", "ether"), {
      from: accounts[0],
    });
    const balance2 = await shumanERC20Instance.balanceOf(accounts[0]);

    assert.equal(balance2.valueOf(), 0, "shuman value 0");
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
