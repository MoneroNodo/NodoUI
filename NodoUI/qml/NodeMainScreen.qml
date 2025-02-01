import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodeMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin
    anchors.topMargin: NodoSystem.subMenuTopMargin

    TabBar {
        id: nodeMenuBar
        anchors.top: nodeMainScreen.top
        anchors.left: nodeMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        //contentWidth: 1460
        width: banlistButton.x + banlistButton.width

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: clearnetButton
            y: (nodeMenuBar.height - clearnetButton.height)/2
            text: qsTr("CLEARNET")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodeClearnetScreen.qml" }
        }

        NodoTabButton {
            id: torButton
            anchors.top: clearnetButton.top
            anchors.left: clearnetButton.right
            text: qsTr("TOR")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodeTorScreen.qml" }
        }

        NodoTabButton {
            id: i2pButton
            anchors.top: clearnetButton.top
            anchors.left: torButton.right
            width: torButton.width
            text: qsTr("I2P")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodeI2PScreen.qml" }
        }

        NodoTabButton {
            id: bandwidthButton
            anchors.top: clearnetButton.top
            anchors.left: i2pButton.right
            text: qsTr("BANDWIDTH")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodeBandwidthScreen.qml" }
        }

        NodoTabButton {
            id: privateNodeButton
            anchors.top: clearnetButton.top
            anchors.left: bandwidthButton.right
            text: qsTr("PRIVATE") //qsTr("PRIVATE NODE")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodePrivateNodeScreen.qml" }
        }

        NodoTabButton {
            id: banlistButton
            anchors.top: clearnetButton.top
            anchors.left: privateNodeButton.right
            text: qsTr("BANLIST")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodeBanlistScreen.qml" }
        }

    }

    Loader {
        id: pageLoader
        anchors.top: nodeMenuBar.bottom
        anchors.left: nodeMainScreen.left
        anchors.right: nodeMainScreen.right
        anchors.bottom: nodeMainScreen.bottom
        anchors.topMargin: 40
        source: "NodeClearnetScreen.qml"
    }
}
