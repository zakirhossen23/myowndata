
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


	const privateKey = 'e95a71ad92a8a28ece70f4fcf8a2d98eeb0eade2e7972040c524c1ac993c9e8f';
	const contractAdd = 'TQCPm73iFCXM47T2889C2ELfDouKy4ApE8';
export default async function useContract() {
	
	let contractInstance = {
		contract: null,
		signerAddress: null
	}
	const tronWeb = new TronWeb(fullNode, solidityNode, eventServer, privateKey);
	contractInstance.signerAddress =  tronWeb.address.fromPrivateKey(privateKey);
	contractInstance.contract = await tronWeb.contract().at(contractAdd);

	return contractInstance;
}
export async function getContractFromKey(privateKey){
	
	const tronWeb = new TronWeb(fullNode, solidityNode, eventServer, privateKey);
	return  await tronWeb.contract().at(contractAdd);
}

export function base64DecodeUnicode(base64String) {
	return Buffer.from(base64String, "base64").toString('utf8');
}
