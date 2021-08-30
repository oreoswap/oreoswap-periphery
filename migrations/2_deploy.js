const Router = artifacts.require("OreoswapV1Router02.sol");
const WBNB = artifacts.require("WBNB.sol");

module.exports = async function (deployer, network, addresses){
	let weth;
	const FACTORY_ADDRESS = '0xC93F0b80Cf9e225c17D0a3A490444A1DfEEa605C';
	
	if (network === "mainnet"){
		weth = await WBNB.at("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2");
	}
	else{
	await deployer.deploy(WBNB);
	weth = await WBNB.deployed();
	}
	await deployer.deploy(Router,FACTORY_ADDRESS,weth.address);
};
