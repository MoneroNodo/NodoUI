pragma Singleton
import QtQuick 2.12

Item
{  
    readonly property FontLoader fontUrbanist: FontLoader { source: "qrc:/NodoSystem/Urbanist.ttf" }
    property int topMenuYposition: 20
    property int topMenuButtonHeight: 80
    property int topMenuButtonFontSize: 24
    property int topMenuGapBetweenButtons: 10
    property int dateTimeFontSize: 35


    property int subMenuButtonFontSize: 24
    property int textFontSize: 20
    property int buttonTextFontSize: 20
    property int subMenuLeftMargin: 20


    property color defaultColorNightModeOff: "#CFCFCF"
    property color highlightedColorNightModeOff: "#FF5100"

    property color defaultColorNightModeOn: "#AE0000"
    property color highlightedColorNightModeOn: "#F50000"

    property int infoFieldItemFontSize: 16
    property int infoFieldValueFontSize: 16

    property int inputFieldItemFontSize: 16
    property int inputFieldValueFontSize: 16

    property color dataFieldTextColorNightModeOn: "#AE0000"
    property color dataFieldTextColorNightModeOff: "black"


    property color dataFieldTitleBGColorNightModeOn: "#222222"
    property color dataFieldTitleBGColorNightModeOff: "#CCCCCC"

    property color dataFieldTextBGColorNightModeOn: "#141414"
    property color dataFieldTextBGColorNightModeOff: "white"

    property color buttonTextColorNightModeOn: "#CFCFCF"
    property color buttonBGColorNightModeOn: "#AE0000"

    property color buttonBGColorNightModeOff: "#FF5100"
    property color buttonTextColorNightModeOff: "#CFCFCF"

    property color dayTextColorNightModeOn: "#F50000"
    property color dayTextColorNightModeOff: "#CFCFCF"

    property color dateTextColorNightModeOn: "#960000"
    property color dateTextColorNightModeOff: "#9D9D9D"



    property color switchBackgroundColor: "#a6a6a6"
}
