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
    property int infoFieldWidth: 1200
    property int torPort
    property string torOnionAddress
    property bool torSwitchStatus
    property bool torRouteSwitchStatus
    property bool torPortFieldReadOnly: false

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        var enabled = !nodoControl.isComponentEnabled();
        torPortFieldReadOnly = enabled
    }

    function onCalculateMaximumTextLabelLength() {
        if(torSwitchText.labelRectRoundSize > labelSize)
            labelSize = torSwitchText.labelRectRoundSize

        if(torOnionAddressField.labelRectRoundSize > labelSize)
            labelSize = torOnionAddressField.labelRectRoundSize

        if(torPortField.labelRectRoundSize > labelSize)
            labelSize = torPortField.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            networksTorScreen.torSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
            networksTorScreen.torRouteSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
            networksTorScreen.torOnionAddress = nodoConfig.getStringValueFromKey("config", "tor_address")
            networksTorScreen.torPort = nodoConfig.getIntValueFromKey("config", "tor_port")
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
        itemText: systemMessages.messages[NodoMessages.Message.Port] //qsTr("Port")
        valueText: networksTorScreen.torPort
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: networksTorScreen.torPortFieldReadOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if(torPortField.valueText !== networksTorScreen.torPort.toString())
            {
                torApplyPortButton.isActive = true
            }
        }
    }

    NodoButton {
        id: torApplyPortButton
        anchors.left: networksTorScreen.left
        anchors.top: torPortField.bottom
        anchors.topMargin: 20
        text: systemMessages.messages[NodoMessages.Message.ApplyPort] //qsTr("Apply Port")
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
            qrData: "xmrrpc://:@" + torOnionAddressField.valueText + ":" + torPortField.valueText + "?label=Nodo Tor Node"
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}
