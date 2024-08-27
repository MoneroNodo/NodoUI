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
    property int inputFieldWidth: 700
    property bool inputFieldReadOnly: false

    signal openNextScreen(int screenID)


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
            height: 180
            color: "black"
            Text {
                text: qsTr("Please set your Admin password. The admin password must be at least 8 characters long. A good password contains uppercase and lowercase letters as well as digits and non alpha-numeric characters.\nThe Admin password is used to connect device over SSH. It can be changed later on DEVICE->SSH")
                font.family: NodoSystem.fontUrbanist.name
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
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("New Admin Password")
            valueText: ""
            passwordInput: true
            readOnlyFlag: adminPasswordScreen.inputFieldReadOnly
        }

        NodoInputField {
            id: adminPasswordReenterField
            anchors.left: adminPasswordRect.left
            anchors.top: adminPasswordField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Re-enter Admin Password")
            valueText: ""
            passwordInput: true
            readOnlyFlag: adminPasswordScreen.inputFieldReadOnly
        }


        NodoButton {
            id: passwordApplyButton
            anchors.left: adminPasswordRect.left
            anchors.top: adminPasswordReenterField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: systemMessages.messages[NodoMessages.Message.Apply]
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: (adminPasswordField.valueText.length >= 8) && (adminPasswordField.valueText === adminPasswordReenterField.valueText) ? true : false
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
