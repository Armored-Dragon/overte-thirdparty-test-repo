//
//  vote.js
//
//  App to simplify the tallying of votes for Community Meetings
//
//  Created by Armored Dragon, 2024.
//  Copyright 2024 Overte e.V.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html

/* global Script Tablet */

// TODO: Documentation
// TODO: Start poll
// TODO: View active polls
// TODO: Join poll
// TODO: Create poll question and answers
// TODO: Create pre-fill answers (checkbox?)
// TODO: Save questions and answers locally
// TODO: View previous answers

(() => {
	"use strict";
	var tablet;
	var appButton;
	var active = false;
	const url = Script.resolvePath("./vote.qml")

	console.log("Ah");

	tablet = Tablet.getTablet("com.highfidelity.interface.tablet.system");
	appButton = tablet.addButton({
		icon: Script.resolvePath("./img/icon_white.png"),
		activeIcon: Script.resolvePath("./img/icon_black.png"),
		text: "VOTE",
		isActive: active,
	});

	// When script ends, remove itself from tablet
	Script.scriptEnding.connect(function () {
		console.log("Shutting Down");
		tablet.removeButton(appButton);
	});

	// Overlay button toggle
	appButton.clicked.connect(toolbarButtonClicked);
	tablet.fromQml.connect(fromQML);
	tablet.screenChanged.connect(onTabletScreenChanged);

	function toolbarButtonClicked() {
		if (active) tablet.gotoHomeScreen();
		else tablet.loadQMLSource(url);
		
		active = !active;
		appButton.editProperties({
			isActive: active,
		});
	}

	function onTabletScreenChanged(type, new_url){
		if (url == new_url) active = true;
		else active = false;
		
		appButton.editProperties({
			isActive: active,
		});
	}

	// Functions
	function getActivePolls(){
		// Send hello world
		// Add responses to list
	}
	function newPoll(){}


	// Communication
	function fromQML(event) {
		console.log(`New QML event:\n${JSON.stringify(event)}`);

		switch (event.type) {
		case "initialized":
			getActivePolls();
			break;
		case "create_poll":
			newPoll();
			break;
		}
	}
	/**
	 * Emit a packet to the HTML front end. Easy communication!
	 * @param {Object} packet - The Object packet to emit to the HTML
	 * @param {("show_message"|"clear_messages"|"notification"|"initial_settings")} packet.type - The type of packet it is
	 */
	// function _emitEvent(packet = { type: "" }) {
	// 	tablet.sendToQml(packet);
	// }
})();