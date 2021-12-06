const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");
const HumanERC20Staker = artifacts.require("HumanERC20Staker");
const HumanGovernor = artifacts.require("HumanGovernor");
const HumanConverter = artifacts.require("HumanConverter");

module.exports = async function (deployer) {
  await deployer.deploy(Human, "0xffffffffffffffffffffffffffffffffffffffff");
  await deployer.deploy(HumanERC20);
  await deployer.deploy(SHumanERC20);
  await deployer.deploy(HumanERC20Staker);
  await deployer.deploy(HumanGovernor, (await SHumanERC20.deployed()).address);
  await deployer.deploy(HumanConverter);
};
