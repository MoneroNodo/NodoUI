import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: addressPinControlScreen
    property int labelSize: 0
    property int inputFieldWidth: 600
    property int defaultHeight: 64
    property bool pinFieldReadOnly: false
    property bool isLockPinEnabled: false

    signal deleteMe(int screenID)

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(addressPinControlNewPinField.labelRectRoundSize > labelSize)
            labelSize = addressPinControlNewPinField.labelRectRoundSize

        if(addressPinControlReEnterNewPinField.labelRectRoundSize > labelSize)
            labelSize = addressPinControlReEnterNewPinField.labelRectRoundSize
    }

    function setButtonStatus(){
        if((addressPinControlNewPinField.valueText.length === 6) && (addressPinControlReEnterNewPinField.valueText.length === 6))
        {
            addressPinControlSetNewPin.isActive = true
        }
        else
        {
            addressPinControlSetNewPin.isActive = false
        }
    }

    NodoInputField {
        id: addressPinControlNewPinField
        anchors.left: addressPinControlScreen.left
        anchors.top: addressPinControlScreen.top
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("New Address PIN")
        textFlag: Qt.ImhDigitsOnly
        validator: IntValidator{top: 999999}
        valueText: ""
        readOnlyFlag: pinFieldReadOnly
        onTextEditFinished: {
            setButtonStatus()
        }
    }

    NodoInputField {
        id: addressPinControlReEnterNewPinField
        anchors.left: addressPinControlScreen.left
        anchors.top: addressPinControlNewPinField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Re-enter New Address PIN")
        textFlag: Qt.ImhDigitsOnly
        validator: IntValidator{top: 999999}
        valueText: ""
        readOnlyFlag: pinFieldReadOnly
        onTextEditFinished: {
            setButtonStatus()
        }
    }

    NodoButton {
        id: addressPinControlSetNewPin
        anchors.left: addressPinControlScreen.left
        anchors.top: addressPinControlReEnterNewPinField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Change PIN")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked: {
            addressPinControlSetNewPin.isActive = false
            pinFieldReadOnly = true
            var newPin = addressPinControlNewPinField.valueText
            var newPin2 = addressPinControlReEnterNewPinField.valueText

            if(newPin === newPin2)
            {
                nodoControl.setAddressPin(newPin);
            }
            else
            {
                nodoAddressPinControlPopup.commandID = -1;
                nodoAddressPinControlPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.PINCodesAreDifferent]
                nodoAddressPinControlPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                nodoAddressPinControlPopup.open();
            }


            addressPinControlNewPinField.valueText = ""
            addressPinControlReEnterNewPinField.valueText = ""
            pinFieldReadOnly = false
        }
    }

    NodoPopup {
        id: nodoAddressPinControlPopup
        onApplyClicked: {
            close()
        }
    }
}

