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
    color: "#141414"

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
        getCurrentNetworkStatus()
        // getWifiList()
    }

    function onCalculateMaximumTextLabelLength() {
        if(currentNetworkLabel.labelRectRoundSize > labelSize)
            labelSize = currentNetworkLabel.labelRectRoundSize

        if(availableNetworksLabel.labelRectRoundSize > labelSize)
            labelSize = availableNetworksLabel.labelRectRoundSize
    }

    function getWifiList() {
        isScanComplete = false;
        var ssidSize = networkManager.getSSIDListSize()

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
            id: wifiNetworkList
            width: parent.width
            height: currentNetworkCanvas.height + availableNetworksCanvas.height + 8
            implicitHeight: height

            NodoCanvas {
                id: currentNetworkCanvas
                anchors.left: wifiNetworkList.left
                anchors.top: wifiNetworkList.top
                anchors.right: wifiNetworkList.right
                color: "#141414"
                visible: isConnectedWifiAvailable
                height: currentWifiDelegate.y + currentWifiDelegate.height+8

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
                    text: qsTr("Current network")
                }

                NodoNetworkConnectedProfile {
                    id: currentWifiDelegate
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
                anchors.left: wifiNetworkList.left
                anchors.top: isConnectedWifiAvailable ? currentNetworkCanvas.bottom : wifiNetworkList.top
                anchors.topMargin: isConnectedWifiAvailable ? 5 : 0
                anchors.right: wifiNetworkList.right
                color: "#141414"
                height: availableNetworksLabel.height + ssidList.contentHeight + 16

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
                    text: qsTr("Available networks")
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
                    id: ssidList
                    anchors.left: availableNetworksCanvas.left
                    anchors.top: availableNetworksLabel.bottom
                    anchors.right: availableNetworksCanvas.right
                    anchors.bottom: availableNetworksCanvas.bottom
                    anchors.topMargin: 3
                    anchors.bottomMargin: 8
                    anchors.leftMargin: 11
                    anchors.rightMargin: 11

                    model: wifiListModel
                    visible: isScanComplete
                    interactive: false

                    delegate: NodoNetworkListDelegate {
                        id: networkDelegate
                        ssidIndex: model.ssidIndex
                        width: ssidList.width
                    }

                    spacing: 3
                }
            }
        }
    }

    ListModel {
        id: wifiListModel
    }
}

