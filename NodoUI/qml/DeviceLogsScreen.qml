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
        width: 1360

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
            width: 150
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

        property bool end: false

        model: logViewModel
        anchors.fill: parent
        anchors.topMargin: 60
        clip: true
        onCountChanged: {
            if (end)
                Qt.callLater(positionViewAtEnd);

        }
        onContentYChanged: {
            end = contentY + height > contentHeight - 2;
        }

        Connections {
            function onLogLoaded() {
                logView.positionViewAtEnd();
            }

            target: logViewModel
        }

        delegate: Rectangle {
            width: ListView.view.width
            height: msgText.height + unitRow.height + 16
            color: logId % 2 === 0 ? "#101010" : "#000000"

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Row {
                    id: unitRow

                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 10

                    Text {
                        text: timestamp.toLocaleTimeString(Qt.locale())
                        color: NodoSystem.defaultColorNightModeOff
                        font.family: "monospace"
                    }

                    Text {
                        id: msgText
                        width: parent.width - x
                        text: message
                        color: NodoSystem.defaultColorNightModeOff
                        font.family: "monospace"
                        wrapMode: Text.Wrap
                        lineHeight: 1.1
                    }

                }

            }

        }

    }

}
