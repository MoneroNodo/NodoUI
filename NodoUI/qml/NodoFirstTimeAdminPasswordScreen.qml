import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: adminPasswordScreen
    anchors.leftMargin: 20

    property int labelSize: 0
    property int inputFieldWidth: 1100
    property bool inputFieldReadOnly: false
    property bool isPasswordValid: false

    signal openNextScreen(int screenID)

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
            adminPasswordScreen.isPasswordValid = true;
        }
    }

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(adminPasswordField.labelRectRoundSize > labelSize)
            labelSize = adminPasswordField.labelRectRoundSize

        if(adminPasswordReenterField.labelRectRoundSize > labelSize)
            labelSize = adminPasswordReenterField.labelRectRoundSize

        if(passwordApplyButton.labelRectRoundSize > labelSize)
            labelSize = passwordApplyButton.labelRectRoundSize
    }

    Connections {
        target: nodoControl

        function onPasswordChangeStatus(status) {
            adminPasswordField.valueText = ""
            adminPasswordReenterField.valueText = ""
            if(0 === status)
            {
                openNextScreen(1)
            }
            else
            {
                adminPasswordScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.FailedToChangePassword]
                adminPasswordScreenPopup.commandID = -1;
                adminPasswordScreenPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                adminPasswordScreenPopup.open();
            }

            adminPasswordScreen.inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }
    }


    Rectangle {
        id: adminPasswordRect
        anchors.fill: parent
        color: "black"
        anchors.leftMargin: 20

        Rectangle {
            id: banner
            anchors.top: adminPasswordRect.top
            anchors.left: adminPasswordRect.left
            anchors.right: adminPasswordRect.right
            height: banner.paintedHeight
            color: "black"
            Text {
                text: qsTr("Please set your Admin Password. The Admin Password should be at least 8 characters, with uppercase and lowercase letters, number and a special character.\nThe Admin Password is used to connect to Nodo remotely via SSH. It can be changed later on DEVICE > SYSTEM > Admin & SSH.")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.textFontSize
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                width: banner.width
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            }
        }

        NodoInputField {
            id: adminPasswordField
            anchors.left: adminPasswordRect.left
            anchors.top: banner.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("New Admin Password")
            valueText: ""
            passwordInput: true
            readOnlyFlag: adminPasswordScreen.inputFieldReadOnly
            onTextEditFinished: {
                showPasswordCheckError(adminPasswordField.valueText, adminPasswordReenterField.valueText)
            }
        }

        Rectangle {
            id: passwordWarningRect
            anchors.top: adminPasswordField.top
            anchors.left: adminPasswordField.right
            anchors.right: adminPasswordRect.right
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
            id: adminPasswordReenterField
            anchors.left: adminPasswordRect.left
            anchors.top: adminPasswordField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Re-enter Admin Password")
            valueText: ""
            passwordInput: true
            readOnlyFlag: adminPasswordScreen.inputFieldReadOnly
            onTextEditFinished: {
                showPasswordCheckError(adminPasswordReenterField.valueText, adminPasswordField.valueText)
            }
        }

        NodoButton {
            id: passwordApplyButton
            anchors.left: adminPasswordRect.left
            anchors.top: adminPasswordReenterField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: systemMessages.messages[NodoMessages.Message.Apply]
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: (adminPasswordScreen.isPasswordValid) && (adminPasswordField.valueText.length >= 8) && (adminPasswordField.valueText === adminPasswordReenterField.valueText) ? true : false
            onClicked: {
                isActive = false
                adminPasswordScreen.inputFieldReadOnly = true
                nodoControl.setPassword(adminPasswordField.valueText);
            }
        }

        NodoPopup {
            id: adminPasswordScreenPopup
            onApplyClicked: {
                close()
            }
        }
    }
}
