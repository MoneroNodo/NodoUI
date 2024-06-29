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
    color: "#141414"

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
        getCurrentNetworkStatus()
        getEthernetList()
    }

    function onCalculateMaximumTextLabelLength() {
        if(currentNetworkLabel.labelRectRoundSize > labelSize)
            labelSize = currentNetworkLabel.labelRectRoundSize

        if(availableNetworksLabel.labelRectRoundSize > labelSize)
            labelSize = availableNetworksLabel.labelRectRoundSize
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

        anchors.leftMargin: 11
        anchors.rightMargin: 11
        anchors.topMargin: 8
        anchors.bottomMargin: 8

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        clip: true
        Item {
            id: ethProfileList
            width: parent.width
            height: currentNetworkCanvas.height + availableNetworksCanvas.height + 8
            implicitHeight: height

            NodoCanvas {
                id: currentNetworkCanvas
                anchors.left: ethProfileList.left
                anchors.top: ethProfileList.top
                anchors.right: ethProfileList.right
                color: "#141414"
                visible: isConnectedEthProfileAvailable
                height: currentEthDelegate.y + currentEthDelegate.height+8

                NodoLabel {
                    id: currentNetworkLabel
                    anchors.left: currentNetworkCanvas.left
                    anchors.top: currentNetworkCanvas.top
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8
                    anchors.leftMargin: 11
                    anchors.rightMargin: 11

                    font.pixelSize: NodoSystem.infoFieldItemFontSize
                    font.family: NodoSystem.fontUrbanist.name
                    height: NodoSystem.nodoItemHeight
                    text: systemMessages.messages[NodoMessages.Message.CurrentNetwork]
                }

                NodoEthernetNetworkConnectedProfile {
                    id: currentEthDelegate
                    anchors.left: currentNetworkCanvas.left
                    anchors.top: currentNetworkLabel.bottom
                    anchors.right: currentNetworkCanvas.right
                    anchors.topMargin: 3
                    anchors.bottomMargin: 8
                    anchors.leftMargin: 11
                    anchors.rightMargin: 11
                }
            }

            NodoCanvas {
                id: availableNetworksCanvas
                anchors.left: ethProfileList.left
                anchors.top: isConnectedEthProfileAvailable ? currentNetworkCanvas.bottom : ethProfileList.top
                anchors.topMargin: isConnectedEthProfileAvailable ? 5 : 0
                anchors.right: ethProfileList.right
                color: "#141414"
                height: availableNetworksLabel.height + ethConnList.contentHeight + 16

                NodoLabel {
                    id: availableNetworksLabel
                    anchors.left: availableNetworksCanvas.left
                    anchors.top: availableNetworksCanvas.top
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8
                    anchors.leftMargin: 11
                    anchors.rightMargin: 11
                    font.pixelSize: NodoSystem.infoFieldItemFontSize
                    font.family: NodoSystem.fontUrbanist.name
                    height: NodoSystem.nodoItemHeight
                    text: systemMessages.messages[NodoMessages.Message.AvailableNetworks]
                }

                NodoBusyIndicator {
                    id: busyIndicator
                    width: 48
                    height: 48
                    anchors.top: availableNetworksCanvas.top
                    anchors.right: availableNetworksCanvas.right
                    anchors.topMargin: availableNetworksLabel.height - height
                    anchors.rightMargin: 22
                    running: !isScanComplete
                    visible: !isScanComplete
                    indicatorColor: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                }

                ListView {
                    id: ethConnList
                    anchors.left: availableNetworksCanvas.left
                    anchors.top: availableNetworksLabel.bottom
                    anchors.right: availableNetworksCanvas.right
                    anchors.bottom: availableNetworksCanvas.bottom
                    anchors.topMargin: 3
                    anchors.bottomMargin: 8
                    anchors.leftMargin: 11
                    anchors.rightMargin: 11

                    model: ethernetListModel
                    visible: isScanComplete
                    interactive: false

                    delegate: NodoEthernetNetworkListDelegate {
                        id: networkDelegate
                        ethConnIndex: model.ethConnIndex
                        width: ethConnList.width
                    }

                    spacing: 3
                }
            }
        }
    }

    ListModel {
        id: ethernetListModel
    }
}

