import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Button {
    id: root
    x: 0
    y: 0
    flat: true
    implicitHeight: 32
    property string buttonTextColor: nodoControl.appTheme ? NodoSystem.buttonTextColorNightModeOn : NodoSystem.buttonTextColorNightModeOff
    property int textLeftPadding: NodoSystem.textPadding
    property int textRightPadding: NodoSystem.textPadding
    property string backgroundColor:  nodoControl.appTheme ? NodoSystem.buttonBGColorNightModeOn : NodoSystem.buttonBGColorNightModeOff
    property bool isActive: true
    property bool fitMinimal: false
    property int buttonWidth: buttonText.paintedWidth + textLeftPadding + textRightPadding
    width: fitMinimal == false ?  (buttonWidth > NodoSystem.nodoItemWidth ? buttonWidth : NodoSystem.nodoItemWidth) : buttonWidth
    enabled: isActive

    contentItem: Text {
        id: buttonText
        // y: (root.implicitHeight - buttonText.paintedHeight)/2
        // x: (root.width - buttonText.paintedWidth)/2
        // width: buttonText.paintedWidth
        width: root.width
        height: root.height
        text: root.text
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font: root.font
        leftPadding: root.textLeftPadding
        rightPadding: root.textRightPadding
        color: root.buttonTextColor
    }

    background: NodoCanvas {
        width: root.width
        height: root.height
        color: isActive == false ? NodoSystem.buttonDisabledColor : root.backgroundColor
    }
}
