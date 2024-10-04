import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: inputPreview
    property string text: ""
    color: NodoSystem.inputPreviewBackgroundColor
    property int textLeftPadding: NodoSystem.textPadding
    property int textRightPadding: NodoSystem.textPadding

    TextInput {
        id: textPreview
        anchors.left: inputPreview.left
        anchors.leftMargin: textLeftPadding
        anchors.right: passwordButton.visible ? passwordButton.left : inputPreview.right
        y:0
        height: inputPreview.height
        text: inputPreview.text
        rightPadding: textRightPadding
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.inputFieldValueFontSize * 1.5
        clip: true
        readOnly: true
        focus: false
        echoMode: nodoControl.getEchoMode()
        color: NodoSystem.inputPreviewTextColor
    }

    MouseArea {
        anchors.fill: textPreview
    }

    NodoPasswordButton {
        id: passwordButton
        visible: nodoControl.getPasswordMode()
        anchors.right: inputPreview.right
        anchors.top: inputPreview.top
        anchors.topMargin: 15
        anchors.rightMargin: 11
        width: inputPreview.height - 30
        height: inputPreview.height - 30

        hidePassword: nodoControl.getEchoMode()

        onHideStatusChanged: {
            if(passwordButton.hidePassword === true)
            {
                nodoControl.setEchoMode(TextInput.Password)
            }
            else
            {
                nodoControl.setEchoMode(TextInput.Normal)

            }
        }

        Connections {
            target: nodoControl
            function onEchoModeChanged()
            {
                passwordButton.hidePassword = nodoControl.getEchoMode()
                textPreview.echoMode = nodoControl.getEchoMode()
            }

            function onPasswordModeChanged()
            {
                passwordButton.visible = nodoControl.getPasswordMode()
            }
        }
    }



}
