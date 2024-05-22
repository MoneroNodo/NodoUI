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
    property int inputFieldWidth: 600

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceSSHSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceSSHSwitchText.labelRectRoundSize

        if(deviceSSHUserNameField.labelRectRoundSize > labelSize)
            labelSize = deviceSSHUserNameField.labelRectRoundSize

        if(deviceSSHPasswordField.labelRectRoundSize > labelSize)
            labelSize = deviceSSHPasswordField.labelRectRoundSize

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
        width: inputFieldWidth
        itemSize: labelSize
        height: NodoSystem.infoFieldLabelHeight
        itemText: qsTr("Username")
        valueText: "nodo"
    }

    NodoInputField {
        id: deviceSSHPasswordField
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHUserNameField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.inputFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Password")
        valueText: ""
        passwordInput: true
    }


    NodoButton {
        id: deviceSSHApplyButton
        anchors.left: deviceSSHScreen.left
        anchors.top: deviceSSHPasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Apply")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: deviceSSHPasswordField.valueText.length >= 8 ? true : false
        onClicked: {
            nodoControl.setPassword(deviceSSHPasswordField.valueText);
        }
    }
}
