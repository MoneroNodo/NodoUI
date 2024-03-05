import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: networksTorScreen
    property int labelSize: 0

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(torOnionAddressField.labelRectRoundSize > labelSize)
        labelSize = torOnionAddressField.labelRectRoundSize

        if(torPortField.labelRectRoundSize > labelSize)
        labelSize = torPortField.labelRectRoundSize

        if(torPeerField.labelRectRoundSize > labelSize)
        labelSize = torPeerField.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            torSwitch.checked = nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
            torRouteSwitch.checked = nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
            torOnionAddressField.valueText = nodoConfig.getStringValueFromKey("config", "tor_address")
            torPortField.valueText = nodoConfig.getIntValueFromKey("config", "tor_port")
            torPeerField.valueText = nodoConfig.getStringValueFromKey("config", "add_tor_peer")
        }
    }

    Rectangle {
        id: torSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: networksTorScreen.top
        height: 64

        Text{
            id:torSwitchText
            x: 0
            y: (torSwitch.height - torSwitchText.height)/2
            width: torSwitchText.paintedWidth
            height: torSwitchText.paintedHeight
            text: qsTr("Tor")
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: torSwitch
            x: torSwitchText.width + 20
            y: 0
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
        }
    }

    Rectangle {
        id: torRouteSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: torSwitchRect.bottom
        anchors.topMargin: 16
        height: 64

        Text{
            id:torRouteSwitchText
            x: 0
            y: (torRouteSwitch.height - torRouteSwitchText.height)/2
            width: torRouteSwitchText.paintedWidth
            height: torRouteSwitchText.paintedHeight
            text: qsTr("Route all connections through Tor")
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: torRouteSwitch
            x: torRouteSwitchText.width + 20
            y: 0
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
        }
    }

    NodoInfoField {
        id: torOnionAddressField
        anchors.left: networksTorScreen.left
        anchors.top: torRouteSwitchRect.bottom
        anchors.topMargin: 16
        width: 924
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Onion Address")
        valueText: nodoConfig.getStringValueFromKey("config", "tor_address")
    }

    NodoInputField {
        id: torPortField
        anchors.left: networksTorScreen.left
        anchors.top: torOnionAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Port")
        valueText: nodoConfig.getIntValueFromKey("config", "tor_port")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInfoField {
        id: torPeerField
        anchors.left: networksTorScreen.left
        anchors.top: torPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: nodoConfig.getStringValueFromKey("config", "add_tor_peer")
    }

    NodoButton {
        id: torAddPeerButton
        anchors.left: networksTorScreen.left
        anchors.top: torPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Set Peer")
        height: 64
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 16
        textRightPadding: 16
        frameRadius: 4
    }

    Label {
        id: torScanToLabel
        anchors.left: networksTorScreen.left
        anchors.top: torAddPeerButton.bottom
        anchors.topMargin: 64
        width: 497
        height: 60
        text: qsTr("Scan to add Nodo to your wallet app:")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    QtQuick2QREncode {
        id: qr
        x: 1000
        y: 10
        width: 512
        height: 512
        qrSize: Qt.size(width,width)
        qrData: torPeerField + ":" + torPortField
        qrForeground: "black"
        qrBackground: "white"
        qrMargin: 8
        qrMode: QtQuick2QREncode.MODE_8    //encode model
				qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
    }




}

