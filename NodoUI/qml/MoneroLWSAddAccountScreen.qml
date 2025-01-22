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
    property int infoFieldSize: width - NodoSystem.subMenuLeftMargin

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroLWSMainAddressInput.labelRectRoundSize > labelSize)
        labelSize = moneroLWSMainAddressInput.labelRectRoundSize

        if(moneroLWSPrivateViewkeyLabel.labelRectRoundSize > labelSize)
        labelSize = moneroLWSPrivateViewkeyLabel.labelRectRoundSize
		
		if(moneroLWSClearnetAddress.labelRectRoundSize > labelSize)
		labelSize = moneroLWSClearnetAddress.labelRectRoundSize
		
		if(moneroLWSTorAddress.labelRectRoundSize > labelSize)
        labelSize = moneroLWSTorAddress.labelRectRoundSize
		
		if(moneroLWSI2PAddress.labelRectRoundSize > labelSize)
		labelSize = moneroLWSI2PAddress.labelRectRoundSize
    }

    Connections {
        target: moneroLWS
        function onAccountAdded() {
            moneroLWSMainAddressInput.valueText = ""
            moneroLWSPrivateViewkeyLabel.valueText = ""
        }
    }

    Text {
        id: moneroLWSTitle
        height: 30
        width: parent.width
        anchors.top: moneroLWSAddAccountScreen.top
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        //anchors.topMargin: NodoSystem.nodoTopMargin*3
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTitleFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("LIGHT WALLET SERVER ADDRESS")
    }
    
    NodoInfoField {
        id: moneroLWSClearnetAddress
        anchors.left: moneroLWSAddAccountScreen.left
		anchors.top: moneroLWSTitle.bottom
		anchors.topMargin: NodoSystem.cardTopMargin
        width: infoFieldSize
        height: NodoSystem.nodoItemHeight
		itemSize: labelSize
		itemText: qsTr("LWS Address")
        valueText: "http://" + networkManager.getNetworkIP() + ":18086/basic"        
	}	
	
	NodoInfoField {
        id: moneroLWSTorAddress
        anchors.left: moneroLWSAddAccountScreen.left
		anchors.top: moneroLWSClearnetAddress.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
	    width: infoFieldSize
        height: NodoSystem.nodoItemHeight
		itemSize: labelSize
		itemText: qsTr("LWS Tor Address")   
        valueText: "http://" + nodoConfig.getStringValueFromKey("config", "tor_address") + ":18086/basic"
        valueFontSize: 38
    }
	
    NodoInfoField {
        id: moneroLWSI2PAddress
        anchors.left: moneroLWSAddAccountScreen.left
		anchors.top: moneroLWSTorAddress.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
	    width: infoFieldSize
        height: NodoSystem.nodoItemHeight
		itemSize: labelSize
		itemText: qsTr("LWS I2P Address") 
        valueText: "http://" + nodoConfig.getStringValueFromKey("config", "i2p_address") + ":18086/basic"
        valueFontSize: 38
    }	

    Text {
        id: moneroLWSDescription
        height: moneroLWSDescription.paintedHeight
        width: parent.width
        anchors.top: moneroLWSI2PAddress.bottom
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        anchors.topMargin: NodoSystem.cardLeftMargin
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("On your Light Wallet, enter a URL as Server Address. If your Light Wallet does not support wallet creation requests, manually add it below.")
    }

    Text {
        id: moneroLWSAddWalletTitle
        height: 30
        width: parent.width
        anchors.top: moneroLWSDescription.bottom
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        anchors.topMargin: NodoSystem.nodoTopMargin*3
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTitleFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("ADD WALLET")
    }

    NodoInputField {
        id: moneroLWSMainAddressInput
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSAddWalletTitle.bottom
        anchors.topMargin: NodoSystem.cardTopMargin
        width: infoFieldSize
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Address]  //LABEL "Address"
        valueText: ""
        height: NodoSystem.nodoItemHeight
        validator: RegularExpressionValidator {
            regularExpression: /^4[0-9A-Za-z]{94}$/
        }
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
        validator: RegularExpressionValidator {
            regularExpression: /^[0-9a-z]{64}$/
        }
    }

    NodoButton {
        id: moneroLWSAddAccountButton
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSPrivateViewkeyLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Add Account")
        height: NodoSystem.nodoItemHeight
        width: labelSize
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: moneroLWSMainAddressInput.valueText.length === 95 ? moneroLWSPrivateViewkeyLabel.valueText.length === 64 ? true : false : false

        onClicked: {
            moneroLWS.addAccount(moneroLWSMainAddressInput.valueText, moneroLWSPrivateViewkeyLabel.valueText)
        }
    }
}
