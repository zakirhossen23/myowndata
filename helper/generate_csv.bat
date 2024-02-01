@echo off

echo Creating users.csv...
echo user_id,name,email,password,walletaddress,walletaddress_address,privatekey,image,credits,accesstoken,fhirid > users.csv

echo Creating studies.csv...
echo study_id,user_id,image,title,description,permission,contributors,audience,budget,reward_type,reward_price,total_spending_limit > studies.csv

echo Creating surveys.csv...
echo survey_id,study_id,user_id,name,description,date,image,reward,submission > surveys.csv

echo Creating fhir.csv...
echo user_id,family_name,given_name,identifier,phone,gender,birth_date,about,patient_id > fhir.csv

echo Creating ongoing_studies.csv...
echo ongoing_id,study_id,user_id,date,given_permission > ongoing_studies.csv

echo Creating survey_question_answers.csv...
echo answer_id,study_id,user_id,survey_id,section_id,question_id,answer > survey_question_answers.csv

echo Creating completed_surveys.csv...
echo completed_survey_id,study_id,user_id,survey_id,date > completed_surveys.csv

echo Creating completed_informed_consent.csv...
echo completed_informed_consent_id,study_id,user_id,date > completed_informed_consent.csv

echo CSV files created successfully!
