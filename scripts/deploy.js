const hre = require("hardhat");

async function main() {
  /* const AdessoOKR = await hre.ethers.getContractFactory("AdessoOKR");
  const adessoOKR = await AdessoOKR.deploy(
    "0xF34539e55173c6ed56fb973A02b3BE2Fe56BD9f3"
  );

  await adessoOKR.waitForDeployment();

  console.log("Deployed to:", adessoOKR.target); */

  const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  const marketPlace = await Marketplace.deploy();

  await marketPlace.waitForDeployment();

  console.log("Deployed to:", marketPlace.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
