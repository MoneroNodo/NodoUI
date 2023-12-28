import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Button {
    id: root
    x: 0
    y: 0
    flat: true
    width: buttonText.paintedWidth + buttonText.leftPadding + buttonText.rightPadding
    implicitHeight: 30
    property string buttonTextColor: nodoControl.appTheme ? NodoSystem.buttonTextColorNightModeOn : NodoSystem.buttonTextColorNightModeOff
    property int textLeftPadding: 5
    property int textRightPadding: 5
    property string backgroundColor:  nodoControl.appTheme ? NodoSystem.buttonBGColorNightModeOn : NodoSystem.buttonBGColorNightModeOff
    property int frameRadius: 0
    property bool isActive: false

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

    background: Rectangle {
        color: root.backgroundColor
        radius: root.frameRadius

    }
}
