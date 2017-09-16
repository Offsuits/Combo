var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Deck = artifacts.require("./Deck.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Deck);
};
