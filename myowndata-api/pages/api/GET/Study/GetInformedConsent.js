
export default async function handler(req, res) {
  try {
    let FixCors = await import("../../../../contract/fixCors.js");
    await FixCors.default(res);
  } catch (error) { }

  let useContract = await import("../../../../contract/useContract.ts");
  const { contract, signerAddress } = await useContract.default();
  const { study_id, user_id } = req.query;

  //Current Age
  let fhir_element = await contract._fhirMap(Number(user_id)).call();
  var bDate = new Date(fhir_element.birth_date);
  var nDate = new Date()
  let currentAge = nDate.getFullYear() - bDate.getFullYear(); //36


  let study_element = await contract._studyMap(Number(study_id)).call();

  //Load Ages
  let ages_Data_element = await contract._studyAges(Number(study_element.study_id)).call();
  let ages_groups = (ages_Data_element == "" ? [] : JSON.parse(ages_Data_element));


  //Elligible Age
  let eligible_age_group = ages_groups.filter((val) => {
    if (!val.older) {
      //20 < 36 && 36 < 25
      if (val.from < currentAge && currentAge < val.to) {
        return true;
      }
    } else {
      // 25 < 36 
      if (val.from < currentAge) return true;
    }
    return false;
  });

  //Load Study Title
  let study_title = {};
  let study_Data_element = await contract._studyTitles(Number(study_element.study_id)).call();
  let parsed_study = JSON.parse(study_Data_element);
  try {

    if (study_Data_element == "") {
      study_title = {};
    } else {
      study_title = parsed_study;
    }
  } catch (e) {
    study_title = {};
  }


  //Elligible 
  let study_title_elligible = "";
  if (eligible_age_group.length > 0) {
    study_title_elligible = study_title[eligible_age_group[0]?.id];
  }


  //Load Subjects
  let new_subjects = [];
  let total_subs = Number(await contract._SubjectIds().call());
  for (let i = 0; i < total_subs; i++) {
    const element = await contract._studySubjects(i).call();

    if (Number(element.study_id) === Number(study_element.study_id)) {
      let elligible_ages_ans = {};
      if (eligible_age_group.length > 0) {
        elligible_ages_ans = JSON.parse(element.ages_ans)[eligible_age_group[0]?.id];
      }


      new_subjects.push({
        subject_id: Number(element.subject_id),
        study_id: Number(element.study_id),
        subject_index_id: element.subject_index_id,
        "title": element.title,
        ages_ans: elligible_ages_ans,
      })

    }
  }


  var newStudy = {
    id: Number(study_element.study_id),
    title: study_element.title,
    image: study_element.image,
    description: study_element.description,
    contributors: Number(study_element.contributors),
    audience: Number(study_element.audience),
    budget: Number(study_element.budget),
    permissions: (study_element.permission),
    study_title: study_title_elligible,
    subjects: new_subjects,
    ages_groups: ages_groups,
    eligible_age_group: eligible_age_group
  };



  res.status(200).json({ status: 200, value: JSON.stringify(newStudy) })
  return;

}
