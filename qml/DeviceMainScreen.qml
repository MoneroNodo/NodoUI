import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
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
            y: (deviceMainMenuBar.height - ethernetButton.height)/2
            anchors.left: wifiButton.right
            text: qsTr("ETHERNET")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceEthernetScreen.qml" }
        }
        NodoTabButton {
            id: systemButton
            y: (deviceMainMenuBar.height - systemButton.height)/2
            anchors.left: ethernetButton.right
            text: qsTr("SYSTEM")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceSystemScreen.qml" }
        }
        NodoTabButton {
            id: displayButton
            y: (deviceMainMenuBar.height - displayButton.height)/2
            anchors.left: systemButton.right
            text: qsTr("DISPLAY")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "DeviceDisplayScreen.qml" }
        }
        NodoTabButton {
            id: newsFeedsButton
            y: (deviceMainMenuBar.height - newsFeedsButton.height)/2
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
        anchors.topMargin: 20
        source: "DeviceWifiScreen.qml"
    }
}

