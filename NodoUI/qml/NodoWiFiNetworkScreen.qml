import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: wifiNetworkScreen
    width: parent.width
    height: parent.height

    function updateWifiDeviceStatus() {
        var wifiEnabledStatus = networkManager.getWifiDeviceStatus()
        if(wifiEnabledStatus === true)
        {
            pageLoader.source = "NodoNetworkListView.qml"
        }
        else
        {
            pageLoader.source = ""
        }

         wifiEnabledSwitch.checked = wifiEnabledStatus
    }

    Component.onCompleted: {
        updateWifiDeviceStatus()
    }

    Connections {
        target: networkManager
        function onWifiDeviceStatusChanged() {
            updateWifiDeviceStatus()
        }
    }

    Rectangle {
        id: wifiEnabledRect
        anchors.left: wifiNetworkScreen.left
        anchors.top: wifiNetworkScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: wifiEnabledSwitchText
            height: wifiEnabledRect.height
            anchors.left: wifiEnabledRect.left
            anchors.top: wifiEnabledRect.top
            text: wifiEnabledSwitch.checked ? qsTr("Wi-Fi on"):  qsTr("Wifi off")
        }

        NodoSwitch {
            id: wifiEnabledSwitch
            anchors.left: wifiEnabledSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: wifiEnabledRect.height
            width: 2*wifiEnabledRect.height
            display: AbstractButton.IconOnly
            checked: networkManager.getWifiDeviceStatus()
            onCheckedChanged: {
                networkManager.setWifiDeviceStatus(wifiEnabledSwitch.checked)
            }
        }
    }

    Rectangle {
        id: wifiNetworkView
        anchors.top: wifiEnabledRect.bottom
        anchors.left: wifiNetworkScreen.left
        anchors.right: wifiNetworkScreen.right
        anchors.bottom: wifiNetworkScreen.bottom
        anchors.topMargin: 10
        color: "black"
        visible: wifiEnabledSwitch.checked

        Loader {
            id: pageLoader
            anchors.top: wifiNetworkView.top
            anchors.left: wifiNetworkView.left
            anchors.right: wifiNetworkView.right
            anchors.bottom: wifiNetworkView.bottom
        }
    }

}
