import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: 300

    property int ssidSignalStrength
    property string ssidEncryption
    property double ssidFrequency
    property int ssidIndex
    property int networkDelegateItemHeight: NodoSystem.nodoItemHeight
    property int labelSize: 200
    property bool showConnected: true
    property int buttonSize: 300
    property int defaultHeight: 100
    property int spacing: 1

    height: defaultHeight

    property string ssidName
    property string connectionPath

    color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn  : NodoSystem.dataFieldTextBGColorNightModeOff

    Component.onCompleted:
    {
        ssidName = networkManager.getSSIDName(ssidIndex)
        connectionPath = networkManager.getSSIDConnectionPath(ssidIndex)
        ssidEncryption = networkManager.getSSIDEncryptionType(ssidIndex)
        ssidSignalStrength = networkManager.getSSIDSignalStrength(ssidIndex)
        ssidFrequency = networkManager.getSSIDFrequency(ssidIndex)/1000

        onCalculateMaximumTextLabelLengthForNotConnected()
    }

    function onCalculateMaximumTextLabelLengthForNotConnected() {
        if(passwordInputField.labelRectRoundSize > labelSize)
            labelSize = passwordInputField.labelRectRoundSize

        if(dhcpSwitchText.labelRectRoundSize > labelSize)
            labelSize = dhcpSwitchText.labelRectRoundSize

        if(wifiIPAddressField.labelRectRoundSize > labelSize)
            labelSize = wifiIPAddressField.labelRectRoundSize

        if(wifiSubnetMaskField.labelRectRoundSize > labelSize)
            labelSize = wifiSubnetMaskField.labelRectRoundSize

        if(wifiRouterField.labelRectRoundSize > labelSize)
            labelSize = wifiRouterField.labelRectRoundSize

        if(wifiDNSField.labelRectRoundSize > labelSize)
            labelSize = wifiDNSField.labelRectRoundSize
    }

    Label {
        id: ssidNameLabel
        anchors.top: mainRect.top
        anchors.left: mainRect.left
        anchors.topMargin: connectButton.y + (ssidNameLabel.paintedHeight)/2
        anchors.leftMargin: 20
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        font.family: NodoSystem.fontInter.name
        height: 40
        text: mainRect.ssidName
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
    }

    NodoButton {
        id: connectButton
        anchors.top: mainRect.top
        anchors.right: mainRect.right
        anchors.topMargin: 14
        anchors.rightMargin: 14
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: systemMessages.messages[NodoMessages.Message.Connect]
        visible: true
        isActive: true
        fitMinimal: true

        onClicked: {
            if(networkManager.isWiFiConnectedBefore(ssidIndex))
            {
                connectButton.isActive = false
                connectButton.text = systemMessages.messages[NodoMessages.Message.Connecting]
                connectButton.update()
                networkManager.activateWiFi(connectionPath)
            }
            else
            {
                if(mainRect.ssidEncryption === "" )
                {
                    connectButton.isActive = false
                    connectButton.text = systemMessages.messages[NodoMessages.Message.Connecting]
                    connectButton.update()
                    networkManager.connectToWiFi(mainRect.ssidName, "", dhcpSwitch.checked, wifiIPAddressField.valueText, wifiSubnetMaskField.valueText, wifiRouterField.valueText, wifiDNSField.valueText, mainRect.ssidEncryption)
                }
                else
                {
                    if(passwordInputField.valueText.length >= 8)
                    {
                        connectButton.isActive = false
                        connectButton.text = systemMessages.messages[NodoMessages.Message.Connecting]
                        connectButton.update()
                        networkManager.connectToWiFi(mainRect.ssidName, passwordInputField.valueText, dhcpSwitch.checked, wifiIPAddressField.valueText, wifiSubnetMaskField.valueText, wifiRouterField.valueText, wifiDNSField.valueText, mainRect.ssidEncryption)
                    }
                    else
                    {
                        mainRect.state = "showPasswordField"
                        networkManager.stopWifiScan()
                    }
                }
            }
        }
    }

    NodoButton {
        id: forgetButton
        anchors.top: mainRect.top
        anchors.right: connectButton.left
        anchors.topMargin: 14
        anchors.rightMargin: 20
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: systemMessages.messages[NodoMessages.Message.Forget]
        visible: networkManager.isWiFiConnectedBefore(ssidIndex)
        isActive: true
        fitMinimal: true
        onClicked: {
            forgetButton.isActive = false
            networkManager.forgetWirelessNetwork(mainRect.connectionPath)
        }
    }

    Rectangle {
        id: ssidSignalStrengthRect
        anchors.top: forgetButton.top
        anchors.right: forgetButton.visible ? forgetButton.left : connectButton.left
        anchors.topMargin: ((connectButton.height - height)/2) -4
        anchors.rightMargin: 20
        width: 84
        height: 84
        color: "transparent"

        Image {
            id: ssidSignalStrengthImage
            anchors.fill: parent
            mipmap: true
            source:
            {
                if(ssidSignalStrength < 20)
                {
                    "qrc:/Images/WifiSignal_0.png"
                }
                else if(ssidSignalStrength < 40)
                {
                    "qrc:/Images/WifiSignal_1.png"
                }
                else if(ssidSignalStrength < 60)
                {
                    "qrc:/Images/WifiSignal_2.png"
                }
                else if(ssidSignalStrength < 80)
                {
                    "qrc:/Images/WifiSignal_3.png"
                }
                else
                {
                    "qrc:/Images/WifiSignal_4.png"
                }
            }
        }

        Image {
            id: ssidEncryptionImage
            anchors.top: ssidSignalStrengthRect.top
            anchors.right: ssidSignalStrengthImage.left
            anchors.rightMargin: 15
            anchors.topMargin: 14
            width: 60
            height: 60
            visible:
            {
                var ency = ssidEncryption
                if((ency === "WPA2") || (ency === "WPA3"))
                {
                    true
                }
                else
                {
                    false
                }
            }
            source:
            {
                "qrc:/Images/wifi_secure.png"
            }
        }
    }

    Rectangle {
        id: showDetailsRect
        anchors.top: ssidSignalStrengthRect.bottom
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        anchors.topMargin: 5
        height: frequencyField.y + frequencyField.height
        visible:  mainRect.state === "showDetails" ? true : false
        color: "transparent"

        NodoInfoField{
            id: signalStrengthField
            anchors.left: showDetailsRect.left
            anchors.top: showDetailsRect.top
            anchors.topMargin: 5//mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.SignalStrength]
            valueText: mainRect.ssidSignalStrength + "%"
        }

        NodoInfoField{
            id: securityField
            anchors.left: showDetailsRect.left
            anchors.top: signalStrengthField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.SecurityType]
            valueText: mainRect.ssidEncryption
        }

        NodoInfoField{
            id: frequencyField
            anchors.left: showDetailsRect.left
            anchors.top: securityField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.Frequency]
            valueText: {
                var freq = mainRect.ssidFrequency
                freq.toFixed(1) + " GHz"
            }
        }
    }

    Rectangle {
        id: connectToANetworkRect
        anchors.top: ssidSignalStrengthRect.bottom
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        anchors.topMargin: 5
        height: 115
        visible: mainRect.state === "showDetails" || mainRect.state === "" ? false : true
        color: "transparent"

        NodoInputField {
            id: passwordInputField
            anchors.left: connectToANetworkRect.left
            anchors.top: connectToANetworkRect.top
            width: connectToANetworkRect.width
            height: networkDelegateItemHeight
            itemSize: labelSize
            itemText: systemMessages.messages[NodoMessages.Message.Password]

            valueText:""
            visible: connectToANetworkRect.visible && mainRect.ssidEncryption != "WEP"
            passwordInput: true
        }

        NodoButton {
            id: advancedSettings
            anchors.top: passwordInputField.bottom
            anchors.left: connectToANetworkRect.left
            //anchors.rightMargin: 14//(connectToANetworkRect.width - advancedSettings.width)/2
            width: mainRect.buttonSize
            height: networkDelegateItemHeight
            font.pixelSize: NodoSystem.infoFieldItemFontSize
            text: systemMessages.messages[NodoMessages.Message.Advanced] //qsTr("Advanced")
            visible:  connectToANetworkRect.visible
            fitMinimal: true
            onClicked: {
                if("showPasswordField" === mainRect.state)
                {
                    if(dhcpSwitch.checked)
                    {
                        mainRect.state = "showAdvancedConfigField"
                    }
                    else
                    {
                        mainRect.state = "showStaticConfigField"
                    }
                }
                else
                {
                    mainRect.state = "showPasswordField"
                }
            }
        }

        Rectangle {
            id: advancedSettingsRect
            anchors.top: advancedSettings.bottom
            anchors.left: connectToANetworkRect.left
            anchors.right: connectToANetworkRect.right
            anchors.topMargin: mainRect.spacing
            height: dhcpSwitchRect.y + dhcpSwitchRect.height
            visible: mainRect.state === "showAdvancedConfigField" || mainRect.state === "showStaticConfigField" ? true : false
            color: "transparent"
            clip: true

            Rectangle {
                id: dhcpSwitchRect
                anchors.top: advancedSettingsRect.top
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
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
                            mainRect.state = "showAdvancedConfigField"
                        }
                        else
                        {
                            mainRect.state = "showStaticConfigField"
                        }
                    }
                }
            }

            NodoInputField {
                id: wifiIPAddressField
                anchors.top: dhcpSwitchRect.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: 10
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
                id: wifiSubnetMaskField
                anchors.top: wifiIPAddressField.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
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
                id: wifiRouterField
                anchors.top: wifiSubnetMaskField.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
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
                id: wifiDNSField
                anchors.top: wifiRouterField.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
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

    MouseArea {
        anchors.fill: parent;
        z: -1
        onClicked: {
            if((mainRect.state === ""))
            {
                mainRect.state = "showDetails"
                networkManager.stopWifiScan()
            }
            else
            {
                mainRect.state = ""
                networkManager.startWifiScan()
            }
        }
    }

    states: [
        State {
            name: "showDetails";
            PropertyChanges { target: mainRect; height: defaultHeight + showDetailsRect.height +10}
        },
        State {
            name: ""
            PropertyChanges { target: mainRect; height: defaultHeight }
        },
        State {
            name: "showPasswordField"
            PropertyChanges { target: mainRect; height: 82 + connectToANetworkRect.height + advancedSettingsRect.height}
            PropertyChanges { target: advancedSettingsRect; height: 75 }
        },
        State {
            name: "showAdvancedConfigField"
            PropertyChanges { target: mainRect; height: 160 + connectToANetworkRect.height + advancedSettingsRect.height}
            PropertyChanges { target: advancedSettingsRect; height: 80 }
        },
        State {
            name: "showStaticConfigField"
            PropertyChanges { target: mainRect; height: 680 }
            PropertyChanges { target: advancedSettingsRect; height: 410 }
        }
    ]

    transitions: Transition {
        NumberAnimation { target: mainRect; properties: "height"; easing.type: Easing.OutExpo; duration: 150 }
    }
}
