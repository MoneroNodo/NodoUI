pragma Singleton
import QtQuick 2.15

Item
{
    readonly property FontLoader fontUrbanist: FontLoader { source: "qrc:/NodoSystem/InterRegular.ttf" }
    property int topMenuYposition: 32
    property int topMenuButtonHeight: 128
    property int topMenuButtonFontSize: 32
    property int topMenuGapBetweenButtons: 16
    property int dateTimeFontSize: 56


    property int subMenuButtonFontSize: 32
    property int textFontSize: 32
    property int buttonTextFontSize: 32
    property int subMenuLeftMargin: 32

    property int infoFieldLabelHeight: 64
    property int topMenuTextTopPadding: 21

    property color defaultColorNightModeOff: "#CFCFCF"
    property color highlightedColorNightModeOff: "#FF5100"

    property color defaultColorNightModeOn: "#AE0000"
    property color highlightedColorNightModeOn: "#F50000"

    property int infoFieldItemFontSize: 25
    property int infoFieldValueFontSize: 25

    property int inputFieldItemFontSize: 25
    property int inputFieldValueFontSize: 25

    property color dataFieldTextColorNightModeOn: "#AE0000"
    property color dataFieldTextColorNightModeOff: "#FCFCFC"


    property color dataFieldTitleBGColorNightModeOn: "#111111"
    property color dataFieldTitleBGColorNightModeOff: "#222222"

    property color dataFieldTextBGColorNightModeOn: "#080808"
    property color dataFieldTextBGColorNightModeOff: "#111111"

    property color buttonTextColorNightModeOn: "#FCFCFC"
    property color buttonBGColorNightModeOn: "#AE0000"

    property color buttonTextColorNightModeOff: "#FCFCFC"
    property color buttonBGColorNightModeOff: "#FF5100"

    property color dayTextColorNightModeOn: "#F50000"
    property color dayTextColorNightModeOff: "#CFCFCF"

    property color dateTextColorNightModeOn: "#960000"
    property color dateTextColorNightModeOff: "#9D9D9D"

    property color switchBackgroundColor: "#a6a6a6"

    property int digitalClockPixelSize: 750
}
