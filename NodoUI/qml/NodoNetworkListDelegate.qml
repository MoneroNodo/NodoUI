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
    property int buttonSize: 220
    property int defaultHeight: 100
    property int spacing: 1

    height: defaultHeight

    property string ssidName: networkManager.getSSIDName(ssidIndex)

    color: "#181818"

    Component.onCompleted:
    {
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
        anchors.topMargin: 4
        anchors.leftMargin: 11
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        font.family: NodoSystem.fontUrbanist.name
        height: 40
        text: mainRect.ssidName
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
    }

    NodoButton {
        id: connectButton
        anchors.top: mainRect.top
        anchors.right: mainRect.right
        anchors.topMargin: 18
        anchors.rightMargin: 11
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: qsTr("Connect")
        visible: true
        isActive: true
        fitMinimal: true

        onClicked: {
            if(networkManager.isWiFiConnectedBefore(ssidIndex))
            {
                connectButton.isActive = false
                connectButton.text = qsTr("Connecting")
                connectButton.update()
                networkManager.activateWiFi(mainRect.ssidName)
                networkManager.startWifiScan()
            }
            else
            {
                if(ssidEncryption === "" )
                {
                    connectButton.isActive = false
                    connectButton.text = qsTr("Connecting")
                    connectButton.update()
                    networkManager.connectToWiFi(mainRect.ssidName, passwordInputField.valueText, dhcpSwitch.checked, wifiIPAddressField.valueText, wifiSubnetMaskField.valueText, wifiRouterField.valueText, wifiDNSField.valueText)
                    networkManager.startWifiScan()
                }
                else
                {
                    if(passwordInputField.valueText.length >= 8)
                    {
                        connectButton.isActive = false
                        connectButton.text = qsTr("Connecting")
                        connectButton.update()
                        networkManager.connectToWiFi(mainRect.ssidName, passwordInputField.valueText, dhcpSwitch.checked, wifiIPAddressField.valueText, wifiSubnetMaskField.valueText, wifiRouterField.valueText, wifiDNSField.valueText)
                        networkManager.startWifiScan()
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
        anchors.topMargin: 18
        anchors.rightMargin: 10
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: qsTr("Forget")
        visible: networkManager.isWiFiConnectedBefore(ssidIndex)
        isActive: true
        fitMinimal: true
        onClicked: {
            forgetButton.isActive = false
            networkManager.forgetNetwork(mainRect.ssidName)
        }
    }

    Rectangle {
        id: ssidSignalStrengthRect
        anchors.top: forgetButton.top
        anchors.right: forgetButton.visible ? forgetButton.left : connectButton.left
        anchors.topMargin: (connectButton.height - height)/2
        anchors.rightMargin: 16
        width: 48
        height: 48
        color: "transparent"

        Image {
            id: ssidSignalStrengthImage
            anchors.fill: parent
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
            anchors.right: ssidSignalStrengthImage.right
            anchors.bottom: ssidSignalStrengthImage.bottom
            width: 18
            height: 18
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
        anchors.leftMargin: 11
        anchors.topMargin: 10
        width: mainRect.width - (22)
        height: frequencyField.y + frequencyField.height + 8
        visible:  mainRect.state === "showDetails" ? true : false
        color: "transparent"

        NodoInfoField{
            id: sSIDField
            anchors.left: showDetailsRect.left
            anchors.top: showDetailsRect.top
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: 300
            height: networkDelegateItemHeight
            itemText: qsTr("SSID")
            valueText: ssidNameLabel.text
        }

        NodoInfoField{
            id: signalStrengthField
            anchors.left: showDetailsRect.left
            anchors.top: sSIDField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: 300
            height: networkDelegateItemHeight
            itemText: qsTr("Signal Strength")
            valueText: mainRect.ssidSignalStrength + "%"
        }

        NodoInfoField{
            id: secutityField
            anchors.left: showDetailsRect.left
            anchors.top: signalStrengthField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: 300
            height: networkDelegateItemHeight
            itemText: qsTr("Security Type")
            valueText: mainRect.ssidEncryption
        }

        NodoInfoField{
            id: frequencyField
            anchors.left: showDetailsRect.left
            anchors.top: secutityField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: 300
            height: networkDelegateItemHeight
            itemText: qsTr("Frequency")
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
        anchors.leftMargin: 11
        anchors.topMargin: 10
        width: mainRect.width - (22)
        height: 110
        visible: mainRect.state === "showDetails" || mainRect.state === "" ? false : true
        color: "transparent"

        NodoInputField {
            id: passwordInputField
            anchors.left: connectToANetworkRect.left
            anchors.top: connectToANetworkRect.top
            width: connectToANetworkRect.width
            height: networkDelegateItemHeight
            itemSize: labelSize
            itemText: qsTr("Password")
            valueText:""
            passwordInput: true
        }

        NodoButton {
            id: advancedSettings
            anchors.top: passwordInputField.bottom
            anchors.left: connectToANetworkRect.left
            anchors.leftMargin: (connectToANetworkRect.width - advancedSettings.width)/2
            anchors.topMargin: 20
            width: mainRect.buttonSize
            height: networkDelegateItemHeight
            font.pixelSize: NodoSystem.infoFieldItemFontSize
            text: "Advanced"
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
            anchors.topMargin: 10
            height: dhcpSwitchRect.y + dhcpSwitchRect.height
            visible: mainRect.state === "showAdvancedConfigField" || mainRect.state === "showStaticConfigField" ? true : false
            color: "transparent"
            clip: true

            Rectangle {
                id: dhcpSwitchRect
                anchors.left: advancedSettingsRect.left
                anchors.top: advancedSettingsRect.top
                anchors.topMargin: mainRect.spacing
                height: networkDelegateItemHeight

                NodoLabel{
                    id: dhcpSwitchText
                    height: dhcpSwitchRect.height
                    anchors.left: dhcpSwitchRect.left
                    anchors.top: dhcpSwitchRect.top
                    itemSize: labelSize
                    text: "DHCP"
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
                width: advancedSettingsRect.width
                height: networkDelegateItemHeight
                itemSize: labelSize
                itemText: qsTr("IP Address")
                valueText: ""
                textFlag: Qt.ImhDigitsOnly
                inputMask: "000.000.000.000;0"
                validator:RegularExpressionValidator{
                    regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                }
            }

            NodoInputField {
                id: wifiSubnetMaskField
                anchors.top: wifiIPAddressField.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
                width: advancedSettingsRect.width
                height: networkDelegateItemHeight
                itemSize: labelSize
                itemText: qsTr("Subnet Mask")
                valueText: ""
                textFlag: Qt.ImhDigitsOnly
                inputMask: "000.000.000.000;0"
                validator:RegularExpressionValidator{
                    regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                }
            }

            NodoInputField {
                id: wifiRouterField
                anchors.top: wifiSubnetMaskField.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
                width: advancedSettingsRect.width
                height: networkDelegateItemHeight
                itemSize: labelSize
                itemText: qsTr("Router")
                valueText: ""
                textFlag: Qt.ImhDigitsOnly
                inputMask: "000.000.000.000;0"
                validator:RegularExpressionValidator{
                    regularExpression: /^((?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5]).){3}(?:[0-1]?[0-9]?[0-9]|2?[0-4]?[0-9]|25[0-5])$/
                }
            }

            NodoInputField {
                id: wifiDNSField
                anchors.top: wifiRouterField.bottom
                anchors.left: advancedSettingsRect.left
                anchors.topMargin: mainRect.spacing
                width: advancedSettingsRect.width
                height: networkDelegateItemHeight
                itemSize: labelSize
                itemText: qsTr("DNS")
                valueText: ""
                textFlag: Qt.ImhDigitsOnly
                inputMask: "000.000.000.000;0"
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
            PropertyChanges { target: mainRect; height: defaultHeight+showDetailsRect.height }
        },
        State {
            name: ""
            PropertyChanges { target: mainRect; height: defaultHeight }
        },
        State {
            name: "showPasswordField"
            PropertyChanges { target: mainRect; height: 80 + connectToANetworkRect.height + advancedSettingsRect.height}
            PropertyChanges { target: advancedSettingsRect; height: 73 }
        },
        State {
            name: "showAdvancedConfigField"
            PropertyChanges { target: mainRect; height: 155 + connectToANetworkRect.height + advancedSettingsRect.height}
            PropertyChanges { target: advancedSettingsRect; height: 73 }
        },
        State {
            name: "showStaticConfigField"
            PropertyChanges { target: mainRect; height: 605 }
            PropertyChanges { target: advancedSettingsRect; height: 343 }
        }
    ]

    transitions: Transition {
        NumberAnimation { target: mainRect; properties: "height"; easing.type: Easing.OutExpo; duration: 150 }
    }
}
