import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: nodePrivateNodeScreen
    property int labelSize: 176

    Text{
        id:privateNodeSwitchText
        anchors.left: nodePrivateNodeScreen.left
        y: (privateNodeSwitchRect.height - privateNodeSwitchText.height)/2
        text: "Private Node"
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.textFontSize
    }

    Rectangle {
        id: privateNodeSwitchRect
        anchors.left: privateNodeSwitchText.right
        anchors.top: nodePrivateNodeScreen.top
        height: 64
        width: 128
        color: "black"
        anchors.leftMargin: 32
        NodoSwitch {
            id: privateNodeSwitch
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
        }
    }

    NodoInputField {
        id: privateNodePortField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeSwitchRect.bottom
        anchors.topMargin: 32
        width: 272
        height: 60
        itemSize: labelSize
        itemText: "Port"
        valueText: ""
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInputField {
        id: privateNodeUserNameField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodePortField.bottom
        anchors.topMargin: 16
        width: 480
        height: 64
        itemSize: labelSize
        itemText: "Username"
        valueText: "nodo"
    }

    NodoInputField {
        id: privateNodePasswordField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeUserNameField.bottom
        anchors.topMargin: 16
        width: 480
        height: 64
        itemSize: labelSize
        itemText: "Password"
    }

    NodoButton {
        id: privateNodeApplyButton
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodePasswordField.bottom
        anchors.topMargin: 16
        text: qsTr("Apply")
        height: 64
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 40
        textRightPadding: 40
        frameRadius: 4
    }
}

