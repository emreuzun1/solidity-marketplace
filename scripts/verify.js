const hre = require("hardhat");

async function main() {
  await hre.run("verify:verify", {
    address: "0x7826d461E7ef6Ae101D903a784A15c74E6b0ED60",
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
