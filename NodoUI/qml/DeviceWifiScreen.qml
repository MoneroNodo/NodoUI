import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceWifiScreen
    anchors.fill: parent

    NodoWiFiNetworkScreen {
        width: 1800
        anchors.top: deviceWifiScreen.top
        anchors.bottom: deviceWifiScreen.bottom
        anchors.left: deviceWifiScreen.left
        anchors.bottomMargin: 14
    }
}



