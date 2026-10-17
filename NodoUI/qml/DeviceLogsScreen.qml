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
        anchors.top: deviceMainScreen.top
        anchors.left: deviceMainScreen.left
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
            //onClicked: 
        }

        NodoTabButton {
            id: nodoUILogButton
            anchors.top: moneroLogButton.top
            anchors.left: moneroLogButton.right
            anchors.leftMargin: NodoSystem.nodoTopMargin
            text: qsTr("NODOUI")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            //onClicked: 
        }

        NodoTabButton {
            id: sshLogsButton
            anchors.top: moneroLogButton.top
            anchors.left: nodoUILogButton.right
            anchors.leftMargin: NodoSystem.nodoTopMargin
            text: qsTr("SSH")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            //onClicked: 
        }

        NodoTabButton {
            id: updatesButton
            anchors.top: moneroLogButton.top
            anchors.left: sshLogsButton.right
            text: qsTr("KERNEL")
            anchors.leftMargin: NodoSystem.nodoTopMargin
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            //onClicked: 
        }

    Loader {
        id: pageLoader
        anchors.top: deviceMainMenuBar.bottom
        anchors.left: deviceMainScreen.left
        anchors.right: deviceMainScreen.right
        anchors.bottom: deviceMainScreen.bottom
        anchors.topMargin: 40
        //source: "DeviceWifiScreen.qml"
    }
}
}