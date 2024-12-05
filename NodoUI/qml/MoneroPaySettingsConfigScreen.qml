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
    property int infoFieldSize: 1880
    property bool inputFieldReadOnly: false
    property bool clearButtonActive: false
    property bool setButtonActive: true
    signal deleteMe(int screenID)


    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()

        moneroPaySettingsAddressInput.valueText = moneroPay.getMoneroPayAddress()


        if(moneroPaySettingsAddressInput.valueText.length === 95)
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
        valueFontSize: 26
        validator: RegularExpressionValidator {
            regularExpression: /^4[1-9A-HJ-NP-Za-km-z]{94}$/
        }
    }

    NodoButton {
        id: moneroPaySettingsSetDepositAddressButton
        anchors.left: moneroPaySettingsAddressInput.left
        anchors.top: moneroPaySettingsAddressInput.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Set Deposit Address")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: (setButtonActive === true) && (moneroPaySettingsAddressInput.valueText.length === 95) && (moneroPaySettingsViewkeyLabel.valueText.length === 64)
        isActive: false
        onClicked: {
            moneroPay.setDepositAddress(moneroPaySettingsAddressInput.valueText)
            inputFieldReadOnly = true;
            clearButtonActive = true
            setButtonActive = false
            moneroPayMainScreen.setButtonState(true)
        }
    }
    NodoLabel {
        id: moneroPayDisabledWarningLabel
        height: 94
        anchors.left: moneroPaySettingsSetDepositAddressButton.left
        anchors.top: moneroPaySettingsSetDepositAddressButton.bottom
        itemSize: 0
        text: qsTr("Due to recent changes, MoneroPay functionality is currently undergoing a revamp.")
    }

    NodoButton {
        id: moneroPaySettingsClearAddressButton
        anchors.left: moneroPaySettingsSetDepositAddressButton.right
        anchors.top: moneroPaySettingsViewkeyLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
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
            moneroPaySettingsAddressInput.valueText = ""
            moneroPaySettingsViewkeyLabel.valueText = ""
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
