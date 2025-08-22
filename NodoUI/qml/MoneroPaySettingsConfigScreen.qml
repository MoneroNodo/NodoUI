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
    property int infoFieldSize: width - NodoSystem.subMenuLeftMargin
    property bool inputFieldReadOnly: false
    property bool clearButtonActive: false
    property bool setButtonActive: true
    property bool address: false;
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

        function onIsAddressValid(valid) {
            address = valid;
            setButtonActive = valid;
            moneroPaySettingsAddressValidStatusText.text = valid ? "" : "Address is not a valid Monero address.";
        }

        function onComponentEnabledStatusChanged()
        {
            inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }

        function onDepositAddressCleared()
        {
            moneroPaySettingsAddressValidStatusText.text = "";
            moneroPaySettingsAddressInput.valueText = moneroPay.getMoneroPayAddress()
            clearButtonActive = false
            setButtonActive = true
			receiveButton.enabled = false
        }
    }

    Rectangle {
        id: moneroPaySettingsAddressRectangle
        anchors.left: moneroPaySettingsConfigScreen.left
        anchors.top: moneroPaySettingsConfigScreen.top
        height: NodoSystem.nodoItemHeight
        NodoInputField {
            id: moneroPaySettingsAddressInput
            width: infoFieldSize
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Deposit Address")
            readOnlyFlag: inputFieldReadOnly
            valueFontSize: NodoSystem.descriptionTitleFontSize
            validator: RegularExpressionValidator {
                regularExpression: /^4[0-9A-Za-z]{94}$/
            }
            onTextEditFinished: {
                moneroPaySettingsAddressValidStatusText.text = "";
                clearButtonActive = false;
                setButtonActive = false;
                if (moneroPaySettingsAddressInput.valueText.length === 95) {
                    moneroPay.validateAddress(valueText);
                }
            }
        }
    }

    NodoButton {
        id: moneroPaySettingsSetDepositAddressButton
        //anchors.left: moneroPaySettingsAddressInput.left
        anchors.top: moneroPaySettingsAddressRectangle.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Set Address")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: (address && setButtonActive)
        onClicked: {
            if (address) {
                moneroPay.setDepositAddress(moneroPaySettingsAddressInput.valueText)
                inputFieldReadOnly = true;
                clearButtonActive = true
                setButtonActive = false
                moneroPayMainScreen.setButtonState(true)
            }
        }
    }

    NodoButton {
        id: moneroPaySettingsClearAddressButton
        anchors.left: moneroPaySettingsSetDepositAddressButton.right
        anchors.top: moneroPaySettingsAddressRectangle.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
		anchors.leftMargin: 25
        text: qsTr("Clear Address")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: clearButtonActive
        onClicked: {
            moneroPaySettingsScreenPopup.commandID = 0;
            moneroPaySettingsScreenPopup.applyButtonText = qsTr("Reset")
            moneroPaySettingsScreenPopup.open();
            moneroPaySettingsAddressInput.valueText = ""
            moneroPaySettingsViewkeyLabel.valueText = ""
        }
    }

    Text {
        id: moneroPaySettingsAddressDescriptionText
        anchors.left: moneroPaySettingsConfigScreen.left
        anchors.top: moneroPaySettingsSetDepositAddressButton.bottom
        anchors.leftMargin: NodoSystem.cardLeftMargin
        anchors.topMargin: NodoSystem.cardLeftMargin
        width: parent.width
        height: moneroPaySettingsAddressDescriptionText.paintedHeight
        text: qsTr("Received transactions will periodically be sent to this address.")
         verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTitleFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
    }

    Text {
        id: moneroPaySettingsAddressValidStatusText
        anchors.left: moneroPaySettingsConfigScreen.left
        anchors.top: moneroPaySettingsAddressDescriptionText.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: parent.width
        height: moneroPaySettingsAddressValidStatusText.paintedHeight
        text: ""
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        font.family: NodoSystem.fontInter.name
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
