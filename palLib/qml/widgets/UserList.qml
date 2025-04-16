import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Item {
	ColumnLayout {
		width: parent.width;
		
		Repeater {
			model: users.length;

			delegate: PresentUser {
				property var user: users[index];
			}
		}
	}
}