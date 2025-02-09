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

		if(moneroLWSClearnetAddressRect.labelRectRoundSize > labelSize)
		labelSize = moneroLWSClearnetAddressRect.labelRectRoundSize

		if(moneroLWSTorAddressRect.labelRectRoundSize > labelSize)
        labelSize = moneroLWSTorAddressRect.labelRectRoundSize

		if(moneroLWSI2PAddressRect.labelRectRoundSize > labelSize)
		labelSize = moneroLWSI2PAddressRect.labelRectRoundSize
    }

    function walletInfoValid() {
        return syncInfo.getSyncPercentage() == 100
            && moneroLWSMainAddressInput.valueText.length === 95
            && moneroLWSPrivateViewkeyLabel.valueText.length === 64
    }

    Connections {
        target: moneroLWS
        function onAccountAdded() {
            moneroLWSMainAddressInput.valueText = ""
            moneroLWSPrivateViewkeyLabel.valueText = ""
            moneroLWSAddAccountButton.isActive = false
        }
    }

    Connections {
        target: syncInfo
        function onSyncDone() {
            moneroLWSAddAccountButton.isActive = moneroLWSAddAccountScreen.walletInfoValid()
            moneroLWSAddAccountButtonDescription.visible = false
        }
    }

    Connections {
        target: networkManager
        function networkStatusChanged() {

           moneroLWSAddAccountButtonDescription.visible = syncInfo.getSyncPercentage() == 100 && networkManager.getNetworkConnectionStatusCode() == 1
           moneroLWSAddAccountButton.isActive = moneroLWSAddAccountScreen.walletInfoValid()
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

    MouseArea {
        id: moneroLWSClearnetAddressRect
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSTitle.bottom
        anchors.topMargin: NodoSystem.cardTopMargin
        width: infoFieldSize
        height: NodoSystem.nodoItemHeight
        
        NodoInfoField {
            id: moneroLWSClearnetAddress
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 0
            width: parent.width
            height: parent.height
            itemSize: labelSize - 120
            itemText: qsTr("Clearnet")
            valueText: "http://" + networkManager.getNetworkIP() + ":18086/basic"
        }

        onClicked: {
            mainRectPopup.qrCodeData = moneroLWSClearnetAddress.valueText
            mainRectPopup.closeButtonText = qsTr("Close")
            mainRectPopup.open();
        }
    }

    MouseArea {
        id: moneroLWSTorAddressRect
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSClearnetAddressRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldSize
        height: NodoSystem.nodoItemHeight
        
        NodoInfoField {
            id: moneroLWSTorAddress
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 0
            width: parent.width
            height: parent.height
            itemSize: labelSize - 120
            itemText: qsTr("Tor")
            valueText: "http://" + nodoConfig.getStringValueFromKey("config", "tor_address") + ":18086/basic"
            //valueFontSize: 40
        }
        
        onClicked: {
            mainRectPopup.qrCodeData = moneroLWSTorAddress.valueText
            mainRectPopup.closeButtonText = qsTr("Close")
            mainRectPopup.open();
        }
    }

    MouseArea {
        id: moneroLWSI2PAddressRect
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSTorAddressRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldSize
        height: NodoSystem.nodoItemHeight
        
        NodoInfoField {
            id: moneroLWSI2PAddress
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 0
            width: parent.width
            height: parent.height
            itemSize: labelSize - 120
            itemText: qsTr("I2P")
            valueText: "http://" + nodoConfig.getStringValueFromKey("config", "i2p_address") + ":18086/basic"
            //valueFontSize: 40
        }

        onClicked: {
            mainRectPopup.qrCodeData = moneroLWSI2PAddress.valueText
            mainRectPopup.closeButtonText = qsTr("Close")
            mainRectPopup.open();
        }
    }

    Text {
        id: moneroLWSDescription
        height: moneroLWSDescription.paintedHeight
        width: parent.width
        anchors.top: moneroLWSI2PAddressRect.bottom
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
        function editingFinished() {
            moneroLWSAddAccountButton.isActive = moneroLWSAddAccountScreen.walletInfoValid()
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
        function editingFinished() {
            moneroLWSAddAccountButton.isActive = moneroLWSAddAccountScreen.walletInfoValid()
        }
    }

    NodoButton {
        id: moneroLWSAddAccountButton
        anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSPrivateViewkeyLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Add Wallet")
        height: NodoSystem.nodoItemHeight
        width: labelSize
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: moneroLWSAddAccountScreen.walletInfoValid()

        onClicked: {
            moneroLWS.addAccount(moneroLWSMainAddressInput.valueText, moneroLWSPrivateViewkeyLabel.valueText)
        }
    }

    Text {
        id: moneroLWSAddAccountButtonDescription
        height: NodoSystem.nodoItemHeight
        width: parent.width - moneroLWSAddAccountButton.width
        anchors.left: moneroLWSAddAccountButton.right
        anchors.leftMargin: 25
        anchors.top: moneroLWSPrivateViewkeyLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        visible: syncInfo.getSyncPercentage() != 100 || networkManager.getNetworkConnectionStatusCode() != 1
        text: qsTr("Adding wallets is not possible while the Monero Daemon is not synchronized.")
    }

    NodoQRCodePopup {
        id: mainRectPopup
    }
}
