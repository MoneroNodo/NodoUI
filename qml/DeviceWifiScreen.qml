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
    id: deviceWifiScreen
    property int labelSize: 192
    anchors.fill: parent

    Rectangle {
        id: wifiSwitchRect
        anchors.left: deviceWifiScreen.left
        anchors.top: deviceWifiScreen.top

        height: 64

        Text{
            id:wifiSwitchText
            x: 0
            y: (wifiSwitch.height - wifiSwitchText.height)/2
            width: wifiSwitchText.paintedWidth
            height: wifiSwitchText.paintedHeight
            text: "Wi-Fi"
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: wifiSwitch
            x: wifiSwitchText.width + 20
            y: 0
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
        }
    }

    NodoComboBox
    {
        id: wifiSSIDListComboBox
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSwitchRect.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 15
        model: ["Select ..."]
//        model: ["First", "Second", "Third"]
    }


    NodoInputField {
        id: wifiSSIDField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSSIDListComboBox.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "SSID"
        valueText: ""
    }

    NodoInputField {
        id: wifiPassphraseField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSSIDField.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Passphrase"
        valueText: ""
    }

    NodoInfoField {
        id: wifiStatusField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiPassphraseField.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Status"
        valueText: "enabled"
    }

    Rectangle {
        id: wifiIPConfigSwitchRect
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiStatusField.bottom
        anchors.topMargin: 32
        height: 64

        Text{
            id:wifiIPConfigSwitchText
            x: 0
            y: (wifiIPConfigSwitch.height - wifiIPConfigSwitchText.height)/2
            width: wifiIPConfigSwitchText.paintedWidth
            height: wifiIPConfigSwitchText.paintedHeight
            text: "Automatic"
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: wifiIPConfigSwitch
            x: wifiIPConfigSwitchText.width + 20
            y: 0
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
        }
    }

    NodoInputField {
        id: wifiIPAddressField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiIPConfigSwitchRect.bottom
        anchors.topMargin: 32
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "IP Address"
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: wifiSubnetMaskField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiIPAddressField.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Subnet Mask"
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: wifiRouterField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiSubnetMaskField.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "Router"
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: wifiDHCPField
        anchors.left: deviceWifiScreen.left
        anchors.top: wifiRouterField.bottom
        anchors.topMargin: 16
        width: 370
        height: 60
        itemSize: labelSize
        itemText: "DHCP"
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }
}



