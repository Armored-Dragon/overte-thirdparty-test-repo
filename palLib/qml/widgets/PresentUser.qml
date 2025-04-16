import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
	property string displayName: user.displayName;
	property string username: user.username;
	property string icon: user.icon || "../../img/default_profile_avatar.svg";
	property string uuid: user.uuid;
	property string isAdmin: user.isAdmin;
	property string isFriend: user.isFriend;
	property string isContact: user.isContact;
	property string isPresent: user.isPresent;

	RowLayout {
		height: 100;
		width: parent.width;

		// Icon
		Item {
			height: 80;
			width: 80;

			Rectangle {
				color: "#333";
				radius: 100;
				height: 80;
				width: 80;
				id: avatarImageBackground;
				anchors.centerIn: parent;
			}

			Image {
				id: avatarImageElement;
				source: icon ;
				sourceSize.width: 80;
				sourceSize.height: 80;
				z: 1;
				anchors.centerIn: parent;
				visible: false;
			}

			OpacityMask {
				anchors.fill: avatarImageElement;
				source: avatarImageElement;
				maskSource: avatarImageBackground;
			}
		}

		// Name + Admin username
		Item {
			width: 200;
			height: 80;

			Column {
				height: parent.height;
				width: parent.width;
				Text {
					text: displayName;
					color: "white";
					width: parent.width;
					height: 40;
					font.pointSize: 16;
				}
				Text {
					text: username;
					color: "white";
					width: parent.width;
					height: 40;
					font.pointSize: 12;
				}
			}


		}

		// Friend info
		Item {
			width: 200;
			height: 80;

			Column {
				height: parent.height;
				width: parent.width;

				Text {
					text: "Con? " + isContact;
					color: isContact ?  "#3babe1" : "red";
					width: parent.width;
					height: 20;
					font.pointSize: 12;
				}
				Text {
					text: "Fren? " + isFriend;
					color: isFriend ? "#3babe1" : "red";
					width: parent.width;
					height: 20;
					font.pointSize: 12;
				}
				Text {
					text: "Present? " + isPresent;
					color: isPresent ? "#3babe1" : "red";
					width: parent.width;
					height: 20;
					font.pointSize: 12;
				}
				Text {
					text: "Admin? " + isAdmin;
					color: isAdmin ? "#3babe1" : "red";
					width: parent.width;
					height: 20;
					font.pointSize: 12;
				}
			}
		}

	}
}