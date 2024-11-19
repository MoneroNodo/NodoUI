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

    property int labelSize: 300

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

        function onEthernetScanCompleted() {
            getEthernetList()
        }

        function onConnectedEthernetParamsUpdated() {
            getCurrentNetworkStatus()
        }
    }

    ScrollView {
        id: scrollMain
        anchors.fill: parent

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        clip: true
        Item {
            id: ethProfileList
            width: parent.width
            height: currentEthDelegate.height + ethConnList.contentHeight
            implicitHeight: height


            NodoEthernetNetworkConnectedProfile {
                id: currentEthDelegate
                anchors.left: ethProfileList.left
                anchors.top: ethProfileList.top
                anchors.right: ethProfileList.right
                visible: isConnectedEthProfileAvailable
            }

            ListView {
                id: ethConnList
                anchors.left: ethProfileList.left
                anchors.top: isConnectedEthProfileAvailable ? currentEthDelegate.bottom : ethProfileList.top
                anchors.topMargin: isConnectedEthProfileAvailable ? NodoSystem.nodoTopMargin : 0
                anchors.right: ethProfileList.right
                anchors.bottom: ethProfileList.bottom

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

    ListModel {
        id: ethernetListModel
    }
}

