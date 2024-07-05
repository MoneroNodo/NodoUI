import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: networksMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    TabBar {
        id: networksMenuBar
        anchors.top: networksMainScreen.top
        anchors.left: networksMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        contentWidth: 1400

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: clearnetButton
            y: (networksMenuBar.height - clearnetButton.height)/2
            text: qsTr("CLEARNET")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NetworksClearnetScreen.qml" }
        }
        NodoTabButton {
            id: torButton
            anchors.left: clearnetButton.right
            anchors.top: clearnetButton.top
            text: qsTr("TOR")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NetworksTorScreen.qml" }
        }
        NodoTabButton {
            id: i2pButton
            anchors.left: torButton.right
            anchors.top: clearnetButton.top
            text: qsTr("I2P")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NetworksI2PScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: networksMenuBar.bottom
        anchors.left: networksMainScreen.left
        anchors.right: networksMainScreen.right
        anchors.bottom: networksMainScreen.bottom
        anchors.topMargin: 40
        source: "NetworksClearnetScreen.qml"
    }
}
