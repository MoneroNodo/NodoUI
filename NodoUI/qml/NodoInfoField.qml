import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: root
    x: 0
    y: 0
    property string itemText: "item name"
    property string valueText: ""
    property int itemFontSize: NodoSystem.infoFieldItemFontSize
    property int valueFontSize: NodoSystem.infoFieldValueFontSize
    property int textLeftPadding: NodoSystem.textPadding
    property int textRightPadding: NodoSystem.textPadding

    property int labelWidth: namelabel.paintedWidth + textLeftPadding + textRightPadding
    property int itemSize: 0
    property int labelRectRoundSize: labelWidth > NodoSystem.nodoItemWidth ? labelWidth : NodoSystem.nodoItemWidth

    NodoCanvas {
        id: labelCanvas
        width: itemSize > 0 ? itemSize : labelRectRoundSize
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff

        Text{
            id: namelabel
            width: namelabel.paintedWidth
            height: root.height
            text: itemText
            leftPadding: textLeftPadding
            rightPadding: textRightPadding
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: itemFontSize
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
        }
    }

    NodoCanvas {
        id: valueCanvas
        anchors.left: labelCanvas.right
        anchors.leftMargin: NodoSystem.padding
        width: root.width - labelCanvas.width
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff

        Text {
            id: valueLabel
            width: valueCanvas.width
            height: root.height
            text: valueText
            leftPadding: textLeftPadding
            rightPadding: textRightPadding
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: valueFontSize
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
        }
    }
}

