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

/* global Script Tablet Messages MyAvatar Uuid*/

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
	var poll = {id: '', title: '', description: '', host: '', question: '', options: []};
	var receivedPolls = []; // List of poll ids received. 
	const url = Script.resolvePath("./vote.qml");
	Messages.messageReceived.connect(receivedMessage);
	Messages.subscribe('ga-polls');

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

	function onTabletScreenChanged(type, newUrl) {
		if (url == newUrl) {
			active = true;

			// TODO: Is this needed?
			// If we are connected to a poll already, repopulate the screen
			// if (poll.id != '') return populateScreen();

			// Request a list of active polls if we are not already in one
			if (poll.id == '') return getActivePolls();
		}
		else active = false;

		appButton.editProperties({
			isActive: active,
		});
	}

	// Functions
	function getActivePolls() {
		// Sends a message to all hosts to send a list of their polls
		Messages.sendMessage('ga-polls', JSON.stringify({type: "populate"}));
	}

	// Create a new poll for others to join
	function createPoll(pollInformation) { 
		console.log("Creating a new poll");
		// Check if we are already hosting a poll
		if (poll.id != '') return;

		// Set our active poll data
		poll.id = Uuid.generate().toString();
		poll.host = MyAvatar.sessionUUID;
		poll.title = pollInformation.title;
		poll.description = pollInformation.description;
		console.log(`Active poll set as:\nid:${poll.id}\ntitle:${poll.title}\ndescription:${poll.description}`);

		// Send message to all clients
		Messages.sendMessage("ga-polls", JSON.stringify({type: "active_poll", poll: poll}));
		console.log("Broadcasted poll to server");

		// Update the UI screen
		_emitEvent({type: "create_poll"});
	}

	// Join an existing poll hosted by another user
	function joinPoll(pollToJoin){
		// Leave poll if already connected to one
		leavePoll(); 

		// Save the poll information
		poll = pollToJoin;

		// Subscribe to message mixer for poll information
		Messages.subscribe(pollToJoin.id);

		// Send join notice to server. This will cause the host to (re)emit the current poll to the server 
		Messages.sendMessage(pollToJoin.id, JSON.stringify({type: "join"}));
	}

	// Leave a poll hosted by another user
	function leavePoll() { 
		// Unsubscribe from message mixer for poll information
		Messages.unsubscribe(poll.id);

		// Clear poll
		poll = {id: '', host: ''}; 
	}

	// Cast a vote on a poll
	function castVote(event) {
		console.log(`Casting vote to ${poll.id}: ${event}`);

		// Check if poll is valid
		if (poll == undefined || poll.id == '') return;

		// Send vote to server
		Messages.sendMessage(poll.id, JSON.stringify({type: "vote", option: event.option}));
	 }


	// Communication
	function fromQML(event) {
		console.log(`New QML event:\n${JSON.stringify(event)}`);
		// event = JSON.parse(event);
		console.log(event.type);
		switch (event.type) {
		case "create_poll":
			createPoll(event.poll);
			break;
		case "join_poll":
			joinPoll(event);
			break;
		case "cast_vote":
			castVote(event);
			break;
		}
	}
	/**
	 * Emit a packet to the HTML front end. Easy communication!
	 * @param {Object} packet - The Object packet to emit to the HTML
	 * @param {("create_poll"|"initial_settings")} packet.type - The type of packet it is
	 */
	function _emitEvent(packet = { type: "" }) {
		tablet.sendToQml(packet);
	}

	function receivedMessage(channel, message){
		// console.log(`Received message from server:\n${JSON.stringify(message)}\n`);

		message = JSON.parse(message);

		switch (channel) {
		case "ga-polls":
			// Received a request to see our poll
			if (message.type == "populate") {
				// Send our poll information to the server if we are hosting it
				if (poll.host == MyAvatar.sessionUUID) {
					Messages.sendMessage("ga-polls", JSON.stringify({type: "active_poll", poll: poll}));
				}
			}

			// Received an active poll 
			if (message.type == "active_poll") {
				// If we are not connected to a poll, list polls in the UI
				if (poll.id == '') {
					if (receivedPolls.indexOf(message.poll.id) == -1) {
						console.log(JSON.stringify(message));
						receivedPolls.push(message.poll.id);
						_emitEvent({type: "new_poll", poll: message.poll});
					}
				}
			}
			break;
		}
	}
})();