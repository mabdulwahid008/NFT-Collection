require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: process.env.NETWORK_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
