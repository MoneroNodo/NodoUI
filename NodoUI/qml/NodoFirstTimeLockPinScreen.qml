import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: lockPinScreen
    anchors.leftMargin: 20

    property int labelSize: 0
    property int inputFieldWidth: 700
    property bool inputFieldReadOnly: false
    signal openNextScreen(int screenID)

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(lockPINField.labelRectRoundSize > labelSize)
            labelSize = lockPINField.labelRectRoundSize

        if(lockPINReenterField.labelRectRoundSize > labelSize)
            labelSize = lockPINReenterField.labelRectRoundSize

        if(lockPinApplyButton.labelRectRoundSize > labelSize)
            labelSize = lockPinApplyButton.labelRectRoundSize
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(errorCode === 9)
            {
                openNextScreen(2)
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
        id: lockPinRect
        anchors.fill: parent
        color: "black"
        anchors.leftMargin: 20

        Rectangle {
            id: banner
            anchors.top: lockPinRect.top
            anchors.left: lockPinRect.left
            anchors.right: lockPinRect.right
            anchors.topMargin: NodoSystem.nodoTopMargin
            height: banner.paintedHeight
            color: "black"
            Text {
                text: qsTr("Please set your 6 digit Lock PIN.\nThe Lock PIN is used to unlock the device.\nIt can be changed later on DEVICE > SYSTEM > PIN Settings.")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.textFontSize
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                width: banner.width
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            }
        }

        NodoInputField {
            id: lockPINField
            anchors.left: lockPinRect.left
            anchors.top: banner.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("New Lock PIN")
            valueText: ""
            passwordInput: true
            readOnlyFlag: lockPinScreen.inputFieldReadOnly
            textFlag: Qt.ImhDigitsOnly
            validator: RegularExpressionValidator {
                regularExpression: /(\d{6})?$/
            }
        }

        NodoInputField {
            id: lockPINReenterField
            anchors.left: lockPinRect.left
            anchors.top: lockPINField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Re-enter Lock PIN")
            valueText: ""
            passwordInput: true
            readOnlyFlag: lockPinScreen.inputFieldReadOnly
            textFlag: Qt.ImhDigitsOnly
            validator: RegularExpressionValidator {
                regularExpression: /(\d{6})?$/
            }
        }


        NodoButton {
            id: lockPinApplyButton
            anchors.left: lockPinRect.left
            anchors.top: lockPINReenterField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: systemMessages.messages[NodoMessages.Message.Apply]
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: (lockPINField.valueText.length >= 6) && (lockPINReenterField.valueText === lockPINField.valueText) ? true : false
            onClicked: {
                isActive = false
                lockPinScreen.inputFieldReadOnly = true
                nodoControl.setLockPin(lockPINField.valueText);
            }
        }

        NodoPopup {
            id: lockPinScreenPopup
            onApplyClicked: {
                close()
            }
        }
    }
}
