// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./lib/Strings.sol";

contract MyOwnData {
    /// User contains all the login information
    struct user_struct {
        /// The ID of the User ID.
        uint256 user_id;
        ///Full Name of user
        string name;
        ///Email of user
        string email;
        ///Password of user
        string password;
        ///Address of Wallet
        string walletaddress; 
        ///Address of Wallet in Address Type
        address walletaddress_address;
        ///Privatekey of user
        string privatekey;
        /// The User Image
        string image;
        /// The User Credits
        uint256 credits;
        /// The Access Token of wearable
        string accesstoken;
        /// The Fhir ID of the User.
        uint256 fhirid;
    }

    /// Survy Category Struct contains all the Category information
    struct survey_category_struct {
        ///Name of Category
        string name;
        ///Image Link of Category
        string image;
    }

    /// Study Struct contains all the study information
    struct study_struct {
        /// The ID of the Study ID.
        uint256 study_id;
        /// The ID of the User ID.
        uint256 user_id;
        /// The Image of the Study
        string image;
        /// The Title of the Study
        string title;
        /// The Description of the Study
        string description;
        /// The Data permission of the Study
        string permission;
        /// The Contributors of the Study
        uint256 contributors;
        /// The Audience of the Study
        uint256 audience;
        /// The Budget of the Study
        uint256 budget;
        /// The Type of the Reward.
        string reward_type;
        /// The Price of the Reward.
        uint256 reward_price;
        /// The Total Spending Limit of the Study.
        uint256 total_spending_limit;
    }

 
    /// Study Informed Consent subject Struct 
    struct subject_struct {
        /// The ID of the Study ID.
        uint256 study_id;
        uint256 subject_id;
        string subject_index_id;
        string title;
        string ages_ans;
    }
    
    
    /// Survey Struct contains all the survey information
    struct survey_struct {
        /// The ID of the Survey ID.
        uint256 survey_id;
        /// The ID of the Study ID.
        uint256 study_id;
        /// The ID of the User ID.
        uint256 user_id;
        /// The Name of the Survey
        string name;
        /// The Description of the Survey
        string description;
        /// The Date of the Survey
        string date;
        /// The Image of the Survey
        string image;
        /// The Reward of the Survey
        uint256 reward;
        /// The Submission of the Survey
        uint256 submission;
    }

    /// FHIR user information
    struct fhir_struct {
        /// User ID of the user
        uint256 user_id;
        /// Family Name in FHIR
        string family_name;
        /// Given Name in FHIR
        string given_name;
        /// Identifier of the user FHIR
        string identifier;
        /// Phone of the user FHIR
        string phone;
        /// Sex of the user FHIR
        string gender;
        /// Birth Date of the user FHIR
        string birth_date;
        /// About of the user FHIR
        string about;
        /// The Patient ID of the user FHIR
        string patient_id;
    }

    /// OnGoing Study
    struct ongoing_struct {
        uint256 ongoing_id;
        uint256 study_id;
        uint256 user_id;
        string date;
        string given_permission;
    }

    /// Question Answers of Survey
    struct survey_question_answer_struct {
        uint256 answer_id;
        uint256 study_id;
        uint256 user_id;
        uint256 survey_id;
        string section_id;
        string question_id;
        string answer;
    }

    /// Completed Survey Study
    struct completed_survey_struct {
        uint256 completed_survey_id;
        uint256 study_id;
        uint256 user_id;
        uint256 survey_id;
        string date;
    }
    /// Completed Informed Consent Study
    struct completed_informed_consent_struct {
        uint256 completed_informed_consent_id;
        uint256 study_id;
        uint256 user_id;
        string date;
    }
    /// Paid Survey Study
    struct paid_survey_struct {
        uint256 paid_survey_id;
        uint256 study_id;
        uint256 user_id;
        uint256 survey_id;
        string date;
    }

    uint256 public _UserIds;
    uint256 public _FhirIds;
    uint256 public _StudyIds;
    uint256 public _SubjectIds;
    uint256 public _SurveyIds;
    uint256 public _SurveyCategoryIds;
    uint256 public _OngoingIds;
    uint256 public _AnsweredIds;
    uint256 public _CompletedSurveyIds;
    uint256 public _CompletedInformedConsentIds;

    /// The map of all the Users login information.
    mapping(uint256 => user_struct) private _userMap;
    /// The map of all the Studies information.
    mapping(uint256 => study_struct) public _studyMap;
    mapping(uint256 => string) public _studyAges;
    mapping(uint256 => subject_struct) public _studySubjects;
    mapping(uint256 => string) public _studyTitles; //study id => Study title ages groups answers JSON
    /// The map of all the Rewards information.
    mapping(uint256 => string) public _studyAudienceMap; //study id => Audience JSON
    /// The map of all the Surveys information.
    mapping(uint256 => survey_struct) public _surveyMap;
    /// The map of all the Survey Category .
    mapping(uint256 => survey_category_struct) public _categoryMap;
    /// The map of all the Survey Sections  .
    mapping(uint256 => string) public _sectionsMap; //Survey id => All sections

    /// The map of all the FHIR information.
    mapping(uint256 => fhir_struct) public _fhirMap; //User id => user FHIR
    /// The map of all the OnGoing Studies.
    mapping(uint256 => ongoing_struct) public _ongoingMap;
    /// The map of all the Question Answerd in a Survey.
    mapping(uint256 => survey_question_answer_struct)
        public _questionanswerdMap;
    /// The map of all the Completed Surveys.
    mapping(uint256 => completed_survey_struct) public _completedsurveyMap;

    /// The map of all the Completed Informed Consent.
    mapping(uint256 => completed_informed_consent_struct) public _completedinformedMap;

    address public owner;

    //Login User
    function CheckEmail(string memory email)
        public
        view
        returns (string memory)
    {
        ///Getting the found account
        for (uint256 i = 0; i < _UserIds; i++) {
            if (
                keccak256(bytes(_userMap[i].email)) == keccak256(bytes(email))
            ) {
                ///Returning user id
                return Strings.toString(i);
            }
        }

        ///Returning False if not found user
        return "False";
    }

    //CreateAccount
    function CreateAccount(
        string memory full_name,
        string memory birth_date,
        string memory email,
        string memory password,
        string memory accesstoken,
        string memory walletaddress

    ) public {
        address walletaddress_address = msg.sender;
        // Store the metadata of user in the map.
        _userMap[_UserIds] = user_struct({
            user_id: _UserIds,
            name: full_name,
            email: email,
            password: password,
            privatekey: "",
            walletaddress:walletaddress,
            image: "https://i.postimg.cc/SsxGw5cZ/person.jpg",
            credits: 0,
            accesstoken: accesstoken,
            fhirid:0,
            walletaddress_address: walletaddress_address
        });
        _fhirMap[_UserIds].birth_date = birth_date;


        _UserIds++;
    }
     

    //Update Privatekey
    function UpdatePrivatekey(uint256 userid, string memory privatekey) public {
     
        _userMap[userid].privatekey = privatekey;
    }

    //Update AccessToken
    function UpdateAccessToken(uint256 userid, string memory accesstoken)
        public
    {
        _userMap[userid].accesstoken = accesstoken;
    }

    //Login User
    function Login(string memory email, string memory password)
        public
        view
        returns (string memory)
    {
        ///Getting the found account
        for (uint256 i = 0; i < _UserIds; i++) {
            if (
                keccak256(bytes(_userMap[i].email)) ==
                keccak256(bytes(email)) &&
                keccak256(bytes(_userMap[i].password)) ==
                keccak256(bytes(password))
            ) {
                ///Returning user id
                return Strings.toString(i);
            }
        }

        ///Returning False if not found user
        return "False";
    }

    //Create Study
    function CreateStudy(
        uint256 user_id,
        string memory image,
        string memory title,
        string memory description,
        string memory permission,
        uint256 contributors,
        uint256 audience,
        uint256 budget
    ) public {
        // Store the metadata of Study in the map.
        _studyMap[_StudyIds] = study_struct({
            study_id: _StudyIds,
            user_id: user_id,
            image: image,
            title: title,
            description: description,
            permission: permission,
            contributors: contributors,
            audience: audience,
            budget: budget,
            reward_type: "Points",
            reward_price: 0,
            total_spending_limit: budget
        });
        _studyAges[_StudyIds] = "";
        _StudyIds++;
    }


    //Create Subject
    function CreateSubject(
        uint256 study_id,
        string memory subject_index_id,
        string memory title,
        string memory ages_ans
    ) public {
        // Store the metadata of Subject in the map.
        _studySubjects[_SubjectIds] = subject_struct({
            study_id: study_id,
            subject_id: _SubjectIds,
            subject_index_id: subject_index_id,
            title:title,
            ages_ans:ages_ans
        });
        
        _SubjectIds++;
    }

    //Update Subject
    function UpdateSubject(
        uint256 subject_id,
        string memory title,
        string memory ages_ans
    ) public {
        // Update the metadata of Subject in the map.
        _studySubjects[subject_id].title= title;
        _studySubjects[subject_id].ages_ans= ages_ans;
    }
  
    //Update Study Consent Title
    function UpdateStudyTitle(
        uint256 study_id,
        string memory ages_ans
    ) public {
        _studyTitles[study_id]= ages_ans;

    }

    //Create Survey
    function CreateSurvey(
        uint256 study_id,
        uint256 user_id,
        string memory name,
        string memory description,
        string memory date,
        string memory image,
        uint256 reward
    ) public payable {
        // Store the metadata of Survey in the map.
        _surveyMap[_SurveyIds] = survey_struct({
            survey_id: _SurveyIds,
            study_id: study_id,
            user_id: user_id,
            name: name,
            description: description,
            date: date,
            image: image,
            reward: reward,
            submission: 0
        });
        _SurveyIds++;
    }

    //Create or Save Sections
    function CreateOrSaveSections(uint256 survey_id, string memory metadata)
        public
    {
        // Store the metadata of all Sections in the map.
        _sectionsMap[survey_id] = metadata;
    }
    //Update Ages Groups
    function UpdateAges(uint256 study_id, string memory metadata)
        public
    {
        // Update ages group in study.
        _studyAges[study_id] = metadata;
    }

    //Create Survey Category
    function CreateSurveyCategory(string memory name, string memory image)
        public
    {
        // Store the metadata of Survey Category in the map.
        _categoryMap[_SurveyCategoryIds] = survey_category_struct({
            name: name,
            image: image
        });
        _SurveyCategoryIds++;
    }

    //Get All Survey by Study ID
    function getAllSurveysIDByStudy(uint256 study_id)
        public
        view
        returns (uint256[] memory)
    {
        uint256 _TemporarySearch = 0;

        for (uint256 i = 0; i < _SurveyIds; i++) {
            if (_surveyMap[i].study_id == study_id) {
                _TemporarySearch++;
            }
        }
        uint256[] memory _SearchedStore = new uint256[](_TemporarySearch);

        uint256 _SearchIds2 = 0;

        for (uint256 i = 0; i < _SurveyIds; i++) {
            if (_surveyMap[i].study_id == study_id) {
                _SearchedStore[_SearchIds2] = i;
                _SearchIds2++;
            }
        }

        return _SearchedStore;
    }

    //Get UserDetails by userid
    function getUserDetails(uint256 user_id)
        public
        view
        returns (
            string memory,
            uint256,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256
        )
    {

        return (
            _userMap[user_id].image,
            _userMap[user_id].credits,
            _userMap[user_id].name,
            _userMap[user_id].email,
           _userMap[user_id].privatekey,
            _userMap[user_id].accesstoken,
            _userMap[user_id].fhirid
        );
    }

    //Update Study
    function UpdateStudy(
        uint256 study_id,
        string memory image,
        string memory title,
        string memory description,
        uint256 budget
    ) public {
        // Update the metadata of Study in the map.
        _studyMap[study_id].image = image;
        _studyMap[study_id].title = title;
        _studyMap[study_id].description = description;
        _studyMap[study_id].budget = budget;
    }

    //Update Survey
    function UpdateSurvey(
        uint256 survey_id,
        string memory name,
        string memory description,
        string memory image,
        uint256 reward
    ) public {
        // Update the metadata of Survey in the map.
        _surveyMap[survey_id].name = name;
        _surveyMap[survey_id].description = description;
        _surveyMap[survey_id].image = image;
        _surveyMap[survey_id].reward = reward;
    }

    //Update Reward
    function UpdateReward(
        uint256 study_id,
        string memory reward_type,
        uint256 reward_price,
        uint256 total_spending_limit
    ) public {
        // Update the metadata of Study in the map.
        _studyMap[study_id].reward_type = reward_type;
        _studyMap[study_id].reward_price = reward_price;
        _studyMap[study_id].total_spending_limit = total_spending_limit;
    }

    //Update Audience
    function UpdateAudience(uint256 study_id, string memory audience_info)
        public
    {
        // Update the metadata of Audience in the map.
        _studyAudienceMap[study_id] = audience_info;
    }

    //Update User
    function UpdateUser(
        uint256 user_id,
        string memory image,
        uint256 credits
    ) public {
        // Update the metadata of User in the map
        _userMap[user_id].image = image;
        _userMap[user_id].credits = credits;
    }

    //Update FHIR
    function UpdateFhir(
        uint256 user_id,
        string memory family_name,
        string memory given_name,
        string memory identifier,
        string memory phone,
        string memory gender,
        string memory birth_date,
        string memory about,
        string memory patient_id
    ) public {
        address walletaddress_address = msg.sender;
        // Update the metadata of FHIR in the map.
        _fhirMap[user_id].user_id = user_id;
        _fhirMap[user_id].family_name = family_name;
        _fhirMap[user_id].given_name = given_name;
        _fhirMap[user_id].identifier = identifier;
        _fhirMap[user_id].phone = phone;
        _fhirMap[user_id].gender = gender;
        _fhirMap[user_id].birth_date = birth_date;
        _fhirMap[user_id].about = about;
        _fhirMap[user_id].patient_id = patient_id;
        _userMap[user_id].walletaddress_address = walletaddress_address;
    }

    function CreateOngoingStudy(
        uint256 study_id,
        uint256 user_id,
        string memory date,
        string memory given_permission
    ) public {
        // Store the metadata of Ongoing Study in the map.
        _ongoingMap[_OngoingIds] = ongoing_struct({
            ongoing_id: _OngoingIds,
            study_id: study_id,
            user_id: user_id,
            date: date,
            given_permission: given_permission
        });
        _studyMap[study_id].contributors += 1;
        _OngoingIds++;
    }

    function GetOngoingStudy(uint256 user_id)
        public
        view
        returns (string memory)
    {
        ///Getting the found Ongoing Study
        for (uint256 i = 0; i < _OngoingIds; i++) {
            if (_ongoingMap[i].user_id == user_id) {
                ///Returning Study id
                return Strings.toString(_ongoingMap[i].study_id);
            }
        }
        ///Returning False if not found
        return "False";
    }

    function CreateQuestionAnswer(
        uint256 study_id,
        uint256 user_id,
        uint256 survey_id,
        string memory section_id,
        string memory question_id,
        string memory answer
    ) public {
        // Store the metadata of Question Answered in the map.
        _questionanswerdMap[_AnsweredIds] = survey_question_answer_struct({
            answer_id: _AnsweredIds,
            study_id: study_id,
            user_id: user_id,
            survey_id: survey_id,
            section_id: section_id,
            question_id: question_id,
            answer: answer
        });
        _AnsweredIds++;
    }

    function CreateCompletedSurveys(
        uint256 survey_id,
        uint256 user_id,
        string memory date,
        uint256 study_id
    ) public {
        // Store the metadata of Completed Survyes in the map.
        _completedsurveyMap[_CompletedSurveyIds] = completed_survey_struct({
            completed_survey_id: _CompletedSurveyIds,
            study_id: study_id,
            user_id: user_id,
            survey_id: survey_id,
            date: date
        });
        _surveyMap[survey_id].submission += 1;
        _surveyMap[survey_id].date = date;
        _CompletedSurveyIds++;
    }

    function CreateCompletedInformedConsent(
        uint256 user_id,
        string memory date,
        uint256 study_id
    ) public {
        // Store the metadata of Completed Informed Consent in the map.
        _completedinformedMap[_CompletedInformedConsentIds] = completed_informed_consent_struct({
            completed_informed_consent_id: _CompletedInformedConsentIds,
            study_id: study_id,
            user_id: user_id,
            date: date
        });
        _CompletedInformedConsentIds++;
    }
    function WithDrawAmount(uint256 userid, uint256 amount) public  {

         (bool sent,) = payable(_userMap[userid].walletaddress_address).call{value: amount}(""); 
       
         require(sent, "Send failed");
        _userMap[userid].credits -= amount;
    }

    
    function getAllCompletedSurveysIDByUser(uint256 user_id)
        public
        view
        returns (uint256[] memory)
    {
        // Getting all completed surveys id by user id
        uint256 _TemporarySearch = 0;

        for (uint256 i = 0; i < _CompletedSurveyIds; i++) {
            if (_completedsurveyMap[i].user_id == user_id) {
                _TemporarySearch++;
            }
        }
        uint256[] memory _SearchedStore = new uint256[](_TemporarySearch);

        uint256 _SearchIds2 = 0;

        for (uint256 i = 0; i < _CompletedSurveyIds; i++) {
            if (_completedsurveyMap[i].user_id == user_id) {
                _SearchedStore[_SearchIds2] = i;
                _SearchIds2++;
            }
        }

        return _SearchedStore;
    }

    function getCompletedInformedConsentId(uint256 user_id, uint256 study_id)
        public
        view
        returns (string memory)
    {
        for (uint256 i = 0; i < _CompletedInformedConsentIds; i++) {
            if (_completedinformedMap[i].user_id == user_id && _completedinformedMap[i].study_id == study_id ) {
                return Strings.toString(i);
            }
        }
        return "False";
    }

    function delete_a_study(uint256 study_id) public {
        // Delete all things related to a study by study id
        delete _studyMap[study_id];
        delete _studyAudienceMap[study_id];
        for (uint256 i = 0; i < _SurveyIds; i++) {
            if (_surveyMap[i].study_id == study_id) delete_a_servey(i);
        }
        for (uint256 i = 0; i < _OngoingIds; i++) {
            if (_ongoingMap[i].study_id == study_id) delete _ongoingMap[i];
        }
    }

    function delete_a_servey(uint256 survey_id) public {
        // Delete all things related to a survey by survey id
        delete _surveyMap[survey_id];
        delete _sectionsMap[survey_id];
        for (uint256 i = 0; i < _AnsweredIds; i++) {
            if (_questionanswerdMap[i].survey_id == survey_id)
                delete _questionanswerdMap[i];
        }
        for (uint256 i = 0; i < _CompletedSurveyIds; i++) {
            if (_completedsurveyMap[i].survey_id == survey_id)
                delete _completedsurveyMap[i];
        }
    }
}