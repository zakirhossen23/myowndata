import {ethers} from 'ethers'
export default async function handler(req, res) {
  try {
    let FixCors = await import("../../../../../contract/fixCors.js");
    await FixCors.default(res);
  } catch (error) {}



  let useContract = await import("../../../../../contract/useContract.ts");
  const {contract, signerAddress} = await useContract.default();
    
  if (req.method !== 'POST') {
    res.status(405).json({ status: 405, error: "Method must have POST request" })
    return;
  }

  const { surveyid, userid, date, studyid } = req.body;

	let survey_element = await contract._surveyMap(Number(surveyid)).call();
  
	let details_element = await contract.getUserDetails(Number(userid)).call();
  
  
  let credits = Number(details_element[1]) + (Number(survey_element.reward)* 1e6)

  
  await contract.UpdateUser(Number(userid), details_element[0], Number(credits)).send({
                        feeLimit: 1_000_000_000,
                        shouldPollResponse: false
                    });
  
  await contract.CreateCompletedSurveys(Number(surveyid), Number(userid), date, Number(studyid)).send({
                        feeLimit: 1_000_000_000,
                        shouldPollResponse: false
                    });

  res.status(200).json({ status: 200, value: "Created" })

}
