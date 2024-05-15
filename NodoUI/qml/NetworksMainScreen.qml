import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: networksMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    property alias clearnetButton: clearnetButton
    property alias torButton: torButton
    property alias i2pButton: i2pButton

    TabBar {
        id: networksMenuBar
        anchors.top: networksMainScreen.top
        anchors.left: networksMainScreen.left
        height: NodoSystem.topMenuButtonHeight

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
            y: (networksMenuBar.height - torButton.height)/2
            anchors.left: clearnetButton.right
            text: qsTr("TOR")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NetworksTorScreen.qml" }
        }
        NodoTabButton {
            id: i2pButton
            y: (networksMenuBar.height - i2pButton.height)/2
            anchors.left: torButton.right
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
        anchors.topMargin: 20
        source: "NetworksClearnetScreen.qml"
    }
}
