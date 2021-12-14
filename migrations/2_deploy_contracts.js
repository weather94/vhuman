const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");
const HumanERC20Staker = artifacts.require("HumanERC20Staker");
const HumanGovernor = artifacts.require("HumanGovernor");
const HumanConverter = artifacts.require("HumanConverter");
const HumanAuction = artifacts.require("HumanAuction");
const SHumanERC721 = artifacts.require("SHumanERC721");

module.exports = async function (deployer) {
  await deployer.deploy(Human, "0xffffffffffffffffffffffffffffffffffffffff");
  await deployer.deploy(HumanERC20);
  await deployer.deploy(SHumanERC20);
  await deployer.deploy(HumanERC20Staker);
  await deployer.deploy(HumanGovernor, (await SHumanERC20.deployed()).address);
  await deployer.deploy(HumanConverter);
  await deployer.deploy(HumanAuction);
  await deployer.deploy(SHumanERC721);
};
