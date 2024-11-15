import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroLWSAddAccountScreen
	anchors.fill: parent
    property int labelSize: 0
    property int infoFieldSize: 1850

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroLWSMainAddressInput.labelRectRoundSize > labelSize)
        labelSize = moneroLWSMainAddressInput.labelRectRoundSize

        if(moneroLWSPrivateViewkeyLabel.labelRectRoundSize > labelSize)
        labelSize = moneroLWSPrivateViewkeyLabel.labelRectRoundSize
    }

    Connections {
        target: moneroLWS
        function onAccountAdded() {
            moneroLWSMainAddressInput.valueText = ""
            moneroLWSPrivateViewkeyLabel.valueText = ""
        }
    }

    NodoInputField {
        id: moneroLWSMainAddressInput
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSAddAccountScreen.top
        width: infoFieldSize
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Address]
        valueText: ""
        height: NodoSystem.nodoItemHeight
    }

    NodoInputField {
        id: moneroLWSPrivateViewkeyLabel
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSMainAddressInput.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldSize
        itemSize: labelSize
        itemText: qsTr("Private Viewkey")
        valueText: ""
        height: NodoSystem.nodoItemHeight
    }

    NodoButton {
        id: moneroLWSAddAccountButton
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSPrivateViewkeyLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Add Account")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: moneroLWSMainAddressInput.valueText.length === 95 ? moneroLWSPrivateViewkeyLabel.valueText.length === 64 ? true : false : false

        onClicked: {
            moneroLWS.addAccount(moneroLWSMainAddressInput.valueText, moneroLWSPrivateViewkeyLabel.valueText)
        }
    }
		Label {
			id: connectionStringLabel
			anchors.left: moneroLWSAddAccountScreen.left
			anchors.bottom: moneroLWSAddAccountScreen.bottom
			width: feedAuth.paintedWidth
			height: 22
			text: "http://" + networkManager.getNetworkIP() + ":8133/basic\n"
			    + "http://" + nodoConfig.getStringValueFromKey("config", "tor_address") + ":8133/basic\n"
			    + "http://" + nodoConfig.getStringValueFromKey("config", "i2p_b32_addr_lws") + ":8133/basic"
			color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : "white"
			font.family: NodoSystem.fontUrbanist.name
			font.pixelSize: 32
		}
}


