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

    Rectangle {
        id: ethernetIPConfigSwitchRect
        x: 0
        y: 0
        height: 64

        Text{
            id: ethernetIPConfigSwitchText
            x: 0
            y: (ethernetIPConfigSwitch.height - ethernetIPConfigSwitchText.paintedHeight)/2
            width: ethernetIPConfigSwitchText.paintedWidth
            height: ethernetIPConfigSwitchRect.height
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
            height:40
            text: qsTr("")
            display: AbstractButton.IconOnly
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
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: ethernetSubnetMaskField
        x: 0
        y: ethernetIPAddressField.y + ethernetIPAddressField.height + 10
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Subnet Mask"
        valueText: ""
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
        valueText: ""
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
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }
}


