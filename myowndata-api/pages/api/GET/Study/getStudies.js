
export default async function handler(req, res) {
  try {
    let FixCors = await import("../../../../contract/fixCors.js");
    await FixCors.default(res);
  } catch (error) {}
  
  let useContract = await import("../../../../contract/useContract.ts");
  const {contract, signerAddress} = await useContract.default();

  let Studies = [];
  let TotalStudies = await contract._StudyIds().call();
  for (let i = 0; i < Number(TotalStudies); i++) {
    let study_element = await contract._studyMap(Number(i)).call();

    //Load Study Title
    let study_title = {};
    let study_Data_element = await contract._studyTitles(Number(i)).call();
    let parsed_study = JSON.parse(study_Data_element);
    if (study_Data_element == "") {
      study_title= {};
    } else {
      study_title = parsed_study;
    }

    
    //Load Subjects
    let new_subjects = [];
    let total_subs = Number(await contract._SubjectIds().call());
    for (let i = 0; i < total_subs; i++) {
      const element = await contract._studySubjects(i).call();

      if (Number(element.study_id) === Number(study_element.study_id)) {
        new_subjects.push({
          subject_id: Number(element.subject_id),
          study_id: Number(element.study_id),
          subject_index_id: element.subject_index_id,
          "title": element.title,
          ages_ans: JSON.parse(element.ages_ans),
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
      permissions: study_element.permission,
      study_title:study_title,
      subjects:new_subjects
    };

    Studies.push(newStudy);
  }
  res.status(200).json({ value: JSON.stringify(Studies) })
}
