import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import controlsUit 1.0 as HifiControlsUit

Rectangle {
    color: Qt.rgba(0.1,0.1,0.1,1)
    signal sendToScript(var message);
    width: 200
    height: 700
    id: root

    property string current_page: "poll_list"

    // Poll List view
    Item {
        width: parent.width
        height: parent.height - 40
        // anchors.top: navigation_bar.bottom
        visible: current_page == "poll_list"

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

    // Question Prompt View

    // Templates
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

                    // Rectangle {
                    //     width: 120
                    //     height: parent.height
                    //     radius: 5
                    //     color: "#505186"
                    //     x: parent.children[0].width + 5

                    //     Text {
                    //         text: "Details"
                    //         anchors.centerIn: parent
                    //         color:"white"
                    //     }

                    //     MouseArea {
                    //         anchors.fill: parent

                    //         onClicked: {
                    //             // openAppDetails(title, url, repo, description, icon);
                    //         }
                    //     }
                    // }
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



    // Messages from script
    function fromScript(message) {
        switch (message.type){
            // TODO:
            case "active_polls":
                break;
        }
    }

    // Send message to script
    function toScript(packet){
        sendToScript(packet)
    }
}
