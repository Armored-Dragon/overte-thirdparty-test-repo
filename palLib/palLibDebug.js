"use strict";
// eslint-disable-next-line no-unused-vars
/* global Tablet Script contactsLib  */

let tablet = Tablet.getTablet("com.highfidelity.interface.tablet.system");
let active = false;

let appButton = tablet.addButton({
	icon: Script.resolvePath("./img/icon_white.svg"),
	activeIcon: Script.resolvePath("./img/icon_black.svg"),
	text: "PalDebug",
	isActive: active,
});

// let contactsLib = Script.require("./libs/contacts.js");
let palLib = Script.require("./libs/pal.js");

appButton.clicked.connect(toolbarButtonClicked);

tablet.fromQml.connect(fromQML);
tablet.screenChanged.connect(onScreenChanged);
Script.scriptEnding.connect(shutdownScript);
Script.setInterval(updatePalData, 100);
// Script.setInterval(palLib.getAdminData, 1000 * 60 * 5); // TODO: Five minutes
// Script.setInterval(palLib.getContactData, 1000 * 60 * 5); // TODO: Five minutes
palLib.getActiveUsers();

function toolbarButtonClicked() {
	if (active) {
		tablet.gotoHomeScreen();
		active = !active;
		appButton.editProperties({ isActive: active });
	} else {
		tablet.loadQMLSource(Script.resolvePath("./qml/palLibDebug.qml"));
		active = !active;
		appButton.editProperties({ isActive: active });
		palLib.getContactData();
		palLib.getAdminData();
	}
}

function onScreenChanged(type, url) {
	if (url != Script.resolvePath("./qml/palLibDebug.qml")) {
		active = false;
		appButton.editProperties({
			isActive: active,
		});
	}
}

function fromQML(event) {
	console.log(`Got event from QML:\n ${JSON.stringify(event, null, 4)}`);
}

function toQML(packet = { type: "" }) {
	tablet.sendToQml(packet);
}

function shutdownScript() {
	// Script has been removed.
	console.log("Shutting Down");
	tablet.removeButton(appButton);
}

// ------------------------------------------------------------------- //

function updatePalData() {
	// Get all active users in the session
	palLib.getActiveUsers();

	// Send the list to the QML
	toQML({ type: "activeUsers", users: palLib.activeUsers });

	// Log
	// helper.logJSON(palLib.activeUsers);
	// helper.logJSON(palLib._adminUserData);
}