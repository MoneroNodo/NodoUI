import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

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
        y: (control.height-img.height) /2
        anchors.fill: control
        fillMode: Image.PreserveAspectFit
    }
    background: Rectangle {
        color: "black"
    }
    contentItem: Text {
        id: buttonText
        y: 0
        width: buttonText.paintedWidth
        height: control.implicitHeight
        text: control.text
        font: control.font
        color: control.checked ? (nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff) :
                                 (nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff)

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.textLeftPadding
        rightPadding: control.textRightPadding
        textFormat: Text.PlainText
    }
}

