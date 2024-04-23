import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import NodoCanvas 1.0

Button {
    id: root
    x: 0
    y: 0
    flat: true
    implicitHeight: 30
    property string buttonTextColor: nodoControl.appTheme ? NodoSystem.buttonTextColorNightModeOn : NodoSystem.buttonTextColorNightModeOff
    property int textLeftPadding: NodoSystem.textPadding
    property int textRightPadding: NodoSystem.textPadding
    property string backgroundColor:  nodoControl.appTheme ? NodoSystem.buttonBGColorNightModeOn : NodoSystem.buttonBGColorNightModeOff
    property bool isActive: false
    property int buttonWidth: buttonText.paintedWidth + textLeftPadding + textRightPadding
    width: buttonWidth > NodoSystem.nodoItemWidth ? buttonWidth : NodoSystem.nodoItemWidth

    contentItem: Text {
        id: buttonText
        y: 0
        width: buttonText.paintedWidth
        height: root.implicitHeight
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
        color: root.backgroundColor
    }
}
