pragma Singleton
import QtQuick 2.15

Item
{
    readonly property FontLoader fontUrbanist: FontLoader { source: "qrc:/NodoSystem/InterRegular.ttf" }

    property int nodoItemHeight: 70

    property int topMenuYposition: 32
    property int topMenuButtonHeight: 100
    property int topMenuButtonFontSize: 40
    property int topMenuGapBetweenButtons: 16
    property int dateTimeFontSize: 56

    property int subMenuButtonHeight: nodoItemHeight
    property int subMenuButtonFontSize: 40
    property int textFontSize: 32
    property int buttonTextFontSize: 32
    property int subMenuLeftMargin: 32

    property int topMenuTextTopPadding: 0

    property color defaultColorNightModeOff: "#FCFCFC"
    property color highlightedColorNightModeOff: "#FA5501"

    property color defaultColorNightModeOn: "#AE0000"
    property color highlightedColorNightModeOn: "#F50000"

    property int infoFieldItemFontSize: 25
    property int infoFieldValueFontSize: 25

    property int inputFieldItemFontSize: 25
    property int inputFieldValueFontSize: 25

    property color dataFieldTextColorNightModeOn: "#AE0000"
    property color dataFieldTextColorNightModeOff: "#FCFCFC"

    property color dataFieldTitleBGColorNightModeOn: "#1F1F1F"
    property color dataFieldTitleBGColorNightModeOff: "#1F1F1F"

    property color dataFieldTextBGColorNightModeOn: "#181818"
    property color dataFieldTextBGColorNightModeOff: "#181818"

    property color buttonTextColorNightModeOn: "#FCFCFC"
    property color buttonBGColorNightModeOn: "#AE0000"

    property color buttonTextColorNightModeOff: "#FCFCFC"
    property color buttonBGColorNightModeOff: "#FA5501"

    property color dayTextColorNightModeOn: "#F50000"
    property color dayTextColorNightModeOff: "#CFCFCF"

    property color dateTextColorNightModeOn: "#AE0000"
    property color dateTextColorNightModeOff: "#9D9D9D"

    property color switchBackgroundColor: "#181818"
    property color buttonDisabledColor: "#464646"

    property int digitalClockPixelSize: 750

    property int padding: 0
    property int textPadding: 20

    property int nodoItemWidth: 300
    property int nodoTopMargin: 16

    property int comboboxFontSize: 25

    property color comboBoxHighligtedItemBGColorNightModeOff: "#FA5501"
    property color comboBoxHighligtedItemBGColorNightModeOn: "#F50000"

    property color comboBoxTextColor: "#FCFCFC"

    property color lockIndicatorBorderColor: "#FA5501"
    property color lockIndicatorFilledColor: "#FA5501"
    property color lockIndicatorEmptyColor: "#000000"
    property color lockButtonColor: "#141414"
    property color lockButtonTextColor: "#FCFCFC"
    property int lockButtonTextSize: 32
    property int lockButtonWidth: 116
    property int lockButtonHeight: 116
    property int lockPinDiameter: 32


    property color keyboardButtonUnpressed: "#181818"
    property color keyboardButtonPressed: "#303030"
    property color keyboardBackgroundColor: "#000000"//"#111111"
    property color textColorOnUnpressedButton: "#FCFCFC"
    property color capsLockOnColor: "#FA5501"

    property color inputPreviewBackgroundColor: "#181818"
    property color inputPreviewTextColor: "#FCFCFC"

    property color popupBackgroundColor: "#111111"
}
