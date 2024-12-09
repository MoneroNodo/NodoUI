import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Label {
    id: root
    leftPadding: 20
    rightPadding: 20
    property color backgroundColor: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff

    property int labelWidth: root.paintedWidth + root.leftPadding + root.rightPadding
    property int itemSize: 0
    property int labelRectRoundSize: labelWidth > NodoSystem.nodoItemWidth ? labelWidth : NodoSystem.nodoItemWidth
    width: itemSize > 0 ? itemSize : labelRectRoundSize

    font.family: NodoSystem.fontInter.name
    font.pixelSize: NodoSystem.infoFieldItemFontSize
    verticalAlignment: Text.AlignVCenter
    color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff

    background: NodoCanvas {
        width: root.width
        height: root.height
        color: backgroundColor
    }
}


