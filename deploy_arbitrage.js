const hre = require("hardhat");

async function main() {
  // Aave V3 Pool Addresses Provider (Ethereum Mainnet)
  const AAVE_ADDRESS_PROVIDER = "0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e";

  const FlashLoan = await hre.ethers.getContractFactory("FlashLoanArbitrage");
  const flashLoan = await FlashLoan.deploy(AAVE_ADDRESS_PROVIDER);

  await flashLoan.waitForDeployment();
  console.log(`FlashLoan Executor deployed to: ${await flashLoan.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
