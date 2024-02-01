
export default async function handler(req, res) {
  try {
    let FixCors = await import("../../../../contract/fixCors.js");
    await FixCors.default(res);
  } catch (error) { }

  let useContract = await import("../../../../contract/useContract.ts");
  const { contract, signerAddress } = await useContract.default();

  let study_id = await contract.GetOngoingStudy(Number(req.query.userid)).call();
  if (study_id !== "False") {

    let study_element = await contract._studyMap(Number(study_id)).call();
    var newStudy = {
      id: Number(study_element.study_id),
      title: study_element.title,
      image: study_element.image,
      description: study_element.description,
      contributors: Number(study_element.contributors),
      audience: Number(study_element.audience),
      budget: Number(study_element.total_spending_limit)
    };
    let all_surveys = await contract.getAllSurveysIDByStudy(Number(study_id)).call();

    let all_study_surveys = [];
    for (let i = 0; i < all_surveys.length; i++) {
      let survey_element = await contract._surveyMap(Number(all_surveys[i])).call();

      var new_survey = {
        id: Number(survey_element.survey_id),
        study_id: Number(survey_element.study_id),
        user_id: Number(survey_element.user_id),
        name: survey_element.name,
        description: survey_element.description,
        date: survey_element.date,
        image: survey_element.image,
        reward: Number(survey_element.reward),
        submission: Number(survey_element?.submission)
      };
      all_study_surveys.push(new_survey);
    }

    let all_completed_surveys = await contract.getAllCompletedSurveysIDByUser(Number(req.query.userid)).call();
    let all_study_completed_surveys = [];

    for (let i = 0; i < all_completed_surveys.length; i++) {
      let completed_survey_element = await contract._completedsurveyMap(Number(all_completed_surveys[i])).call();
      var new_completed_survey = {
        id: Number(completed_survey_element.completed_survey_id),
        study_id: Number(completed_survey_element.study_id),
        user_id: Number(completed_survey_element.user_id),
        survey_id: Number(completed_survey_element.survey_id),
        date: completed_survey_element.date,
      };
      if (new_completed_survey.study_id === Number(study_id)) {
        all_study_completed_surveys.push(new_completed_survey);
      }
    }

    let completed_informed_consent = await contract.getCompletedInformedConsentId(Number(req.query.userid), Number(study_id)).call();

    if (completed_informed_consent !== "False") {
      let new_completed_informed_consent = await contract._completedinformedMap(Number(completed_informed_consent)).call();

      completed_informed_consent = {
        id: Number(new_completed_informed_consent.completed_informed_consent_id),
        study_id: Number(new_completed_informed_consent.study_id),
        user_id: Number(new_completed_informed_consent.user_id),
        date: new_completed_informed_consent.date,
      }
    }

    let finalObject = {
      Study: newStudy,
      Survey: all_study_surveys,
      Completed: all_study_completed_surveys,
      CompletedInformed: completed_informed_consent
    }

    res.status(200).json({ status: 200, value: JSON.stringify(finalObject) })
    return;
  }

  res.status(400).json({ status: 400, value: "None" })

}
