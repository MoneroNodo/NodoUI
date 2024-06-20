import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: networksTorScreen
    property int labelSize: 0
    property int infoFieldWidth: 1000
    property int torPort
    property string torPeer
    property string torOnionAddress
    property bool torSwitchStatus
    property bool torRouteSwitchStatus
    property bool torPortFieldReadOnly: false
    property bool torPeerFieldReadOnly: false

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        var enabled = !nodoControl.isComponentEnabled();
        torPortFieldReadOnly = enabled
        torPeerFieldReadOnly = enabled
    }

    function onCalculateMaximumTextLabelLength() {
        if(torSwitchText.labelRectRoundSize > labelSize)
            labelSize = torSwitchText.labelRectRoundSize

        if(torOnionAddressField.labelRectRoundSize > labelSize)
            labelSize = torOnionAddressField.labelRectRoundSize

        if(torPortField.labelRectRoundSize > labelSize)
            labelSize = torPortField.labelRectRoundSize

        if(torPeerField.labelRectRoundSize > labelSize)
            labelSize = torPeerField.labelRectRoundSize

        if(torRouteSwitchText.labelRectRoundSize > labelSize)
            labelSize = torRouteSwitchText.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            networksTorScreen.torSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
            networksTorScreen.torRouteSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
            networksTorScreen.torOnionAddress = nodoConfig.getStringValueFromKey("config", "tor_address")
            networksTorScreen.torPort = nodoConfig.getIntValueFromKey("config", "tor_port")
            networksTorScreen.torPeer = nodoConfig.getStringValueFromKey("config", "add_tor_peer")
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(0 !== errorCode)
            {
                systemPopup.popupMessageText = nodoControl.getErrorMessage()
                systemPopup.commandID = -1;
                systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                systemPopup.open();
            }
        }

        function onComponentEnabledStatusChanged() {
            var enabled = !nodoControl.isComponentEnabled();
            torPortFieldReadOnly = enabled
            torPeerFieldReadOnly = enabled
        }
    }


    Rectangle {
        id: torSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: networksTorScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: torSwitchText
            height: torSwitchRect.height
            anchors.left: torSwitchRect.left
            anchors.top: torSwitchRect.top
            itemSize: labelSize
            text: qsTr("Tor")
        }

        NodoSwitch {
            id: torSwitch
            anchors.left: torSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: torSwitchRect.height
            width: 2*torSwitchRect.height
            display: AbstractButton.IconOnly
            checked: networksTorScreen.torSwitchStatus
        }
    }

    Rectangle {
        id: torRouteSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: torSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: torRouteSwitchText
            height: torRouteSwitchRect.height
            anchors.left: torRouteSwitchRect.left
            anchors.top: torRouteSwitchRect.top
            itemSize: labelSize
            text: qsTr("Route all connections through Tor")
        }

        NodoSwitch {
            id: torRouteSwitch
            anchors.left: torRouteSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: torRouteSwitchRect.height
            width: 2*torRouteSwitchRect.height
            display: AbstractButton.IconOnly
            checked: networksTorScreen.torRouteSwitchStatus
        }
    }

    NodoInfoField {
        id: torOnionAddressField
        anchors.left: networksTorScreen.left
        anchors.top: torRouteSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Onion Address")
        valueText: networksTorScreen.torOnionAddress
    }

    NodoInputField {
        id: torPortField
        anchors.left: networksTorScreen.left
        anchors.top: torOnionAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Port")
        valueText: networksTorScreen.torPort
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: networksTorScreen.torPortFieldReadOnly
        onTextEditFinished: {
            if(torPortField.valueText !== networksTorScreen.torPort.toString())
            {
                torApplyPortButton.isActive = true
            }
        }
    }

    NodoInputField {
        id: torPeerField
        anchors.left: networksTorScreen.left
        anchors.top: torPortField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: networksTorScreen.torPeer
        readOnlyFlag: networksTorScreen.torPeerFieldReadOnly
        onTextEditFinished: {
            if(torPeerField.valueText !== networksTorScreen.torPeer)
            {
                torAddPeerButton.isActive = true
            }
        }
    }

    NodoButton {
        id: torApplyPortButton
        anchors.left: networksTorScreen.left
        anchors.top: torPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Apply Port")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setTorPort(torPortField.valueText)
        }
    }

    NodoButton {
        id: torAddPeerButton
        anchors.left: networksTorScreen.left
        anchors.top: torApplyPortButton.bottom
        anchors.topMargin: 20
        text: qsTr("Set Peer")
        height: 64
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setTorPeer(torPeerField.valueText)
        }
    }

    Rectangle{
        id: qrCodeRect
        anchors.right: networksTorScreen.right
        anchors.top: networksTorScreen.top
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
            qrData: torOnionAddressField.valueText + ":" + torPortField.valueText
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}

