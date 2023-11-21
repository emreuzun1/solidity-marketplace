const hre = require("hardhat");

async function main() {
  await hre.run("verify:verify", {
    address: "0xF446adad2445302a849a6A4D6D64D8fC94E5Ad1a",
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
