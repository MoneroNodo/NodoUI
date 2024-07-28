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
        anchors.bottomMargin: 95

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        clip: true
        Item {
            id: wifiNetworkList
            width: parent.width
            height: currentNetworkCanvas.height + availableNetworksCanvas.height + 8
            implicitHeight: height

            NodoCanvas {
                id: currentNetworkCanvas
                anchors.left: wifiNetworkList.left
                anchors.top: wifiNetworkList.top
                anchors.right: wifiNetworkList.right
                color: "black"
                visible: isConnectedWifiAvailable
                height: currentWifiDelegate.y + currentWifiDelegate.height

                NodoWiFiNetworkConnectedProfile {
                    id: currentWifiDelegate
                    anchors.left: currentNetworkCanvas.left
                    anchors.top: currentNetworkCanvas.top
                    anchors.right: currentNetworkCanvas.right
                }
            }

            NodoCanvas {
                id: availableNetworksCanvas
                anchors.left: wifiNetworkList.left
                anchors.top: isConnectedWifiAvailable ? currentNetworkCanvas.bottom : wifiNetworkList.top
                anchors.topMargin: isConnectedWifiAvailable ? NodoSystem.nodoTopMargin : 0
                anchors.right: wifiNetworkList.right
                color: "black"
                height: ssidList.contentHeight + 16

                ListView {
                    id: ssidList
                    anchors.left: availableNetworksCanvas.left
                    anchors.top: availableNetworksCanvas.top
                    anchors.right: availableNetworksCanvas.right
                    anchors.bottom: availableNetworksCanvas.bottom

                    model: wifiListModel
                    visible: true
                    interactive: false

                    delegate: NodoWiFiNetworkListDelegate {
                        id: networkDelegate
                        ssidIndex: model.ssidIndex
                        width: ssidList.width
                    }

                    spacing: NodoSystem.nodoTopMargin
                }
            }
        }
    }

    ListModel {
        id: wifiListModel
    }
}

