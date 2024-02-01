import { useNavigate, useLocation } from "react-router-dom";
import { useState, useEffect } from "react";
import useContract from "../../contract/useContract.ts";
function ResetAll() {
	let navigate = useNavigate();
	const { contract, signerAddress, fD } = useContract();

	async function ResetClick(event) {


		event.target.disabled = true;
		await contract.reset_all().send({
			feeLimit: 1_000_000_000,
			shouldPollResponse: false
		});

		window.location.href = "/";

		event.target.disabled = false;
	}

	async function ResetApp(event) {
		event.target.disabled = true;
		var UserIdTXT = document.getElementById("userid")
		await contract.reset_app(Number(UserIdTXT.value)).send({
			feeLimit: 1_000_000_000,
			shouldPollResponse: false
		});

		window.location.href = "/";

		event.target.disabled = false;
	}

	return (
		<div className="min-h-screen grid-cols-2 flex">
			<div className="bg-white flex-1 flex flex-col justify-center items-center">
				<div className="pl-20 pr-20 relative container-panel">
					<h1 className="text-4xl font-semibold mt-10 text-center">Reset All Data.</h1>

					<div className="mt-10">
						<button onClick={ResetClick} className="bg-gray-200 text-gray-500 rounded-md shadow-md h-10 w-full mt-3 hover:bg-black transition-colors">
							Reset All
						</button>
					</div>
					<div className="mt-10">
						<label className="flex flex-col font-semibold">
							App User Id
							<input type="number" required id="userid" name="userid" className="mt-2 h-10 border border-gray-200 rounded-md outline-none px-2 focus:border-gray-400" />
						</label>

						<button onClick={ResetApp} className="bg-gray-200 text-gray-500 rounded-md shadow-md h-10 w-full mt-3 hover:bg-black transition-colors">
							Reset App
						</button>
					</div>
				</div>
			</div>
		</div>
	);
}

export default ResetAll;

