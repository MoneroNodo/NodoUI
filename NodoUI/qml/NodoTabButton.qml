import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1

TabButton {
    id: control
    width: buttonText.paintedWidth + buttonText.leftPadding + buttonText.rightPadding

    property string imagePath: ""
    property int textLeftPadding: 15
    property int textRightPadding: 15

    Image {
        id: img
        source: control.imagePath
        x: 0
        y: (control.height-img.height) /2
        anchors.fill: control
        fillMode: Image.PreserveAspectFit
    }
    background: Rectangle {
        color: "black"
    }
    contentItem: Text {
        id: buttonText
        text: control.text
        font: control.font
        color: enabled ? (control.checked ? (nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff) :
                                 (nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff)) : NodoSystem.buttonDisabledColor

        topPadding: NodoSystem.topMenuTextTopPadding
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.textLeftPadding
        rightPadding: control.textRightPadding
        textFormat: Text.PlainText
    }
}

