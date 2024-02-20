import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: deviceEthernetScreen
    anchors.fill: parent
    property int labelSize: 192

    Component.onCompleted: {
        nodoConfig.updateRequested()
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            ethernetIPConfigSwitch.checked = nodoConfig.getStringValueFromKey("ethernet", "auto") === "TRUE" ? true : false
            ethernetIPAddressField.valueText = nodoConfig.getStringValueFromKey("ethernet", "ip")
            ethernetSubnetMaskField.valueText = nodoConfig.getStringValueFromKey("ethernet", "subnet")
            ethernetRouterField.valueText = nodoConfig.getStringValueFromKey("ethernet", "router")
            ethernetDHCPField.valueText = nodoConfig.getStringValueFromKey("ethernet", "dhcp")

        }
    }

    Rectangle {
        id: ethernetIPConfigSwitchRect
        x: 0
        y: 0
        height: 64

        Text{
            id: ethernetIPConfigSwitchText
            width: ethernetIPConfigSwitchText.paintedWidth
            height: ethernetIPConfigSwitchRect.height
            x: 0
            y: 0
            //y: (ethernetIPConfigSwitchRect.height - etherenetIPConfigSwitch.height)/2
            text: "Automatic"
            verticalAlignment: Text.AlignBottom
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: ethernetIPConfigSwitch
            x: ethernetIPConfigSwitchText.width + 20
            y: 0
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("ethernet", "auto") === "TRUE" ? true : false
        }
    }

    NodoInputField {
        id: ethernetIPAddressField
        x: 0
        y: ethernetIPConfigSwitchRect.y + ethernetIPConfigSwitchRect.height + 20
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "IP Address"
        valueText: nodoConfig.getStringValueFromKey("ethernet", "ip")
        textFlag: Qt.ImhPreferNumbers
        readOnlyFlag: ethernetIPConfigSwitch.checked
    }

    NodoInputField {
        id: ethernetSubnetMaskField
        x: 0
        y: ethernetIPAddressField.y + ethernetIPAddressField.height + 10
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Subnet Mask"
        valueText: nodoConfig.getStringValueFromKey("ethernet", "subnet")
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: ethernetRouterField
        x: 0
        y: ethernetSubnetMaskField.y + ethernetSubnetMaskField.height + 10
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Router"
        valueText: nodoConfig.getStringValueFromKey("ethernet", "router")
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: ethernetDHCPField
        x: 0
        y: ethernetRouterField.y + ethernetRouterField.height + 10
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "DHCP"
        valueText: nodoConfig.getStringValueFromKey("ethernet", "dhcp")
        textFlag: Qt.ImhPreferNumbers
    }
}


