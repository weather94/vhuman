const Human = artifacts.require("Human");
const SHumanERC721 = artifacts.require("SHumanERC721");
const HumanERC20 = artifacts.require("HumanERC20");
const SHumanERC20 = artifacts.require("SHumanERC20");
const HumanERC20Staker = artifacts.require("HumanERC20Staker");
const HumanGovernor = artifacts.require("HumanGovernor");
const HumanConverter = artifacts.require("HumanConverter");
const HumanAuction = artifacts.require("HumanAuction");

module.exports = async function (deployer) {
  const humanNFT = await Human.deployed();
  const sHumanERC721 = await SHumanERC721.deployed();
  const humanERC20 = await HumanERC20.deployed();
  const sHumanERC20 = await SHumanERC20.deployed();
  const humanERC20Staker = await HumanERC20Staker.deployed();
  const humanGovernor = await HumanGovernor.deployed();
  const humanConverter = await HumanConverter.deployed();
  const humanAuction = await HumanAuction.deployed();

  // humanNFT.transferOwnership(humanGovernor.address);

  humanERC20.transfer(
    "0x44fe0b09917ebeBC7EBFe1c98D2d048225845BEf",
    web3.utils.toWei("10000000", "ether")
  );

  sHumanERC721.transferOwnership(humanConverter.address);

  sHumanERC20.transferOwnership(humanERC20Staker.address);

  humanERC20Staker.setHumanERC20(humanERC20.address);
  humanERC20Staker.setSHumanERC20(sHumanERC20.address);

  humanConverter.setSHumanERC721(sHumanERC721.address);
  humanConverter.setHumanERC721(humanNFT.address);
  humanConverter.setHumanERC20(humanERC20.address);
  humanConverter.setHumanERC20Staker(humanERC20Staker.address);

  humanConverter.setConverterFee(web3.utils.toWei("1000000", "ether"));

  humanAuction.setHumanERC721(humanNFT.address);
  humanAuction.setHumanERC20(humanERC20.address);
  // humanConverter.transferOwnership(humanGovernor.address);
};
