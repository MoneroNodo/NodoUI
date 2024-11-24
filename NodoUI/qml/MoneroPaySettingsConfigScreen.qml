import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroPaySettingsConfigScreen

    property int labelSize: 0
    property int buttonWidth: 0
    property int infoFieldSize: 1900
    property bool inputFieldReadOnly: false
    property bool clearButtonActive: false
    property bool setButtonActive: false
    signal deleteMe(int screenID)


    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()

        moneroPaySettingsAddressInput.valueText = moneroPay.getMoneroPayAddress()
        moneroPaySettingsViewkeyLabel.valueText = moneroPay.getMoneroPayViewKey()


        if((moneroPaySettingsAddressInput.valueText.length === 95) && (moneroPaySettingsViewkeyLabel.valueText.length === 64))
        {
            inputFieldReadOnly = true;
            setButtonActive = false
            clearButtonActive = true
            moneroPay.depositAddressSet()
        }
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroPaySettingsAddressInput.labelRectRoundSize > labelSize)
            labelSize = moneroPaySettingsAddressInput.labelRectRoundSize

        if(moneroPaySettingsViewkeyLabel.labelRectRoundSize > labelSize)
            labelSize = moneroPaySettingsViewkeyLabel.labelRectRoundSize

        if(moneroPaySettingsSetDepositAddressButton.width > buttonWidth)
            buttonWidth = moneroPaySettingsSetDepositAddressButton.width

        if(moneroPaySettingsClearAddressButton.width > buttonWidth)
            buttonWidth = moneroPaySettingsClearAddressButton.width

        moneroPaySettingsSetDepositAddressButton.width = buttonWidth
        moneroPaySettingsClearAddressButton.width = buttonWidth
    }

    Connections {
        target: moneroPay

        function onComponentEnabledStatusChanged()
        {
            inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }

        function onDepositAddressCleared()
        {
            moneroPaySettingsAddressInput.valueText = moneroPay.getMoneroPayAddress()
            moneroPaySettingsViewkeyLabel.valueText = moneroPay.getMoneroPayViewKey()
            clearButtonActive = false
            setButtonActive = true
			receiveButton.enabled = false
        }
    }

    NodoInputField {
        id: moneroPaySettingsAddressInput
        anchors.left: moneroPaySettingsConfigScreen.left
        anchors.top: moneroPaySettingsConfigScreen.top
        width: infoFieldSize
        itemSize: labelSize
        itemText: qsTr("Deposit Address")
        readOnlyFlag: inputFieldReadOnly
        height: NodoSystem.nodoItemHeight
    }

    NodoInputField {
        id: moneroPaySettingsViewkeyLabel
        anchors.left: moneroPaySettingsAddressInput.left
        anchors.top: moneroPaySettingsAddressInput.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldSize
        itemSize: labelSize
        itemText: qsTr("Private Viewkey")
        readOnlyFlag: inputFieldReadOnly
        height: NodoSystem.nodoItemHeight
    }

    NodoButton {
        id: moneroPaySettingsSetDepositAddressButton
        anchors.left: moneroPaySettingsAddressInput.left
        anchors.top: moneroPaySettingsViewkeyLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Set Deposit Address")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: (setButtonActive === true) && (moneroPaySettingsAddressInput.valueText.length === 95) && (moneroPaySettingsViewkeyLabel.valueText.length === 64)
        onClicked: {
            moneroPay.setDepositAddress(moneroPaySettingsAddressInput.valueText, moneroPaySettingsViewkeyLabel.valueText)
            nodoControl.serviceManager("restart", "moneropay");
            inputFieldReadOnly = true;
            clearButtonActive = true
            setButtonActive = false
            moneroPayMainScreen.setButtonState(true)
        }
    }

    NodoButton {
        id: moneroPaySettingsClearAddressButton
        anchors.left: moneroPaySettingsSetDepositAddressButton.right
        anchors.top: moneroPaySettingsViewkeyLabel.bottom
		anchors.leftMargin: 25
        text: qsTr("Clear Deposit Address")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: clearButtonActive
        onClicked: {
            moneroPaySettingsScreenPopup.commandID = 0;
            moneroPaySettingsScreenPopup.applyButtonText = qsTr("Clear")
            moneroPaySettingsScreenPopup.open();
        }
    }

    NodoPopup {
        id: moneroPaySettingsScreenPopup
        onApplyClicked: {
            if(commandID === 0)
            {
				inputFieldReadOnly = false; //test
                moneroPay.setDepositAddress("", "");
				clearButtonActive = false
                nodoControl.serviceManager("restart", "moneropay");
            }
            close()
        }
    }
}
