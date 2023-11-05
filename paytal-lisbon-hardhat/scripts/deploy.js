// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const Lock = await hre.ethers.getContractFactory("PaytalLisbon");
  const lock = await Lock.deploy(
    "0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83",
    "0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1",
    "0x9C58BAcC331c9aa871AFD802DB6379a98e80CEdb",
    "0x1173da1811a311234e7Ab0A33B4B7B646Ff42aEC",
    "0xc8A1F9461115EF3C1E84Da6515A88Ea49CA97660",
    "0xA28dCaB66FD25c668aCC7f232aa71DA1943E04b8",
  );

  await lock.deployed();

  console.log("Deployed at: ", lock.address);

  // console.log(
  //   `Lock with ${ethers.utils.formatEther(
  //     lockedAmount
  //   )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  // );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
