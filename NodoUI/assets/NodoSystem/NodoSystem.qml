pragma Singleton
import QtQuick 2.15

Item
{
    readonly property FontLoader fontInter: FontLoader { source: "qrc:/NodoSystem/InterDisplay.ttf" }

    property int nodoItemHeight: 85

    property int topMenuYposition: 32
    property int topMenuButtonHeight: nodoItemHeight
    property int topMenuButtonFontSize: 48
    property int topMenuGapBetweenButtons: 25
    property int dateTimeFontSize: 56

    property int subMenuButtonHeight: topMenuButtonHeight
    property int subMenuButtonFontSize: topMenuButtonFontSize
    property int textFontSize: 44
    property int buttonTextFontSize: topMenuButtonFontSize
    property int subMenuLeftMargin: 10

    property int topMenuTextTopPadding: 0

    property color defaultColorNightModeOff: "#FCFCFC"				//1TEXT FONT//
	property color defaultColorNightModeOn: "#AE0000"							//NMCOLOR2//
    
	property color highlightedColorNightModeOff: "#FA5501"			//1COLOR BG//
    property color highlightedColorNightModeOn: "#F50000"			//NMCOLOR1 BG//

    property int infoFieldItemFontSize: textFontSize
    property int infoFieldValueFontSize: textFontSize

    property int inputFieldItemFontSize: textFontSize
    property int inputFieldValueFontSize: textFontSize

    property color dataFieldTextColorNightModeOn: "#AE0000"						//NMCOLOR2//
    property color dataFieldTextColorNightModeOff: "#FCFCFC"		//1TEXT FONT//

    property color dataFieldTitleBGColorNightModeOn: "#262626"					//2COLOR BG//
    property color dataFieldTitleBGColorNightModeOff: "#262626"					//2COLOR BG//

    property color dataFieldTextBGColorNightModeOn: "#1F1F1F"								//3COLOR BG//
    property color dataFieldTextBGColorNightModeOff: "#1F1F1F"								//3COLOR BG//

    property color buttonTextColorNightModeOn: "#FCFCFC"			//1TEXT FONT//
    property color buttonBGColorNightModeOn: "#AE0000"							//NMCOLOR2//			

    property color buttonTextColorNightModeOff: "#FCFCFC"			//1TEXT FONT//
    property color buttonBGColorNightModeOff: "#FA5501"				//1COLOR BG//

    property color dayTextColorNightModeOn: "#F50000"				//NMCOLOR1 BG//
    property color dayTextColorNightModeOff: "#CFCFCF"				//CLOCK DAY COLOR//

    property color dateTextColorNightModeOn: "#AE0000"						//NMCOLOR2 CLOCK NIGHT COLOR//
    property color dateTextColorNightModeOff: "#9D9D9D"				//CLOCK DAY COLOR//

    property color switchBackgroundColor: "#1F1F1F"											//3COLOR BG//
    property color buttonDisabledColor: "#464646"					//BUTTON DISABLED//

    property int digitalClockPixelSize: 750

    property int padding: 0
    property int textPadding: 20

    property int nodoItemWidth: 300
    property int nodoTopMargin: 16

    property int comboboxFontSize: 25

    property color comboBoxHighligtedItemBGColorNightModeOff: "#FA5501" 	//1COLOR BG//
    property color comboBoxHighligtedItemBGColorNightModeOn: "#F50000"		//NMCOLOR1 BG//

    property color comboBoxTextColor: "#FCFCFC"							//1TEXT FONT//

    property color lockIndicatorBorderColor: "#FA5501"						//1COLOR BG//
    property color lockIndicatorFilledColor: "#FA5501"						//1COLOR BG//
    property color lockIndicatorEmptyColor: "#000000"
    property color lockButtonColor: "#1F1F1F"												//3COLOR BG//
    property color lockButtonTextColor: "#FCFCFC"						//1TEXT FONT//
    property int lockButtonTextSize: 50
    property int lockButtonWidth: 130
    property int lockButtonHeight: 130
    property int lockPinDiameter: 33


    property color keyboardButtonUnpressed: "#1F1F1F"										//3COLOR BG//
    property color keyboardButtonPressed: "#303030"						//KBONPRESS//
    property color keyboardBackgroundColor: "#000000"
    property color textColorOnUnpressedButton: "#FCFCFC"				//1TEXT FONT//
    property color capsLockOnColor: "#FA5501"							//1COLOR BG//

    property color inputPreviewBackgroundColor: "#1F1F1F"									//3COLOR BG//
    property color inputPreviewTextColor: "#FCFCFC"						//1TEXT FONT//

    property color popupBackgroundColor: "#262626"								//2COLOR BG//
}
