import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: addressPinScreen
    anchors.leftMargin: 20

    property int labelSize: 0
    property int inputFieldWidth: 700
    property bool inputFieldReadOnly: false
    signal openNextScreen(int screenID)

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(addressPINField.labelRectRoundSize > labelSize)
            labelSize = addressPINField.labelRectRoundSize

        if(addressPINReenterField.labelRectRoundSize > labelSize)
            labelSize = addressPINReenterField.labelRectRoundSize

        if(addressPinApplyButton.labelRectRoundSize > labelSize)
            labelSize = addressPinApplyButton.labelRectRoundSize
    }

    Connections {
        target: nodoControl

        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(errorCode === 9)
            {
                openNextScreen(3)
            }
            else
            {
                lockPinScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.FailedToChangePassword]
                lockPinScreenPopup.commandID = -1;
                lockPinScreenPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                lockPinScreenPopup.open();
            }
            inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }
    }

    Rectangle {
        id: addressPinRect
        anchors.fill: parent
        color: "black"
        anchors.leftMargin: 20

        Rectangle {
            id: banner
            anchors.top: addressPinRect.top
            anchors.left: addressPinRect.left
            anchors.right: addressPinRect.right
            height: 180
            color: "black"
            Text {
                text: qsTr("Please set your 6 digit Address PIN.\nThe Address PIN is used to change or remove the Monero Deposit Address for Miner and MoneroPay.\nIt can be changed later on DEVICE->PIN")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.textFontSize
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                width: banner.width
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            }
        }

        NodoInputField {
            id: addressPINField
            anchors.left: addressPinRect.left
            anchors.top: banner.bottom
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Set Address PIN")
            valueText: ""
            passwordInput: true
            readOnlyFlag: addressPinScreen.inputFieldReadOnly
            textFlag: Qt.ImhDigitsOnly
            validator: RegularExpressionValidator {
                regularExpression: /(\d{6})?$/
            }
        }

        NodoInputField {
            id: addressPINReenterField
            anchors.left: addressPinRect.left
            anchors.top: addressPINField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Re-enter Address PIN")
            valueText: ""
            passwordInput: true
            readOnlyFlag: addressPinScreen.inputFieldReadOnly
            textFlag: Qt.ImhDigitsOnly
            validator: RegularExpressionValidator {
                regularExpression: /(\d{6})?$/
            }
        }


        NodoButton {
            id: addressPinApplyButton
            anchors.left: addressPinRect.left
            anchors.top: addressPINReenterField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: systemMessages.messages[NodoMessages.Message.Apply]
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: (addressPINField.valueText.length >= 6) && (addressPINReenterField.valueText === addressPINField.valueText) ? true : false
            onClicked: {
                isActive = false
                addressPinScreen.inputFieldReadOnly = true
                nodoControl.setAddressPin(addressPINField.valueText);
            }
        }

        NodoPopup {
            id: addressPinScreenPopup
            onApplyClicked: {
                close()
            }
        }
    }
}
