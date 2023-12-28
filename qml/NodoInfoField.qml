import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import NodoSystem 1.1

Item {
    id: root
    x: 0
    y: 0
    property string itemText: "item name"
    property string valueText: "item value"
    property int itemSize: 0
    property int itemFontSize: NodoSystem.infoFieldItemFontSize
    property int valueFontSize: NodoSystem.infoFieldValueFontSize
    property int leftRadius: 4
    property int rightRadius: 4

    Rectangle {
        id: labelRectRound
        width: itemSize
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff
        radius: leftRadius

        Rectangle{
            id: labelRect
            width: itemSize - labelRectRound.radius
            height: root.height
            color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff
            anchors.right: labelRectRound.right

            Text{
                id: namelabel
                width: namelabel.paintedWidth
                height: root.height
                text: qsTr(itemText)
                rightPadding: namelabel.leftPadding - labelRectRound.radius
                leftPadding: 13
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: itemFontSize
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            }
        }
    }

    Rectangle {
        id: valueRectRound
        x: labelRectRound.width
        width: root.width - labelRectRound.width
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
        radius: rightRadius

        Rectangle{
            id: valueRect
            width: valueRectRound.width-valueRectRound.radius
            height: root.height
            anchors.left: valueRectRound.left
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
            radius: itemSize == 0 ? rightRadius : 0

            Text {
                id: valueLabel
                width: valueRect.width
                height: root.height
                text: qsTr(valueText)
                rightPadding: valueLabel.leftPadding - valueRectRound.radius
                leftPadding: 13
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: valueFontSize
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            }
        }
    }
}

