import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Button {
	property var myAction: null;

	text: "Add Contact"
	Layout.fillWidth: true;
	Layout.fillHeight: true;

	MouseArea {
		anchors.fill: parent;
		hoverEnabled: true;

		onEntered: {
			parent.background.color = "gray";
		}

		onExited: {
			parent.background.color = "white";
		}

		onClicked: {
			myAction();
		}
	}
}