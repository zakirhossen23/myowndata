export default async function handler(req, res) {
	try {
		let FixCors = await import("../../../contract/fixCors.js");
		await FixCors.default(res);
	} catch (error) {}

	let useContract = await import("../../../contract/useContract.ts");
	const {contract, signerAddress} = await useContract.default();
	
	let userdetails = await contract.getUserDetails(Number(req.query.userid)).call();
	let fhir_element = await contract._fhirMap(Number(req.query.userid)).call();

	var bDate = new Date(fhir_element.birth_date);
	var nDate =new Date()
	let currentAge = nDate.getFullYear()- bDate.getFullYear();

	var newFhir = {
		id: Number(fhir_element.user_id),
		family_name: fhir_element.family_name,
		given_name: fhir_element.given_name,
		identifier: fhir_element.identifier,
		phone: fhir_element.phone,
		gender: fhir_element.gender,
		birth_date: fhir_element.birth_date,
		age:currentAge,
		about: fhir_element.about,
		patient_id: fhir_element.patient_id,
		privatekey: userdetails[4] + "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
		image: fhir_element.image,
		credits: fhir_element.credits
	};
	if (newFhir.patient_id === "") {
		newFhir = null;
	}

	res.status(200).json({value: newFhir});
}

