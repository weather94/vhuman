const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");
const HumanERC20Staker = artifacts.require("HumanERC20Staker");
const HumanGovernor = artifacts.require("HumanGovernor");
const HumanConverter = artifacts.require("HumanConverter");

module.exports = async function (deployer) {
  const humanNFT = await Human.deployed();
  const humanERC20 = await HumanERC20.deployed();
  const sHumanERC20 = await SHumanERC20.deployed();
  const humanERC20Staker = await HumanERC20Staker.deployed();
  const humanGovernor = await HumanGovernor.deployed();
  const humanConverter = await HumanConverter.deployed();

  humanNFT.transferOwnership(humanGovernor.address);
  sHumanERC20.transferOwnership(humanERC20Staker.address);

  humanERC20Staker.setHumanERC20(humanERC20.address);
  humanERC20Staker.setSHumanERC20(sHumanERC20.address);

  humanConverter.setHumanERC721(humanNFT.address);
  humanConverter.setHumanERC20(humanERC20.address);
  humanConverter.setHumanERC20Staker(humanERC20Staker.address);

  humanConverter.setConverterFee(10000000 * 10 ** 18);
  humanConverter.transferOwnership(humanGovernor.address);
};
