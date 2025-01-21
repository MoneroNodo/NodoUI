import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceSSHScreen
    anchors.fill: parent
    property int labelSize: 0
    property int inputFieldWidth: 900
    property bool inputFieldReadOnly: false
    property bool isPasswordValid: false
    property string oldPassword

    // Component.onCompleted: {
    //     onCalculateMaximumTextLabelLength()
    // }

    function checkPasswordValidity(password1, password2)
    {
        var errorMessage = ""
        if(false === nodoControl.isPasswordValid(password1))
        {
            errorMessage = systemMessages.backendMessages[NodoMessages.BackendMessages.PasswordDoesntMeetRequirements]
        }

        if((0 !== password2.length) && (password1 !== password2))
        {
            if(0 !== errorMessage.length)
            {
                errorMessage = errorMessage + "\n"
            }
            errorMessage = errorMessage + systemMessages.backendMessages[NodoMessages.BackendMessages.PasswordsDontMatch]
        }

        return errorMessage
    }


    function showPasswordCheckError(password1, password2)
    {
        passwordWarningText.text = ""
        passwordWarningRect.visible = false

        var errorString = checkPasswordValidity(password1, password2) //nodoControl.checkPasswordValidity(password1, password2)

        if(errorString !== "")
        {
            passwordWarningText.text = errorString
            passwordWarningRect.visible = true
        }
        else
        {
            deviceSSHScreen.isPasswordValid = true;
        }
    }
/*
    function onCalculateMaximumTextLabelLength() {
        if(deviceSSHOldPasswordField.labelRectRoundSize > labelSize)
            labelSize = deviceSSHOldPasswordField.labelRectRoundSize

        if(deviceSSHSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceSSHSwitchText.labelRectRoundSize

        if(deviceSSHUserNameField.labelRectRoundSize > labelSize)
            labelSize = deviceSSHUserNameField.labelRectRoundSize

        if(deviceSSHPasswordField.labelRectRoundSize > labelSize)
            labelSize = deviceSSHPasswordField.labelRectRoundSize

        if(deviceSSHReenterPasswordField.labelRectRoundSize > labelSize)
            labelSize = deviceSSHReenterPasswordField.labelRectRoundSize
    }
*/
    Connections {
        target: nodoControl

        function onPasswordChangeStatus(status) {
            deviceSSHOldPasswordField.valueText = ""
            deviceSSHPasswordField.valueText = ""
            deviceSSHReenterPasswordField.valueText = ""
            if(0 === status)
            {
                deviceSSHScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.PasswordChangedSuccessfully]
            }
            else if(-1 === status)
            {
                deviceSSHScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.FailedToChangePassword]
            }
            else if(-2 === status)
            {
                deviceSSHScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.OldPasswordIsWrong]
            }

            deviceSSHScreenPopup.commandID = -1;
            deviceSSHScreenPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            deviceSSHScreenPopup.open();

            deviceSSHScreen.isPasswordValid = false;
            deviceSSHScreen.inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }
    }

    Rectangle {
        id: deviceSSHSwitchRect
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceSSHSwitchText
            height: deviceSSHSwitchRect.height
            anchors.left: deviceSSHSwitchRect.left
            anchors.top: deviceSSHSwitchRect.top
            // itemSize: labelSize
            text: qsTr("SSH")
        }

        NodoSwitch {
            id: deviceSSHSwitchRectSwitch
            anchors.left: deviceSSHSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceSSHSwitchRect.height
            width: 2*deviceSSHSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoControl.getServiceStatus("sshd") === "active" ? true : false
            checkable: !deviceSSHScreen.inputFieldReadOnly
            onCheckedChanged: {
                if(checked)
                {
                    nodoControl.serviceManager("start", "sshd");
                }
                else
                {
                    nodoControl.serviceManager("stop", "sshd");
                }
            }
        }
    }

    NodoInfoField {
        id: deviceSSHUserNameField
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize + deviceSSHSwitchRectSwitch.width
        itemSize: labelSize
        height: NodoSystem.nodoItemHeight
        itemText: qsTr("Username")
        valueText: "nodo"
    }

    Text {
        id: changeAdminPasswordTitle
        height: NodoSystem.nodoItemHeight
        width: parent.width
        anchors.top: deviceSSHUserNameField.bottom
        anchors.left: deviceSSHScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin*2
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTitleFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("CHANGE ADMIN PASSWORD")
    }

    NodoInputField {
        id: deviceSSHOldPasswordField
        anchors.left: deviceSSHScreen.left
        anchors.top: changeAdminPasswordTitle.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Old Password")
        valueText: ""
        readOnlyFlag: deviceSSHScreen.inputFieldReadOnly
        passwordInput: true
        onTextEditFinished: {
            oldPassword = valueText
        }
    }


    NodoInputField {
        id: deviceSSHPasswordField
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHOldPasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("New Password")
        valueText: ""
        readOnlyFlag: deviceSSHScreen.inputFieldReadOnly
        passwordInput: true
        onTextEditFinished: {
            showPasswordCheckError(deviceSSHPasswordField.valueText, deviceSSHReenterPasswordField.valueText)
        }
    }

    Rectangle {
        id: passwordWarningRect
        anchors.top: deviceSSHPasswordField.top
        anchors.left: deviceSSHPasswordField.right
        anchors.right: deviceSSHScreen.right
        anchors.leftMargin: 25

        height: NodoSystem.nodoItemHeight
        color: "black"
        visible: false
        Text {
            id: passwordWarningText
            anchors.fill: passwordWarningRect
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.textFontSize
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
        }
    }

    NodoInputField {
        id: deviceSSHReenterPasswordField
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHPasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Re-enter New Password")
        valueText: ""
        readOnlyFlag: deviceSSHScreen.inputFieldReadOnly
        passwordInput: true
        onTextEditFinished: {
            showPasswordCheckError(deviceSSHReenterPasswordField.valueText, deviceSSHPasswordField.valueText)
        }
    }


    NodoButton {
        id: deviceSSHApplyButton
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHReenterPasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: systemMessages.messages[NodoMessages.Message.Apply]
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: (deviceSSHOldPasswordField.valueText !== "") && (deviceSSHScreen.isPasswordValid) && (deviceSSHPasswordField.valueText.length >= 8) && (deviceSSHReenterPasswordField.valueText === deviceSSHPasswordField.valueText) ? true : false
        onClicked: {
            deviceSSHScreen.inputFieldReadOnly = true
            deviceSSHScreen.isPasswordValid = false
            nodoControl.changePassword(deviceSSHOldPasswordField.valueText, deviceSSHPasswordField.valueText)
        }
    }

    NodoPopup {
        id: deviceSSHScreenPopup
        onApplyClicked: {
            close()
        }
    }
}
