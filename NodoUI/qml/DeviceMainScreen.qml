import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    TabBar {
        id: deviceMainMenuBar
        anchors.top: deviceMainScreen.top
        anchors.left: deviceMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        contentWidth: 1460

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: wifiButton
            y: (deviceMainMenuBar.height - wifiButton.height)/2
            text: qsTr("WI-FI")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceWifiScreen.qml" }
        }
        NodoTabButton {
            id: ethernetButton
            anchors.top: wifiButton.top
            anchors.left: wifiButton.right
            text: qsTr("ETHERNET")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceEthernetScreen.qml" }
        }
        NodoTabButton {
            id: systemButton
            anchors.top: wifiButton.top
            anchors.left: ethernetButton.right
            text: qsTr("SYSTEM")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceSystemScreen.qml" }
        }

        NodoTabButton {
            id: updatesButton
            anchors.top: wifiButton.top
            anchors.left: systemButton.right
            text: qsTr("UPDATES")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceUpdatesScreen.qml" }
        }


        NodoTabButton {
            id: displayButton
            anchors.top: wifiButton.top
            anchors.left: updatesButton.right
            text: qsTr("DISPLAY")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceDisplayScreen.qml" }
        }
        NodoTabButton {
            id: pinButton
            anchors.top: wifiButton.top
            anchors.left: displayButton.right
            text: qsTr("PIN")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DevicePinScreen.qml" }
        }
        NodoTabButton {
            id: newsFeedsButton
            anchors.top: wifiButton.top
            anchors.left: pinButton.right
            text: qsTr("NEWS FEEDS")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceNewsFeedsScreen.qml" }
        }
        NodoTabButton {
            id: sshButton
            anchors.top: wifiButton.top
            anchors.left: newsFeedsButton.right
            text: qsTr("SSH")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceSSHScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: deviceMainMenuBar.bottom
        anchors.left: deviceMainScreen.left
        anchors.right: deviceMainScreen.right
        anchors.bottom: deviceMainScreen.bottom
        anchors.topMargin: 40
        source: "DeviceWifiScreen.qml"
    }
}

