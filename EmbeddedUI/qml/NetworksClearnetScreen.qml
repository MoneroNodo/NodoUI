import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick2QREncode 1.0
import NodoSystem 1.1

Rectangle {
    id: networksClearnetScreen
    property int labelSize: 0
    color: "black"

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
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
            clearnetPortField.valueText = nodoConfig.getIntValueFromKey("config", "difficulty")
            clearnetPeerField.valueText = nodoConfig.getStringValueFromKey("config", "monero_rpc_port")
        }
    }

    NodoInputField {
        id: clearnetAddressField
        anchors.left: networksClearnetScreen.left
        anchors.top: networksClearnetScreen.top
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Address")
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
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
        valueText: nodoConfig.getIntValueFromKey("config", "difficulty")
        textFlag: Qt.ImhDigitsOnly
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
        valueText: nodoConfig.getStringValueFromKey("config", "monero_rpc_port")
        textFlag: Qt.ImhPreferLowercase
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
            qrData: clearnetPeerField.valueText + ":" + clearnetPortField.valueText
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}
