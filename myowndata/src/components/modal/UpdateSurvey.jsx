import React, { useState, useEffect } from 'react';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import { CurrencyDollarIcon } from "@heroicons/react/solid";
import { useDBContext } from '../../contextx/DBContext.js'

export default function UpdateSurveyModal({
    show,
    onHide,
    id
}) {

    const { base,updateSurvey } = useDBContext();

    async function UpdateSurveyHandle(e) {
        e.preventDefault();
        const { name, description, image, reward, updateBTN } = e.target;
        var notificationSuccess = e.target.children[0].firstChild;
        var notificationError = e.target.children[0].lastChild;
        updateBTN.children[0].classList.remove("hidden")
        updateBTN.children[1].innerText = ""
        updateBTN.disabled = true;
        try {
            await updateSurvey(id, name.value, description.value, image.value, Number(reward.value));

            notificationSuccess.style.display = "block";
            updateBTN.children[0].classList.add("hidden")
            updateBTN.children[1].innerText = "Update Survey"

            updateBTN.disabled = false;
            window.location.reload();

        } catch (error) {
            notificationError.style.display = "none";
            updateBTN.children[0].classList.add("hidden");
            updateBTN.children[1].innerText = "Update Survey";
            updateBTN.disabled = false;
        }
        updateBTN.children[0].classList.add("hidden")
        updateBTN.children[1].innerText = "Update Survey";
        updateBTN.disabled = false;
    }

    async function LoadData() {
        const surveysTable = base('surveys');
        const surveyRecord = await surveysTable.find(id);
        if (surveyRecord !== null) {
            const survey_element = surveyRecord.fields;
            var new_survey = {
                id: id,
                study_id: (survey_element.study_id),
                user_id: (survey_element.user_id),
                name: survey_element.name,
                description: survey_element.description,
                date: survey_element.date,
                image: survey_element.image,
                reward: Number(survey_element.reward),
                submission: Number(survey_element?.submission)
            };
            if ( document.getElementById("updatename")){
                document.getElementById("updatename").value = new_survey.name
                document.getElementById("updatedescription").value = new_survey.description
                document.getElementById("updateimage").value = new_survey.image
                document.getElementById("reward").value = new_survey.reward

            }
        }

    }


    useEffect(async () => {
        await LoadData();
    }, [])

    return (
        <Modal
            show={show}
            onHide={onHide}
            onShow={() => { LoadData() }}
            size="lg"
            aria-labelledby="contained-modal-title-vcenter"
            centered
        >
            <Modal.Header  >
                <Modal.Title id="contained-modal-title-vcenter">
                    Update Survey
                </Modal.Title>
            </Modal.Header>
            <Modal.Body className="show-grid">
                <Form onSubmit={UpdateSurveyHandle}>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <div id='notificationSuccess' name="notificationSuccess" style={{ display: 'none' }} className="mt-4 text-center bg-gray-200 relative text-gray-500 py-3 px-3 rounded-lg">
                            Success!
                        </div>
                        <div id='notificationError' name="notificationError" style={{ display: 'none' }} className="mt-4 text-center bg-red-200 relative text-red-600 py-3 px-3 rounded-lg">
                            Error! Please try again!
                        </div>
                    </Form.Group>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Name</Form.Label>
                        <input required name="name" placeholder="Name" id="updatename" className="border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />
                    </Form.Group>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Description</Form.Label>
                        <textarea required name="description" placeholder="Description" id="updatedescription" className="border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />
                    </Form.Group>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Image</Form.Label>
                        <input required name="image" placeholder="Image link" id="updateimage" className="border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />
                    </Form.Group>

                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Reward</Form.Label>
                        <input required name="reward" placeholder="Reward" id="reward" type='number' className="w-40 border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />

                    </Form.Group>
                    <div className="d-grid">
                        <Button name="updateBTN" type='submit' style={{ 'display': 'flex' }} className='w-[128px] h-12 flex justify-center items-center' variant='outline-dark' >
                            <i id='LoadingICON' name='LoadingICON' className="select-none block w-12 m-0 fa fa-circle-o-notch fa-spin hidden"></i>
                            <span id='buttonText'>Update Survey</span>
                        </Button>
                    </div>
                </Form>
            </Modal.Body>

        </Modal>

    );
}