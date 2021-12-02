const Human = artifacts.require("Human");
const HumanERC20 = artifacts.require("HumanERC20");

module.exports = function (deployer) {
  deployer.deploy(Human, "0xffffffffffffffffffffffffffffffffffffffff");
  deployer.deploy(HumanERC20);
};
