import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceLogsScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin
    anchors.topMargin: NodoSystem.subMenuTopMargin

    TabBar {
        id: deviceMainMenuBar
        anchors.top: deviceLogsScreen.top
        anchors.left: deviceLogsScreen.left
        height: NodoSystem.subMenuButtonHeight
        //contentWidth: 1460
        width: 1360 //displayButton.x + displayButton.width

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: moneroLogButton
            y: deviceMainMenuBar.height - moneroLogButton.height - (moneroLogButton.height/2)
            text: qsTr("MONERO")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: {
                logViewModel.unit = "monerod.service"
            }
        }

        NodoTabButton {
            id: nodoUILogButton
            anchors.top: moneroLogButton.top
            anchors.left: moneroLogButton.right
            anchors.leftMargin: NodoSystem.nodoTopMargin
            text: qsTr("NODOUI")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: {
                logViewModel.unit = "nodoUI.service"
            }
        }

        NodoTabButton {
            id: lwsLogsButton
            anchors.top: moneroLogButton.top
            anchors.left: nodoUILogButton.right
            anchors.leftMargin: NodoSystem.nodoTopMargin
            text: qsTr("LWS")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: {
                logViewModel.unit = "monero-lws.service"
            }
        }

        NodoTabButton {
            id: updatesButton
            anchors.top: moneroLogButton.top
            anchors.left: lwsLogsButton.right
            text: qsTr("KERNEL")
            anchors.leftMargin: NodoSystem.nodoTopMargin
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: {
                logViewModel.unit = "kernel"
            }
        }
    }

    ListView {
    id: logView
        model: logViewModel
        anchors.fill: parent
        clip: true

        property bool end: false;
        onCountChanged: {
            if (end)
                Qt.callLater(positionViewAtEnd)
        }
       Connections {
        target: logViewModel
        function onLogLoaded() { logView.positionViewAtEnd() }
        }
        onContentYChanged: {
            end = contentY + height > contentHeight - 2
        }
        delegate: Rectangle {
            width: logView.width
            height: msgText.height + unitRow.height + 16
            color: index % 2 === 0 ? "#101010" : "#000000"

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Row {
                    id: unitRow
                    spacing: 10

                    Text {
                        text: timestamp.toLocaleTimeString(Qt.locale())
                        color: "#f5f5f5"
                        font.family: "monospace"
                    }

                Text {
                    id: msgText
                    width: parent.width
                    text: message
                    color: "white"
                    font.family: "monospace"
                    wrapMode: Text.Wrap
                    lineHeight: 1.1
                }
                }

            }
        }
    }
}


