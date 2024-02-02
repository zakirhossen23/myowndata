import { useState, useEffect } from 'react';
import TronWeb from 'tronweb';
	// //Mainnet
	// const fullNode = 'https://api.trongrid.io';
	// const solidityNode = 'https://api.trongrid.io';
	// const eventServer = 'https://api.trongrid.io';

	// //Nile
	// const fullNode = 'https://api.nileex.io';
	// const solidityNode = 'https://api.nileex.io';
	// const eventServer = 'https://event.nileex.io';

	//Shasta
	const fullNode = 'https://api.shasta.trongrid.io';
	const solidityNode = 'https://api.shasta.trongrid.io';
	const eventServer = 'https://api.shasta.trongrid.io';

	const privateKey = '8fa252b31ea9c1f97ee85fbcb8596637c2f1d9374b83e241df33fd953c68bdb4';
	const contractAdd = 'TQCPm73iFCXM47T2889C2ELfDouKy4ApE8';


declare let window;
export default function useContract() {
	const fetchData = async () => {
		await sleep(200);
		try {
			// const contract = { contract: null, signerAddress: null, fD: fetchData };

			// if (window.localStorage.getItem("type") === "tronlink"){
			// 	contract.contract =  await window?.tronWeb?.contract().at(contractAdd);
			// 	contract.signerAddress =  window?.tronWeb?.defaultAddress?.base58;
			// 	window.contract = contract.contract;
			// 	setContractInstance(contract);
			// }else{
			// 	const tronWeb = new TronWeb(fullNode, solidityNode, eventServer, privateKey);
			// 	contract.signerAddress =  tronWeb.address.fromPrivateKey(privateKey);
			// 	contract.contract = await tronWeb.contract().at(contractAdd);
			// 	window.contract = contract.contract;
			// 	setContractInstance(contract);
			// }
		} catch (error) {
			console.error(error);
		}
	};
	const [contractInstance, setContractInstance] = useState({
		contract: null,
		signerAddress: null,
		fD: fetchData,
	});
	function sleep(ms) {
		return new Promise(resolve => setTimeout(resolve, ms));
	 }
	
	useEffect(() => {
		

		fetchData();
	}, []);

	return contractInstance;
}