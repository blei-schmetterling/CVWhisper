const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const ContractFactory = (await ethers.getContractFactory("JobContract"));
    ContractFactory.attach("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")

    const contract = await ContractFactory.deploy();


    console.log("JobContract address:", contract.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
