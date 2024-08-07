import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainCanvas
    width: parent.width
    height: parent.height

    property int labelSize: 200

    property bool isScanComplete: false
    property bool isConnectedWifiAvailable: false
    color: "black"

    Component.onCompleted: {
        getCurrentNetworkStatus()
        getWifiList()
    }

    function getWifiList() {
        isScanComplete = false;

        wifiListModel.clear()
        for (var index = 0;index < networkManager.getSSIDListSize(); index++) {
            var ssidIndex = { "ssidIndex": index}
            wifiListModel.append(ssidIndex)
        }

        isScanComplete = true;
    }

    function getCurrentNetworkStatus() {
        isConnectedWifiAvailable = networkManager.isConnectedSSIDAvailable()
    }

    Connections {
        target: networkManager

        function onWifiScanCopleted() {
            getWifiList()
        }

        function onConnectedSSIDParamsUpdated() {
            getCurrentNetworkStatus()
        }

        function onAPScanStatusReceived() {
            isScanComplete = !networkManager.getAPScanStatus()
        }
    }

    ScrollView {
        id: scrollMain
        anchors.fill: parent

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        clip: true
        Item {
            id: wifiNetworkList
            width: parent.width
            height: currentWifiDelegate.height + ssidList.contentHeight + 8
            implicitHeight: height

            NodoWiFiNetworkConnectedProfile {
                id: currentWifiDelegate
                anchors.left: wifiNetworkList.left
                anchors.top: wifiNetworkList.top
                anchors.right: wifiNetworkList.right
                visible: isConnectedWifiAvailable
            }

            ListView {
                id: ssidList
                anchors.left: wifiNetworkList.left
                anchors.top: isConnectedWifiAvailable ? currentWifiDelegate.bottom : wifiNetworkList.top
                anchors.right: wifiNetworkList.right
                anchors.bottom: wifiNetworkList.bottom
                anchors.topMargin: isConnectedWifiAvailable ? NodoSystem.nodoTopMargin : 0
                interactive: false

                model: wifiListModel
                visible: true

                delegate: NodoWiFiNetworkListDelegate {
                    id: networkDelegate
                    ssidIndex: model.ssidIndex
                    width: ssidList.width
                }

                spacing: NodoSystem.nodoTopMargin
            }
        }
    }

    ListModel {
        id: wifiListModel
    }
}

