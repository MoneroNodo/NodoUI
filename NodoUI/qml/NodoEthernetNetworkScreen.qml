import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: ethernetNetworkScreen
    width: parent.width
    height: parent.height
    property int labelSize: 300
    property bool isEthernetEnabled
    property int networkDelegateItemHeight: NodoSystem.nodoItemHeight

    property int buttonSize: 300
    property int defaultHeight: 100
    property int spacing: 1

    function onCalculateMaximumTextLabelLength() {
        if(ethConnectionNameField.labelRectRoundSize > labelSize)
            labelSize = ethConnectionNameField.labelRectRoundSize

        if(ethIPAddressField.labelRectRoundSize > labelSize)
            labelSize = ethIPAddressField.labelRectRoundSize

        if(ethSubnetMaskField.labelRectRoundSize > labelSize)
            labelSize = ethSubnetMaskField.labelRectRoundSize

        if(ethRouterField.labelRectRoundSize > labelSize)
            labelSize = ethRouterField.labelRectRoundSize

        if(ethDNSField.labelRectRoundSize > labelSize)
            labelSize = ethDNSField.labelRectRoundSize
    }

    function updateEthernetDeviceStatus() {
        var deviceStatus = networkManager.getEthernetDeviceStatus()
        ethernetNetworkScreen.isEthernetEnabled = true

        if(deviceStatus === 10)
        {
            ethernetNetworkScreen.isEthernetEnabled = false
            nodoEthernetNetworkPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.NoNetworkDevice]
            nodoEthernetNetworkPopup.commandID = -1;
            nodoEthernetNetworkPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            nodoEthernetNetworkPopup.open();
        }
        else if(deviceStatus === 20)
        {
            ethernetNetworkScreen.isEthernetEnabled = false
            nodoEthernetNetworkPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.CableDisconnected]
            nodoEthernetNetworkPopup.commandID = -1;
            nodoEthernetNetworkPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            nodoEthernetNetworkPopup.open();
        }

        if((deviceStatus === 30) || (deviceStatus === 100))
        {
            pageLoader.source = "NodoEthernetNetworkListView.qml"
        }
        else
        {
            pageLoader.source = ""
        }
    }

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
        updateEthernetDeviceStatus()
        networkManager.startEthScan()
    }

    Connections {
        target: networkManager
        function onEthernetDeviceStatusChanged() {
            updateEthernetDeviceStatus()
        }

        function onWiredConnectionProfileCreated() {
            createEthernetConnectionButton.isActive = false
            createEthernetConnectionButton.text = systemMessages.messages[NodoMessages.Message.Add]
            createEthernetConnectionButton.update()
            ethConnectionNameField.valueText = ""
            ethernetNetworkScreen.state = ""
            addEthernetConnectionButton.text = systemMessages.messages[NodoMessages.Message.AddNewConnection]
        }
    }

    NodoButton {
        id: addEthernetConnectionButton
        anchors.left: ethernetNetworkScreen.left
        anchors.top: ethernetNetworkScreen.top
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: systemMessages.messages[NodoMessages.Message.AddNewConnection]
        visible: true
        isActive: ethernetNetworkScreen.isEthernetEnabled
        fitMinimal: false
        onClicked:
        {
            if(ethernetNetworkScreen.state === "")
            {
                addEthernetConnectionButton.text = systemMessages.messages[NodoMessages.Message.Cancel]
                ethernetNetworkScreen.state = "createNewConnectionRect"
            }
            else {
                addEthernetConnectionButton.text = systemMessages.messages[NodoMessages.Message.AddNewConnection]
                ethernetNetworkScreen.state = ""
            }
        }
    }

    NodoCanvas {
        id: createNewConnectionCanvas
        anchors.top: addEthernetConnectionButton.bottom
        anchors.left: addEthernetConnectionButton.left
        anchors.topMargin: 10
        width: ethernetNetworkScreen.width
        height: 0
		color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn  : NodoSystem.dataFieldTextBGColorNightModeOff

        Rectangle {
            id: createNewConnectionRect
            anchors.top: createNewConnectionCanvas.top
            anchors.left: createNewConnectionCanvas.left
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            height: createNewConnectionCanvas.height - createEthernetConnectionRect.height// - 18
            visible: ethernetNetworkScreen.state === "" ? false : true
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff

            NodoInputField {
                id: ethConnectionNameField
                anchors.top: createNewConnectionRect.top
                anchors.left: createNewConnectionRect.left
                width: createNewConnectionRect.width
                height: networkDelegateItemHeight
                itemSize: labelSize
                itemText: systemMessages.messages[NodoMessages.Message.ConnectionName]
                valueText: ""
                onTextEditFinished: {
                    if(ethConnectionNameField.valueText !== "")
                    {
                        createEthernetConnectionButton.isActive = true
                    }
                }
            }

            Rectangle {
                id: dhcpSwitchRect
                anchors.left: ethConnectionNameField.left
                anchors.top: ethConnectionNameField.bottom
                anchors.topMargin: ethernetNetworkScreen.spacing
                height: NodoSystem.nodoItemHeight

                NodoLabel{
                    id: dhcpSwitchText
                    height: dhcpSwitchRect.height
                    anchors.left: dhcpSwitchRect.left
                    anchors.top: dhcpSwitchRect.top
                    itemSize: labelSize
                    text: systemMessages.messages[NodoMessages.Message.DHCP]
                }

                NodoSwitch {
                    id: dhcpSwitch
                    anchors.left: dhcpSwitchText.right
                    anchors.leftMargin: NodoSystem.padding
                    height: dhcpSwitchRect.height
                    width: 2*dhcpSwitchRect.height
                    display: AbstractButton.IconOnly
                    checked: true
                    onCheckedChanged: {
                        if(checked === true)
                        {
                            ethernetNetworkScreen.state = "createNewConnectionRect"
                        }
                        else
                        {
                            ethernetNetworkScreen.state = "showAdvancedConfigRect"
                        }
                    }
                }
            }

            Rectangle {
                id: advancedSettingsRect
                anchors.top: dhcpSwitchRect.bottom
                anchors.left: dhcpSwitchRect.left
                anchors.topMargin: ethernetNetworkScreen.spacing
                width: createNewConnectionRect.width
                height: ethDNSField.y + ethDNSField.height
                visible: ethernetNetworkScreen.state === "showAdvancedConfigRect" ? true : false
                color: "transparent"

                NodoInputField {
                    id: ethIPAddressField
                    anchors.top: advancedSettingsRect.top
                    anchors.left: advancedSettingsRect.left
                    anchors.topMargin: ethernetNetworkScreen.spacing
                    width: 700//advancedSettingsRect.width
                    height: networkDelegateItemHeight
                    itemSize: labelSize
                    itemText: systemMessages.messages[NodoMessages.Message.IPAddress]
                    valueText: ""
                    textFlag: Qt.ImhDigitsOnly
                    //inputMask: "000.000.000.000;0"
                    validator:RegularExpressionValidator{
                        regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                    }
                }

                NodoInputField {
                    id: ethSubnetMaskField
                    anchors.top: ethIPAddressField.bottom
                    anchors.left: advancedSettingsRect.left
                    anchors.topMargin: ethernetNetworkScreen.spacing
                    width: 700//advancedSettingsRect.width
                    height: networkDelegateItemHeight
                    itemSize: labelSize
                    itemText: systemMessages.messages[NodoMessages.Message.SubnetMask]
                    valueText: ""
                    textFlag: Qt.ImhDigitsOnly
                    //inputMask: "000.000.000.000;0"
                    validator:RegularExpressionValidator{
                        regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                    }
                }

                NodoInputField {
                    id: ethRouterField
                    anchors.top: ethSubnetMaskField.bottom
                    anchors.left: advancedSettingsRect.left
                    anchors.topMargin: ethernetNetworkScreen.spacing
                    width: 700//advancedSettingsRect.width
                    height: networkDelegateItemHeight
                    itemSize: labelSize
                    itemText: systemMessages.messages[NodoMessages.Message.Router]
                    valueText: ""
                    textFlag: Qt.ImhDigitsOnly
                    //inputMask: "000.000.000.000;0"
                    validator:RegularExpressionValidator{
                        regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                    }
                }

                NodoInputField {
                    id: ethDNSField
                    anchors.top: ethRouterField.bottom
                    anchors.left: advancedSettingsRect.left
                    anchors.topMargin: ethernetNetworkScreen.spacing
                    width: 700//advancedSettingsRect.width
                    height: networkDelegateItemHeight
                    itemSize: labelSize
                    itemText: systemMessages.messages[NodoMessages.Message.DNS]
                    valueText: ""
                    textFlag: Qt.ImhDigitsOnly
                    //inputMask: "000.000.000.000;0"
                    validator:RegularExpressionValidator{
                        regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                    }
                }
            }
        }


        Rectangle {
            id: createEthernetConnectionRect
            anchors.top: createNewConnectionRect.bottom
            anchors.left: createNewConnectionRect.left
            anchors.topMargin: 10
            height: NodoSystem.nodoItemHeight
            visible: ethernetNetworkScreen.state === "" ? false : true

            NodoButton {
                id: createEthernetConnectionButton
                anchors.top: createEthernetConnectionRect.top
                anchors.left: createEthernetConnectionRect.left
                anchors.bottom: createEthernetConnectionRect.bottom
                height: NodoSystem.nodoItemHeight
                font.pixelSize: NodoSystem.infoFieldItemFontSize
                text: systemMessages.messages[NodoMessages.Message.Add] //qsTr("Add")
                visible: createNewConnectionRect.visible
                isActive: false
                fitMinimal: false
                onClicked:
                {
                    createEthernetConnectionButton.isActive = false
                    createEthernetConnectionButton.text = systemMessages.messages[NodoMessages.Message.Adding]
                    createEthernetConnectionButton.update()
                    networkManager.connectToEthernet(ethConnectionNameField.valueText, dhcpSwitch.checked, ethIPAddressField.valueText, ethSubnetMaskField.valueText, ethRouterField.valueText, ethDNSField.valueText)
                }
            }
        }
    }

    Rectangle {
        id: ethernetNetworkView
        anchors.top: createNewConnectionCanvas.bottom
        anchors.left: createNewConnectionCanvas.left
        anchors.right: createNewConnectionCanvas.right
        anchors.bottom: ethernetNetworkScreen.bottom
        anchors.topMargin: 10
        color: "transparent"
        visible: ethernetNetworkScreen.isEthernetEnabled

        Loader {
            id: pageLoader
            anchors.top: ethernetNetworkView.top
            anchors.left: ethernetNetworkView.left
            anchors.right: ethernetNetworkView.right
            anchors.bottom: ethernetNetworkView.bottom
        }
    }

    states: [
        State {
            name: "createNewConnectionRect";
            PropertyChanges { target: createNewConnectionCanvas; height:200 + NodoSystem.nodoItemHeight}
        },
        State {
            name: ""
            PropertyChanges { target: createNewConnectionCanvas; height: 0 }
        },
        State {
            name: "showAdvancedConfigRect"
            PropertyChanges { target: createNewConnectionCanvas; height: 520 + NodoSystem.nodoItemHeight }
        }
    ]

    transitions: Transition {
        NumberAnimation { target: createNewConnectionCanvas; properties: "height"; easing.type: Easing.OutExpo; duration: 150 }
    }

    NodoPopup {
        id: nodoEthernetNetworkPopup
        onApplyClicked: {
            close()
        }
    }
}
