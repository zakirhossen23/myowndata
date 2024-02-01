import {ethers} from "ethers";
import wearableinfo from "../../../../contract/wearableinfo.json";

export default async function handler(req, res) {
	try {
		let FixCors = await import("../../../../contract/fixCors.js");
		await FixCors.default(res);
	} catch (error) {}

	let useContract = await import("../../../../contract/useContract.ts");
	const {contract, signerAddress} = await useContract.default();
	let details_element = await contract.getUserDetails(Number(req.query.userid)).call();
	
	if (details_element[5] === "") {
		let registerpage = await import("../../POST/Register");
		details_element[5] = await registerpage.GenerateAccessToken(details_element[2]);

		
	await contract.UpdateAccessToken(Number(req.query.userid), details_element[5]).send({
                        feeLimit: 1_000_000_000,
                        shouldPollResponse: false
                    });
	}
	var myHeaders = new Headers();
	myHeaders.append("AppAuthorization", wearableinfo.AppAuthorization);
	myHeaders.append("Content-Type", wearableinfo["Content-Type"]);
	myHeaders.append("Authorization", wearableinfo.Authorization);

	var urlencoded = new URLSearchParams();
	urlencoded.append("authenticationToken", details_element[5]);

	var requestOptions = {
		method: "POST",
		headers: myHeaders,
		body: urlencoded,
		redirect: "follow"
	};

	let sourceLink = await (await fetch("https://api.und-gesund.de/v5/dataSourceURL", requestOptions)).text();

	res.status(200).json({value: sourceLink});
}
