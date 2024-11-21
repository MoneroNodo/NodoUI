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

    property bool isRPCEnabled
    property int port
    property string rpcUser
    property string rpcPassword

    function updateParams()
    {
        var rpcStat = nodoControl.getrpcEnabledStatus()
        var rpcu = nodoControl.getrpcUser()
        var rpcp = nodoControl.getrpcPassword()
        networksTorScreen.port = nodoControl.gettorPort()

        if((rpcu === "") || (rpcp === ""))
        {
            rpcStat = false
        }

        networksTorScreen.isRPCEnabled = rpcStat
        networksTorScreen.rpcUser = rpcu
        networksTorScreen.rpcPassword = rpcp
    }

    function createAddress()
    {
        var uri = "xmrrpc://" + networksTorScreen.rpcUser + ":" + networksTorScreen.rpcPassword + "@" + torOnionAddressField.valueText + ":" + networksTorScreen.port.toString() + "?label=Nodo Tor Node"
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
            networksTorScreen.torSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
            networksTorScreen.torRouteSwitchStatus = nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
            networksTorScreen.torOnionAddress = nodoConfig.getStringValueFromKey("config", "tor_address")
            networksTorScreen.torPort = nodoConfig.getIntValueFromKey("config", "tor_port")

            updateParams()
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(0 !== errorCode)
            {
                networksTorPopup.popupMessageText = systemMessages.backendMessages[errorCode]
                networksTorPopup.commandID = -1;
                networksTorPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                networksTorPopup.open();
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
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Onion Address")
        valueText: networksTorScreen.torOnionAddress
        valueFontSize: 28
    }

    NodoInfoField {
        id: torPortField
        anchors.left: networksTorScreen.left
        anchors.top: torOnionAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Port]
        valueText: networksTorScreen.torPort
    }

    Rectangle{
        id: qrCodeRect
        anchors.right: networksTorScreen.right
        anchors.top: networksTorScreen.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.rightMargin: 8
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
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }

    NodoPopup {
        id: networksTorPopup
        onApplyClicked: {
            close()
        }
    }
}
