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
    property bool isConnectedEthProfileAvailable: false
    color: "black"

    Component.onCompleted: {
        getCurrentNetworkStatus()
        getEthernetList()
    }

    function getEthernetList() {
        isScanComplete = false;

        ethernetListModel.clear()
        for (var index = 0;index < networkManager.getEthernetConnectionListSize(); index++) {
            var ethConnIndex = { "ethConnIndex": index}
            ethernetListModel.append(ethConnIndex)
        }

        isScanComplete = true;
    }

    function getCurrentNetworkStatus() {
        isConnectedEthProfileAvailable = networkManager.isConnectedEthernetProfileAvailable()
    }

    Connections {
        target: networkManager

        function onEthernetScanCopleted() {
            getEthernetList()
        }

        function onConnectedEthernetParamsUpdated() {
            getCurrentNetworkStatus()
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
            id: ethProfileList
            width: parent.width
            height: currentNetworkCanvas.height + availableNetworksCanvas.height
            implicitHeight: height

            NodoCanvas {
                id: currentNetworkCanvas
                anchors.left: ethProfileList.left
                anchors.top: ethProfileList.top
                anchors.right: ethProfileList.right
                color: "black"
                visible: isConnectedEthProfileAvailable
                height: currentEthDelegate.y + currentEthDelegate.height

                NodoEthernetNetworkConnectedProfile {
                    id: currentEthDelegate
                    anchors.left: currentNetworkCanvas.left
                    anchors.top: currentNetworkCanvas.top
                    anchors.right: currentNetworkCanvas.right
                }
            }

            NodoCanvas {
                id: availableNetworksCanvas
                anchors.left: ethProfileList.left
                anchors.top: isConnectedEthProfileAvailable ? currentNetworkCanvas.bottom : ethProfileList.top
                anchors.topMargin: isConnectedEthProfileAvailable ? NodoSystem.nodoTopMargin : 0
                anchors.right: ethProfileList.right
                color: "black"
                height: ethConnList.contentHeight

                ListView {
                    id: ethConnList
                    anchors.left: availableNetworksCanvas.left
                    anchors.top: availableNetworksCanvas.top
                    anchors.right: availableNetworksCanvas.right
                    anchors.bottom: availableNetworksCanvas.bottom

                    model: ethernetListModel
                    visible: isScanComplete
                    interactive: false

                    delegate: NodoEthernetNetworkListDelegate {
                        id: networkDelegate
                        ethConnIndex: model.ethConnIndex
                        width: ethConnList.width
                    }

                    spacing: NodoSystem.nodoTopMargin
                }
            }
        }
    }

    ListModel {
        id: ethernetListModel
    }
}

