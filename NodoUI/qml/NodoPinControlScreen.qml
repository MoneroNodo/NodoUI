import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: devicePinScreen
    property int labelSize: 0
    property int inputFieldWidth: 600
    property int defaultHeight: 64
    property bool pinFieldReadOnly: false
    property bool isPinEnabled: false

    signal pinCodeCorrect()

    Component.onCompleted: {
        isPinEnabled = nodoControl.isPinEnabled()
        onCalculateMaximumTextLabelLength()
        deviceSystemPinSwitch.checked = isPinEnabled
        pinControlLockAfterField.valueText = nodoControl.getLockAfterTime()

        if(isPinEnabled)
        {
            devicePinScreen.state = "pinControlEnabled"
        }
        else
        {
            devicePinScreen.state = ""
        }
    }

    function onCalculateMaximumTextLabelLength() {
        if(pinControlLockAfterField.labelRectRoundSize > labelSize)
            labelSize = pinControlLockAfterField.labelRectRoundSize

        if(pinControlNewPinField.labelRectRoundSize > labelSize)
            labelSize = pinControlNewPinField.labelRectRoundSize

        if(pinControlReEnterNewPinField.labelRectRoundSize > labelSize)
            labelSize = pinControlReEnterNewPinField.labelRectRoundSize
    }

    function setButtonStatus(){
        if((pinControlNewPinField.valueText.length === 6) && (pinControlReEnterNewPinField.valueText.length === 6))
        {
            pinControlSetNewPin.isActive = true
        }
        else
        {
            pinControlSetNewPin.isActive = false
        }
    }

    Rectangle {
        id: deviceSystemPinSwitchRect
        anchors.left: devicePinScreen.left
        anchors.top: devicePinScreen.top
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: deviceSystemPinSwitchText
            height: deviceSystemPinSwitchRect.height
            anchors.left: deviceSystemPinSwitchRect.left
            anchors.top: deviceSystemPinSwitchRect.top
            text: qsTr("Lock with PIN")
        }

        NodoSwitch {
            id: deviceSystemPinSwitch
            anchors.left: deviceSystemPinSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceSystemPinSwitchText.height
            width: 2*deviceSystemPinSwitchText.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                if(!checked)
                {
                    nodoControl.disablePin()
                    devicePinScreen.state = ""
                    isPinEnabled = nodoControl.isPinEnabled()
                }
                else
                {
                    devicePinScreen.state = "pinControlEnabled"
                }
            }
        }
    }

    Rectangle {
        id: pinControlRect
        anchors.left: devicePinScreen.left
        anchors.right: devicePinScreen.right
        anchors.top: deviceSystemPinSwitchRect.bottom
        height: pinControlSetNewPin.height + pinControlSetNewPin.y
        anchors.topMargin: 20
        color: "black"
        visible:  devicePinScreen.state === "pinControlEnabled" ? true : false

        NodoInputField {
            id: pinControlLockAfterField
            anchors.left: pinControlRect.left
            anchors.top: pinControlRect.top
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Lock after")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{bottom: 1}
            onTextEditFinished: {
                nodoControl.setLockAfterTime(pinControlLockAfterField.valueText)
            }
        }

        Rectangle {
            id: pinControlLockAfterTimeRect
            anchors.left: pinControlLockAfterField.right
            anchors.top: pinControlLockAfterField.top
            anchors.leftMargin: 8
            color: "black"

            Text {
                id: pinControlLockAfterTimeUnit
                text: qsTr("minutes")
                anchors.left: pinControlLockAfterTimeRect.right
                height: NodoSystem.infoFieldLabelHeight
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.inputFieldValueFontSize
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
            }
        }

        NodoInputField {
            id: pinControlNewPinField
            anchors.left: pinControlRect.left
            anchors.top: pinControlLockAfterField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("New PIN")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{top: 999999}
            valueText: ""
            readOnlyFlag: pinFieldReadOnly
            onTextEditFinished: {
                setButtonStatus()
            }
        }

        NodoInputField {
            id: pinControlReEnterNewPinField
            anchors.left: pinControlRect.left
            anchors.top: pinControlNewPinField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Re-enter New PIN")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{top: 999999}
            valueText: ""
            readOnlyFlag: pinFieldReadOnly
            onTextEditFinished: {
                setButtonStatus()
            }
        }

        NodoButton {
            id: pinControlSetNewPin
            anchors.left: pinControlRect.left
            anchors.top: pinControlReEnterNewPinField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: qsTr("Change PIN")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: false
            onClicked: {
                pinControlSetNewPin.isActive = false
                pinFieldReadOnly = true
                var newPin = pinControlNewPinField.valueText
                var newPin2 = pinControlReEnterNewPinField.valueText

                if(newPin === newPin2)
                {
                    nodoControl.setPin(newPin);
                }
                else
                {
                    systemPopup.commandID = -1;
                    systemPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.PINCodesAreDifferent]
                    systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                    systemPopup.open();
                }


                pinControlNewPinField.valueText = ""
                pinControlReEnterNewPinField.valueText = ""
                pinFieldReadOnly = false
            }
        }
    }
}

