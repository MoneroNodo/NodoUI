import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: deviceMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    TabBar {
        id: deviceMainMenuBar
        anchors.top: deviceMainScreen.top
        anchors.left: deviceMainScreen.left
        height: NodoSystem.topMenuButtonHeight

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: wifiButton
            y: (deviceMainMenuBar.height - wifiButton.height)/2
            text: qsTr("WIFI")
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
            id: displayButton
            anchors.top: wifiButton.top
            anchors.left: systemButton.right
            text: qsTr("DISPLAY")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceDisplayScreen.qml" }
        }
        NodoTabButton {
            id: newsFeedsButton
            anchors.top: wifiButton.top
            anchors.left: displayButton.right
            text: qsTr("NEWS FEEDS")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceNewsFeedsScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: deviceMainMenuBar.bottom
        anchors.left: deviceMainScreen.left
        anchors.right: deviceMainScreen.right
        anchors.bottom: deviceMainScreen.bottom
        anchors.topMargin: 32
        source: "DeviceWifiScreen.qml"
    }
}

