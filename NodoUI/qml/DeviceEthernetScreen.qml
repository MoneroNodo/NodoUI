import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceEthernetScreen
    anchors.fill: parent

    NodoEthernetNetworkScreen {
        width: 1880
        anchors.top: deviceEthernetScreen.top
        anchors.bottom: deviceEthernetScreen.bottom
        anchors.left: deviceEthernetScreen.left
        anchors.bottomMargin: 14
    }
}


