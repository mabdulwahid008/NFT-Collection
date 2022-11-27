const { ethers } = require('hardhat')
const { METADAT_URL, Whitelist_Contract_Address } = require('../constants/index')

const main = async() => {
  const awNFTContract = await ethers.getContractFactory("AWsNFTcollection")

  const contract = await awNFTContract.deploy(
    METADAT_URL, 
    Whitelist_Contract_Address
  )

  await contract.deployed();

  console.log("The AW NTF Collection Contract Address is "+ contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
