import { ethers } from 'ethers'
export default async function handler(req, res) {
  try {
    let FixCors = await import("../../../../contract/fixCors.js");
    await FixCors.default(res);
  } catch (error) { }



    let useContract = await import("../../../../contract/useContract.ts");
  const { contract, signerAddress } = await useContract.default();

  if (req.method !== 'POST') {
    res.status(405).json({ status: 405, error: "Method must have POST request" })
    return;
  }

  const { userid, date, studyid } = req.body;


  await contract.CreateCompletedInformedConsent(Number(userid), date, Number(studyid)).send({
    feeLimit: 1_000_000_000,
    shouldPollResponse: false
  });

  res.status(200).json({ status: 200, value: "Created" })

}
