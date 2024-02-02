import React, { useState, useEffect } from 'react';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import { CurrencyDollarIcon } from "@heroicons/react/solid";
import { useDBContext } from '../../contextx/DBContext.js'
import Cookies from 'js-cookie'

export default function UpdateStudyModal({
    show,
    onHide,
    id
}) {
    const {UpdateStudy,base} = useDBContext();

    async function UpdateStudyHandle(e) {
        e.preventDefault();
        const { title, description, image, updateBTN, budget } = e.target;
        var notificationSuccess = e.target.children[0].firstChild;
        var notificationError = e.target.children[0].lastChild;
        updateBTN.children[0].classList.remove("hidden")
        updateBTN.children[1].innerText = ""
        updateBTN.disabled = true;

        try {
            await UpdateStudy(Number(id), image.value, title.value, description.value, 0);
            notificationSuccess.style.display = "block";
            updateBTN.children[0].classList.add("hidden")
            updateBTN.children[1].innerText = "Update Study"

            updateBTN.disabled = false;
            window.location.reload();


        } catch (error) {
            notificationError.style.display = "none";
            updateBTN.children[0].classList.add("hidden");
            updateBTN.children[1].innerText = "Update Study";
            updateBTN.disabled = false;
        }
        updateBTN.children[0].classList.add("hidden")
        updateBTN.children[1].innerText = "Update Study";
        updateBTN.disabled = false;
    }

    async function LoadData() {
        const studyTable = base('studies');
        const studyRecord = await studyTable.find(id);
        if (studyRecord !== null) {
			const study_element = studyRecord.fields;
            var newStudy = {
				id: studyRecord.id,
				title: study_element.title,
				image: study_element.image,
				description: study_element.description,
				contributors: Number(study_element.contributors),
				audience: Number(study_element.audience),
				budget: Number(study_element.budget),
				reward_type: study_element.reward_type,
				reward_price: Number(study_element.reward_price),
				total_spending_limit: Number(study_element.total_spending_limit)
			};

            document.getElementById("updatetitle").value = newStudy.title
            document.getElementById("updatedescription").value = newStudy.description
            document.getElementById("updateimage").value = newStudy.image
            document.getElementById("updatebudget").value = newStudy.budget
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
                    Update Study
                </Modal.Title>
            </Modal.Header>
            <Modal.Body className="show-grid">
                <Form onSubmit={UpdateStudyHandle}>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <div id='notificationSuccess' name="notificationSuccess" style={{ display: 'none' }} className="mt-4 text-center bg-gray-200 relative text-gray-500 py-3 px-3 rounded-lg">
                            Success!
                        </div>
                        <div id='notificationError' name="notificationError" style={{ display: 'none' }} className="mt-4 text-center bg-red-200 relative text-red-600 py-3 px-3 rounded-lg">
                            Error! Please try again!
                        </div>
                    </Form.Group>

                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Title</Form.Label>
                        <input required name="title" placeholder="Title" id="updatetitle" className="border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />
                    </Form.Group>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Description</Form.Label>
                        <textarea rows={10} required name="description" placeholder="Description" id="updatedescription" className="border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />
                    </Form.Group>
                    <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Image</Form.Label>
                        <input required name="image" placeholder="Image link" id="updateimage" className="border rounded pt-2 pb-2 border-gray-400 pl-4 pr-4" />
                    </Form.Group>
                    {/* <Form.Group className="mb-3 grid" controlId="formGroupName">
                        <Form.Label>Budget</Form.Label>
                        <div className="input-group">
                            <span className="input-group-addon text-sm pt-2 pb-2 pl-3 pr-3 font-normal -mr-1 leading-none text-gray-700 text-center bg-gray-200 border-gray-400 border rounded">
                                <CurrencyDollarIcon className="w-5 h-5 text-gray-500" />
                            </span>
                            <input required name="budget" placeholder="Budget" id="updatebudget" type='number' className="w-24 text-black pr-2 border-gray-400 border pl-2" />
                        </div>
                    </Form.Group> */}
                    <div className="d-grid">
                        <Button name="updateBTN" type='submit' style={{ 'display': 'flex' }} className='w-[128px] h-12 flex justify-center items-center' variant='outline-dark' >
                            <i id='LoadingICON' name='LoadingICON' className="select-none block w-12 m-0 fa fa-circle-o-notch fa-spin hidden"></i>
                            <span id='buttonText'>Update Study</span>
                        </Button>
                    </div>
                </Form>
            </Modal.Body>

        </Modal>

    );
}