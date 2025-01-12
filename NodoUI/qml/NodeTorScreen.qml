import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: nodeTorScreen
    property int labelSize: 0
    property int infoFieldWidth: 1350
    property int torPort
    property string torOnionAddress
    property bool torSwitchStatus
    property bool torRouteSwitchStatus
    property bool torPortFieldReadOnly: false

    property bool isRPCEnabled
    property int port
    property string rpcUser
    property string rpcPassword

    function updateParams()
    {
        var rpcStat = nodoControl.getrpcEnabledStatus()
        var rpcu = nodoControl.getrpcUser()
        var rpcp = nodoControl.getrpcPassword()
        nodeTorScreen.port = nodoControl.getrpcPort()

        if((rpcu === "") || (rpcp === ""))
        {
            rpcStat = false
        }

        nodeTorScreen.isRPCEnabled = rpcStat
        nodeTorScreen.rpcUser = rpcu
        nodeTorScreen.rpcPassword = rpcp
    }

    function createAddress()
    {
        var uri = "xmrrpc://" + nodeTorScreen.rpcUser + ":" + nodeTorScreen.rpcPassword + "@" + torOnionAddressField.valueText + ":" + nodeTorScreen.port.toString() + "?label=Nodo Tor Node"
        return uri
    }

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
            nodeTorScreen.torSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
            nodeTorScreen.torRouteSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
            nodeTorScreen.torOnionAddress = nodoConfig.getStringValueFromKey("config", "tor_address")
            nodeTorScreen.torPort = nodoConfig.getIntValueFromKey("config", "monero_rpc_port")

            updateParams()
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(0 !== errorCode)
            {
                nodeTorPopup.popupMessageText = systemMessages.backendMessages[errorCode]
                nodeTorPopup.commandID = -1;
                nodeTorPopup.open();
            }
        }

        function onComponentEnabledStatusChanged() {
            var enabled = !nodoControl.isComponentEnabled();
            torPortFieldReadOnly = enabled
        }
    }

    Rectangle {
        id: torSwitchRect
        anchors.left: nodeTorScreen.left
        anchors.top: nodeTorScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel {
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
            checked: nodeTorScreen.torSwitchStatus
        }
    }

    Rectangle {
        id: torRouteSwitchRect
        anchors.left: nodeTorScreen.left
        anchors.top: torSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
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
            checked: nodeTorScreen.torRouteSwitchStatus
        }
    }

    NodoInfoField {
        id: torOnionAddressField
        anchors.left: nodeTorScreen.left
        anchors.top: torRouteSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Onion Address")
        valueText: nodeTorScreen.torOnionAddress
        valueFontSize: 34
    }

    NodoInfoField {
        id: torPortField
        anchors.left: nodeTorScreen.left
        anchors.top: torOnionAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Port] //qstr("Port")
        valueText: nodeTorScreen.torPort
    }

    Rectangle {
        id: qrCodeRect
        anchors.right: nodeTorScreen.right
        anchors.top: nodeTorScreen.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.rightMargin: 10
        color: "black"
        width: 512
        height: 512

        QtQuick2QREncode {
            id: qr
            width: qrCodeRect.width
            height: qrCodeRect.height
            qrSize: Qt.size(width,width)
            qrData: createAddress()
            qrForeground: "black"
            qrBackground: "#F2F2F7"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }

    NodoPopup {
        id: nodeTorPopup
        onApplyClicked: {
            close()
        }
    }
}
