//
//  pal.js
//
//  A small library that provides helper functions specifically for pal.
//
//  Created by Armored Dragon, 2025.
//  Copyright 2025 Overte e.V.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html

// eslint-disable-next-line no-unused-vars
/* global Tablet Script contactsLib Users AvatarManager Uuid  */
"use strict";

let helper = Script.require("./helper.js");
let contactsLib = Script.require("./contacts.js");
let iAmAdmin = Users.getCanKick(); // TODO: Update this when we get a permission update.
Users.usernameFromIDReply.connect(requestAdminLevelInformationAboutUserReply);

let pal = {
	activeUsers: [],		// All active users including ignored users.
	ignoredUsers: [], 		// We need to keep track of this ourselves.
	_adminUserData: {}, 	// Data that is only available if we are admins.
	_contactUserData: {}, 	// Data only available to contacts.

	getActiveUsers: () => {
		return new Promise((resolve) => {
			let palData = AvatarManager.getPalData().data;
			let palDataNormalized = [];

			// Don't include ourself in the list.
			palData = palData.filter((user) => user.sessionUUID !== "");

			palData.map((user) => {

				palDataNormalized.push({
					displayName: user.sessionDisplayName,
					username: null,
					uuid: helper.removeCurlyBracesFromUuid(user.sessionUUID),
					audioLoudness: scaleAudioExponential(user.audioLoudness),
					isFriend: false,
					isContact: false,
					isPresent: true,
					isAdmin: false, // Assume users are not admin
				});
			});


			// Set the active users variable.
			pal.activeUsers = palDataNormalized;


			// If we are admin, add the admin information with the existing information.
			if (iAmAdmin) {
				pal.activeUsers.forEach((user, index) => {
					pal.activeUsers[index] = { ...pal.activeUsers[index], ...pal._adminUserData[user.uuid] };
				});
			}


			// If we have contacts, and those contacts are in the domain with us, update them in our list
			pal.activeUsers.forEach((user, index) => {
				const isUserFriend = pal._contactUserData[user.uuid]?.isFriend || false;
				const isUserContact = pal._contactUserData[user.uuid]?.isContact || false;

				pal.activeUsers[index] = { ...pal.activeUsers[index], isFriend: isUserFriend, isContact: isUserContact };
			});

			resolve(pal.activeUsers);
		});
	},
	getAdminData: () => {
		if (!iAmAdmin) return;
		pal.activeUsers.forEach((user) => Users.requestUsernameFromID(Uuid.fromString(user.uuid)));
	},
	getContactData: async () => {
		let response = await contactsLib.getContactList();
		const contactsList = response.contacts;
		contactsList.forEach((contact) => {
			const isUserFriend = contact.connection === "friend";

			pal._contactUserData[contact.location.node_id] = {
				isFriend: isUserFriend,
				isContact: true,
			};
		});
	},

	ignoreUser: () => {
		// TODO:
		// Check if we already ignored this user
		// Ignore in game
		// Add to ignore list
	},
	unIgnoreUser: () => {
		// TODO:
		// Check if user is in the list
		// Unignore in game
		// Remove from ignore list
	},
};

function scaleAudioExponential(audioValue) {
	let normalizedValue = audioValue / 32768;
	let scaledValue = Math.pow(normalizedValue, 0.3);
	return scaledValue;
}

function requestAdminLevelInformationAboutUserReply(sessionUUID, userName, machineFingerprint, isAdmin) {
	print(`Got ${sessionUUID}'s information`);
	sessionUUID = helper.removeCurlyBracesFromUuid(sessionUUID);

	pal._adminUserData[sessionUUID] = {};

	pal._adminUserData[sessionUUID] = {
		username: userName,
		machineFingerprint: machineFingerprint,
		isAdmin: isAdmin
	};
}

module.exports = pal;