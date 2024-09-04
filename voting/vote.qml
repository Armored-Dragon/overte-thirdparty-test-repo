import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import controlsUit 1.0 as HifiControlsUit

Rectangle {
    color: Qt.rgba(0.1,0.1,0.1,1)
    signal sendToScript(var message);
    width: parent.width
    height: 700
    id: root

    property string current_page: "poll_list"

    // Poll List view
    ColumnLayout {
        width: parent.width
        height: parent.height - 40
        // anchors.top: navigation_bar.bottom
        visible: current_page == "poll_list"

        Item {
            height: 40
            width: parent.width - 40

            Rectangle {
                color: "green"
                width: parent.width
                height: 30
            }

            Text {
                text: "Create Poll"
                font.pointSize: 20
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    current_page = "poll_create";
                }
            }
        }

        ListView {
            property int index_selected: -1
            width: parent.width
            height: parent.height - 60
            clip: true
            interactive: true
            spacing: 5
            id: active_polls_list
            model: active_polls

            delegate: Loader {
                property int delegateIndex: index
                property string delegateTitle: model.title
                property string delegateDescription: model.description
                width: active_polls_list.width

                sourceComponent: active_poll_template
            }
        }
        
        ListModel {
            id: active_polls
            ListElement {
                title: "My Awesome poll!"
                description: "Vote on super funny things!"
            }

            ListElement {
                title: "74"
                description: "Raptor moment"
            }
        }
    }

    // Poll host create poll view
    ColumnLayout {
        width: parent.width - 30
        visible: current_page == "poll_create"
        anchors.centerIn: parent
        spacing: 10

        // Title
        Text {
            text: "Title:"
            Layout.fillWidth: true
            font.pointSize: 18
            color: "white"
            // Layout.fillHeight: true
        }
        TextField {
            width: 300
            height: 30
            text: "New Poll"
            cursorVisible: false
            font.pointSize: 16
            Layout.fillWidth: true
            id: poll_to_create_title
        }


        // Description
        Text {
            text: "Description:"
            Layout.fillWidth: true
            font.pointSize: 18
            color: "white"
        }

        TextField {
            width: parent.width
            text: "Vote on things!"
            cursorVisible: false
            font.pointSize: 14
            Layout.fillWidth: true
            Layout.minimumHeight: 150
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
            id: poll_to_create_description

        }

        // Submit button
        RowLayout {

            Rectangle {
                color: "#999999"
                width: 150
                height: 40
                Layout.fillWidth: true

                Text {
                    text: "Abort"
                    color:"black"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        current_page = "poll_list";
                    }
                }
            }

            Rectangle {
                color: "green"
                width: 150
                height: 40

                Text {
                    text: "Create"
                    color:"white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        toScript({type: "create_poll", poll: {title: poll_to_create_title.text, description: poll_to_create_description.text}});
                        current_page = "poll_host_view";
                    }
                }
            }
        }

    }

    // Poll Host display
    ColumnLayout {
        width: parent.width
        height: parent.height - 40
        visible: current_page == "poll_host_view"

        Item {
            height: 100
            width: parent.width

            Rectangle {
                color: "black"
                anchors.fill: parent
            }

            Text {
                width: parent.width
                text: "Respond to:"
                color: "gray"
                font.pointSize: 12
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                y: 20
            }
            TextEdit {
                width: parent.width
                text: "<Question>"
                color: "white"
                font.pointSize: 20
                wrapMode: Text.NoWrap
                anchors.top: parent.children[1].bottom
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Options
        Item {
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                property int index_selected: -1
                width: parent.width - 40
                height: parent.height - 60
                clip: true
                interactive: true
                spacing: 5
                id: poll_options_host
                model: poll_option_model_host
                anchors.centerIn: parent

                delegate: Loader {
                    property int delegateIndex: index
                    property string delegateOption: model.option
                    width: poll_options.width

                    sourceComponent: poll_option_template_host
                }
            }
            
            ListModel {
                id: poll_option_model_host

                ListElement {
                    option: "Yes"
                }

                ListElement {
                    option: "No"
                }
            }
        }

        // Add Option Button
        Item {
            Layout.fillWidth: true
            height: 40
            width: 40

            Rectangle {
                anchors.centerIn: parent
                width: 40
                height: 40
                color: "green"

                Text {
                    anchors.centerIn: parent
                    text:"+"
                    color: "white"
                    font.pointSize:30
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        poll_option_model_host.append({option: "Maybe"})
                    }
                }
            }
        }
    } 

    // Poll question client display
    ColumnLayout { 
        width: parent.width
        height: parent.height - 40
        visible: current_page == "poll_client_view"

        // Header
        Item {
            height: 100
            width: parent.width

            Rectangle {
                color: "black"
                anchors.fill: parent
            }

            Text {
                width: parent.width
                text: "Respond to:"
                color: "gray"
                font.pointSize: 12
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                y: 20
            }
            Text {
                width: parent.width
                text: "XXXX as a board member"
                color: "white"
                font.pointSize: 20
                wrapMode: Text.NoWrap
                anchors.top: parent.children[1].bottom
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Options
        Item {
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                property int index_selected: -1
                width: parent.width
                height: parent.height - 60
                clip: true
                interactive: true
                spacing: 5
                id: poll_options
                model: poll_option_model

                delegate: Loader {
                    property int delegateIndex: index
                    property string delegateOption: model.option
                    width: poll_options.width

                    sourceComponent: poll_option_template
                }
            }
            
            ListModel {
                id: poll_option_model
                ListElement {
                    option: "Yes"
                }

                ListElement {
                    option: "No"
                }

                ListElement {
                    option: "Abstain"
                }
            }
        }
    }


    // Templates
    // Active poll listing
    Component {
        id: active_poll_template

        Rectangle {
            property int index: delegateIndex
            property string title: delegateTitle
            property string description: delegateDescription

            property bool selected: (active_polls_list.index_selected == index)
            height: selected ? 100 : 60 

            color: index % 2 === 0 ? "transparent" : Qt.rgba(0.15,0.15,0.15,1)

            Behavior on height {
                NumberAnimation {
                    duration: 100
                }
            }

            Item {
                width: parent.width - 10
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height
                clip: true

                // App info
                Item {
                    height: 60

                    Text {
                        width: parent.width
                        height: 40
                        text: title
                        color: "white"
                        font.pointSize: 12
                        wrapMode: Text.NoWrap
                        // elide: Text.ElideRight
                    }
                    Text {
                        width: parent.width
                        height: 20
                        text: description
                        color: "gray"
                        font.pointSize: 10
                        anchors.top: parent.children[0].bottom
                    }
                }

                // Action Buttons
                Item {
                    width: parent.width
                    height: 30

                    y: 65
                    visible: selected ? true : false

                    Rectangle {
                        width: 120
                        height: parent.height
                        radius: 5
                        color: "#00930f"
                        visible: true

                        Text {
                            text: "Join"
                            anchors.centerIn: parent
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                // installNewApp(title, url, repo, description, icon);
                            }
                        }
                    }
                }

                MouseArea {
                    width: parent.width
                    height: 60

                    onClicked: {
                        if (active_polls_list.index_selected == index){
                            active_polls_list.index_selected = -1;
                            return;
                        }

                        active_polls_list.index_selected = index
                    }
                }

            }
        }
    }

    // Poll option
    Component {
        id: poll_option_template

        Rectangle {
            property int index: delegateIndex
            property string option: delegateOption

            property bool selected: (active_polls_list.index_selected == index)
            property bool vote_cast: false 
            property bool vote_confirmed: false 
            height: vote_confirmed ? 100 : 60 

            color: index % 2 === 0 ? "transparent" : Qt.rgba(0.15,0.15,0.15,1)

            Behavior on height {
                NumberAnimation {
                    duration: 100
                }
            }

            Item {
                width: parent.width - 10
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height
                clip: true

                // TODO: Change with icon
                // Vote cast notification icon
                Text {
                    text: "A"
                    color: "yellow"
                    x: parent.x + 15
                    font.pointSize: 12
                    // visible: vote_cast
                }
                // TODO: Change with icon
                // Vote confirmed notification icon
                Text {
                    text: "B"
                    color: "green"
                    x: parent.x + 30
                    font.pointSize: 12
                    // visible: vote_confirmed
                }

                Text {
                    text: option
                    anchors.centerIn: parent
                    color: "white"
                }


                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        // Send vote packet to the javascript side.
                        toScript({type: 'cast_vote', option: option})
                    }
                }

            }
        }
    }

    // Poll option Host
    Component {
        id: poll_option_template_host

        Rectangle {
            property string option: delegateOption
            property int index: delegateIndex

            height: 60 
            color: "transparent" 

            Behavior on height {
                NumberAnimation {
                    duration: 100
                }
            }

            RowLayout {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height

                TextField {
                    text: option
                    color: "black"
                    font.pointSize: 14
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 100
                    height: parent.height
                    color: "yellow"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // Remove this element from the list
                            poll_option_model_host.remove(index)
                        }
                    }
                }
            }
        }
    }



    // Messages from script
    function fromScript(message) {
        switch (message.type){
        case "create_poll":
            // Switch view to the create poll view
            break;
        case "new_poll":
            // Add poll info to the list of active polls
            active_polls.append({ title: message.poll.title, description: message.poll.description})
            break;
        }
    }

    // Send message to script
    function toScript(packet){
        sendToScript(packet)
    }
}

