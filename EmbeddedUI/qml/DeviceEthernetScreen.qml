import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import QtQuick.VirtualKeyboard 2.1
import NodoCanvas 1.0


Item {
    id: deviceEthernetScreen
    anchors.fill: parent
    property int labelSize: 0
    property int inputFieldWidth: 600

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(ethernetIPAddressField.labelRectRoundSize > labelSize)
        labelSize = ethernetIPAddressField.labelRectRoundSize

        if(ethernetSubnetMaskField.labelRectRoundSize > labelSize)
        labelSize = ethernetSubnetMaskField.labelRectRoundSize

        if(ethernetRouterField.labelRectRoundSize > labelSize)
        labelSize = ethernetRouterField.labelRectRoundSize

        if(ethernetDHCPField.labelRectRoundSize > labelSize)
        labelSize = ethernetDHCPField.labelRectRoundSize
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
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: ethernetIPConfigSwitchText
            height: ethernetIPConfigSwitchRect.height
            anchors.top: ethernetIPConfigSwitchRect.top
            anchors.left: ethernetIPConfigSwitchRect.left
            text: qsTr("Automatic")
        }

        NodoSwitch {
            id: ethernetIPConfigSwitch
            anchors.left: ethernetIPConfigSwitchText.right
            anchors.top: ethernetIPConfigSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*ethernetIPConfigSwitchRect.height
            height: ethernetIPConfigSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("ethernet", "auto") === "TRUE" ? true : false
        }
    }

    NodoInputField {
        id: ethernetIPAddressField
        anchors.left: ethernetIPConfigSwitchRect.left
        anchors.top: ethernetIPConfigSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("IP Address")
        valueText: nodoConfig.getStringValueFromKey("ethernet", "ip")
        textFlag: Qt.ImhPreferNumbers
        readOnlyFlag: ethernetIPConfigSwitch.checked
    }

    NodoInputField {
        id: ethernetSubnetMaskField
        anchors.left: ethernetIPConfigSwitchRect.left
        anchors.top: ethernetIPAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Subnet Mask")
        valueText: nodoConfig.getStringValueFromKey("ethernet", "subnet")
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: ethernetRouterField
        anchors.left: ethernetIPConfigSwitchRect.left
        anchors.top: ethernetSubnetMaskField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Router")
        valueText: nodoConfig.getStringValueFromKey("ethernet", "router")
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: ethernetDHCPField
        anchors.left: ethernetRouterField.left
        anchors.top: ethernetSubnetMaskField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("DHCP")
        valueText: nodoConfig.getStringValueFromKey("ethernet", "dhcp")
        textFlag: Qt.ImhPreferNumbers
    }
}


