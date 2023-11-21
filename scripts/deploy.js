const hre = require("hardhat");

async function main() {
  const Adesso = await hre.ethers.getContractFactory("Adesso");
  const adesso = await Adesso.deploy();

  await adesso.waitForDeployment();

  console.log("Deployed to:", adesso.target);

  /* const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  const marketPlace = await Marketplace.deploy();

  await marketPlace.waitForDeployment();

  console.log("Deployed to:", marketPlace.target); */
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
