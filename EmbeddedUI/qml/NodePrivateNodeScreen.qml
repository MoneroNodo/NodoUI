import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodePrivateNodeScreen
    property int labelSize: 0
    property int inputFieldWidth: 600

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(privateNodePortField.labelRectRoundSize > labelSize)
        labelSize = privateNodePortField.labelRectRoundSize

        if(privateNodeUserNameField.labelRectRoundSize > labelSize)
        labelSize = privateNodeUserNameField.labelRectRoundSize

        if(privateNodePasswordField.labelRectRoundSize > labelSize)
        labelSize = privateNodePasswordField.labelRectRoundSize
    }

    Rectangle {
        id: privateNodeSwitchRect
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: nodePrivateNodeScreen.top
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: privateNodeSwitchText
            height: privateNodeSwitchRect.height
            anchors.top: privateNodeSwitchRect.top
            anchors.left: privateNodeSwitchRect.left
            text: qsTr("Private Node")
        }

        NodoSwitch {
            id: privateNodeSwitch
            anchors.left: privateNodeSwitchText.right
            anchors.top: privateNodeSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*privateNodeSwitchRect.height
            height: privateNodeSwitchRect.height
            display: AbstractButton.IconOnly
        }
    }

    NodoInputField {
        id: privateNodePortField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.infoFieldLabelHeight
        width: inputFieldWidth
        itemSize: labelSize
        itemText: qsTr("Port")
        valueText: ""
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInputField {
        id: privateNodeUserNameField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodePortField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Username")
        valueText: "nodo"
    }

    NodoInputField {
        id: privateNodePasswordField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeUserNameField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Password")
        passwordInput: true
    }

    NodoButton {
        id: privateNodeApplyButton
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodePasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Apply")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }
}

