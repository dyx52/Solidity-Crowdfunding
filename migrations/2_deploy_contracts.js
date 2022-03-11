var SimpleStorage = artifacts.require("./CrowdFunding.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
};
