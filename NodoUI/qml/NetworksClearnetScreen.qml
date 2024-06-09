import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: networksClearnetScreen
    property int labelSize: 0

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        nodoControl.requestNetworkIP();
    }

    function onCalculateMaximumTextLabelLength() {
        if(clearnetAddressField.labelRectRoundSize > labelSize)
        labelSize = clearnetAddressField.labelRectRoundSize

        if(clearnetPortField.labelRectRoundSize > labelSize)
        labelSize = clearnetPortField.labelRectRoundSize

        if(clearnetPeerField.labelRectRoundSize > labelSize)
        labelSize = clearnetPeerField.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            clearnetPortField.valueText = nodoConfig.getIntValueFromKey("config", "monero_public_port")
            clearnetPeerField.valueText = nodoConfig.getStringValueFromKey("config", "add_clearnet_peer")
        }
    }

    Connections {
        target: nodoControl
        function onNetworkConnStatusReady() {
            clearnetAddressField.valueText = nodoControl.getNetworkIP();
            qr.setQrData(clearnetAddressField.valueText + ":" + clearnetPortField.valueText)
        }
    }

    NodoInfoField {
        id: clearnetAddressField
        anchors.left: networksClearnetScreen.left
        anchors.top: networksClearnetScreen.top
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Address")
        valueText: ""
    }

    NodoInputField {
        id: clearnetPortField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Port")
        valueText: nodoConfig.getIntValueFromKey("config", "monero_public_port")
        textFlag: Qt.ImhDigitsOnly
        onTextEditFinished: {
        }
    }

    NodoInputField {
        id: clearnetPeerField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: nodoConfig.getStringValueFromKey("config", "add_clearnet_peer")
        textFlag: Qt.ImhPreferLowercase
        onTextEditFinished: {
        }
    }

    NodoButton {
        id: clearnetAddPeerButton
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Set Peer")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }

    Rectangle{
        id: qrCodeRect
        anchors.right: networksClearnetScreen.right
        anchors.top: networksClearnetScreen.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.rightMargin: 100
        color: "black"
        width: 512
        height: 512

        QtQuick2QREncode {
            id: qr
            width: qrCodeRect.width
            height: qrCodeRect.height
            qrSize: Qt.size(width,width)
            qrData: clearnetAddressField.valueText + ":" + clearnetPortField.valueText
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}
