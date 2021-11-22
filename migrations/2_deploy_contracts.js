const Human = artifacts.require("Human");

module.exports = function (deployer) {
  deployer.deploy(Human, "0xffffffffffffffffffffffffffffffffffffffff");
};
