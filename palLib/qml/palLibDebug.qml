import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import "./widgets"

Rectangle {
    signal sendToScript(var message);
	color: Qt.rgba(0.1,0.1,0.1,1);
	width: parent.width;
	height: parent.height;
	anchors.centerIn: parent;
	anchors.horizontalCenter: parent.horizontalCenter;

	property var users: [];
	property var canKick: false;	// The only way to tell if a user is an admin of a domain is if they have the kick permissions

	// Home page
	Column {
		width: parent.width - 20;
		height: parent.height;
		spacing: 15;
		anchors.horizontalCenter: parent.horizontalCenter;

		UserList {}
	}

	function toUserPage(sessionUUID){

	}

	function fromScript(message) {
		// Active user data
		if (message.type === "activeUsers") {
			users = message.users;
			// print(JSON.stringify(users, null, 4))
			return;
		}
	}

	// Send message to script
	function toScript(packet){
		sendToScript(packet)
	}
}

