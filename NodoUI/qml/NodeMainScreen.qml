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

    TabBar {
        id: nodoMenuBar
        anchors.top: nodeMainScreen.top
        anchors.left: nodeMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        contentWidth: 1400

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: privateNodeButton
            y: (nodoMenuBar.height - privateNodeButton.height)/2
            text: qsTr("PRIVATE NODE")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodePrivateNodeScreen.qml" }
        }
        NodoTabButton {
            id: bandwidthButton
            y: (nodoMenuBar.height - bandwidthButton.height)/2
            anchors.left: privateNodeButton.right
            text: qsTr("BANDWIDTH")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "NodeBandwidthScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: nodoMenuBar.bottom
        anchors.left: nodeMainScreen.left
        anchors.right: nodeMainScreen.right
        anchors.bottom: nodeMainScreen.bottom
        anchors.topMargin: 40
        source: "NodePrivateNodeScreen.qml"
    }
}
