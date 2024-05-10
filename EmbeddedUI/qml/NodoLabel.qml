import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
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

    font.family: NodoSystem.fontUrbanist.name
    font.pixelSize: NodoSystem.infoFieldItemFontSize
    verticalAlignment: Text.AlignVCenter
    color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff

    background: NodoCanvas {
        width: root.width
        color: backgroundColor
    }
}


