import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceWifiScreen
    property int labelSize: 0
    property int inputFieldWidth: 600

    anchors.fill: parent

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(wifiSSIDField.labelRectRoundSize > labelSize)
        labelSize = wifiSSIDField.labelRectRoundSize

        if(wifiPassphraseField.labelRectRoundSize > labelSize)
        labelSize = wifiPassphraseField.labelRectRoundSize

        if(wifiStatusField.labelRectRoundSize > labelSize)
        labelSize = wifiStatusField.labelRectRoundSize

        if(wifiIPAddressField.labelRectRoundSize > labelSize)
        labelSize = wifiIPAddressField.labelRectRoundSize

        if(wifiSubnetMaskField.labelRectRoundSize > labelSize)
        labelSize = wifiSubnetMaskField.labelRectRoundSize

        if(wifiRouterField.labelRectRoundSize > labelSize)
        labelSize = wifiRouterField.labelRectRoundSize

        if(wifiDHCPField.labelRectRoundSize > labelSize)
        labelSize = wifiDHCPField.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            wifiSwitch.checked = nodoConfig.getStringValueFromKey("wifi", "enabled") === "TRUE" ? true : false
            wifiSSIDField.valueText = nodoConfig.getStringValueFromKey("wifi", "ssid")
            wifiPassphraseField.valueText = ("" === nodoConfig.getStringValueFromKey("wifi", "pw")) ? "" : "******"
            wifiIPConfigSwitch.checked = nodoConfig.getStringValueFromKey("wifi", "auto") === "TRUE" ? true : false
            wifiIPAddressField.valueText = nodoConfig.getStringValueFromKey("wifi", "ip")
            wifiSubnetMaskField.valueText =  nodoConfig.getStringValueFromKey("wifi", "subnet")
            wifiRouterField.valueText =  nodoConfig.getStringValueFromKey("wifi", "router")
            wifiDHCPField.valueText =  nodoConfig.getStringValueFromKey("wifi", "dhcp")
        }
    }

    Rectangle {
        id: wifiSwitchRect
        anchors.left: deviceWifiScreen.left
        anchors.top: deviceWifiScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: wifiSwitchText
            height: wifiSwitchRect.height
            anchors.top: wifiSwitchRect.top
            anchors.left: wifiSwitchRect.left
            text: qsTr("Wi-Fi")
        }

        NodoSwitch {
            id: wifiSwitch
            anchors.left: wifiSwitchText.right
            anchors.top: wifiSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*wifiSwitchRect.height
            height: wifiSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("wifi", "enabled") === "TRUE" ? true : false
        }
    }

    NodoComboBox
    {
        id: wifiSSIDListComboBox
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoComboboxHeight
        model: ["Select ..."]
    }


    NodoInputField {
        id: wifiSSIDField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSSIDListComboBox.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("SSID")
        valueText: nodoConfig.getStringValueFromKey("wifi", "ssid")
    }

    NodoInputField {
        id: wifiPassphraseField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSSIDField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Password")
        valueText: ("" === nodoConfig.getStringValueFromKey("wifi", "pw")) ? "" : "******"
        passwordInput: true
    }

    NodoInfoField {
        id: wifiStatusField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiPassphraseField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Status")
        valueText: "enabled"
    }

    Rectangle {
        id: wifiIPConfigSwitchRect
        anchors.top: deviceWifiScreen.top
        x: 640
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: wifiIPConfigSwitchText
            height: wifiIPConfigSwitchRect.height
            anchors.top: wifiIPConfigSwitchRect.top
            anchors.left: wifiIPConfigSwitchRect.left
            text: qsTr("Automatic")
        }

        NodoSwitch {
            id: wifiIPConfigSwitch          
            anchors.left: wifiIPConfigSwitchText.right
            anchors.top: wifiIPConfigSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*wifiIPConfigSwitchRect.height
            height: wifiIPConfigSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("wifi", "auto") === "TRUE" ? true : false
        }
    }

    NodoInputField {
        id: wifiIPAddressField
        anchors.top: wifiIPConfigSwitchRect.bottom
        anchors.left: wifiIPConfigSwitchRect.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("IP Address")
        valueText: nodoConfig.getStringValueFromKey("wifi", "ip")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInputField {
        id: wifiSubnetMaskField
        anchors.top: wifiIPAddressField.bottom
        anchors.left: wifiIPConfigSwitchRect.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Subnet Mask")
        valueText: nodoConfig.getStringValueFromKey("wifi", "subnet")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInputField {
        id: wifiRouterField
        anchors.top: wifiSubnetMaskField.bottom
        anchors.left: wifiIPConfigSwitchRect.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Router")
        valueText: nodoConfig.getStringValueFromKey("wifi", "router")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInputField {
        id: wifiDHCPField
        anchors.top: wifiRouterField.bottom
        anchors.left: wifiIPConfigSwitchRect.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("DHCP")
        valueText: nodoConfig.getStringValueFromKey("wifi", "dhcp")
        textFlag: Qt.ImhDigitsOnly
    }
}



