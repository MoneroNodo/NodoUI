pragma Singleton
import QtQuick 2.15

Item
{
    readonly property FontLoader fontUrbanist: FontLoader { source: "qrc:/NodoSystem/InterRegular.ttf" }

    property int nodoItemHeight: 80

    property int topMenuYposition: 32
    property int topMenuButtonHeight: 110
    property int topMenuButtonFontSize: 38
    property int topMenuGapBetweenButtons: 18
    property int dateTimeFontSize: 56

    property int subMenuButtonHeight: nodoItemHeight
    property int subMenuButtonFontSize: 38
    property int textFontSize: 38
    property int buttonTextFontSize: 38
    property int subMenuLeftMargin: 32

    property int topMenuTextTopPadding: 0

    property color defaultColorNightModeOff: "#FCFCFC"				//1TEXT FONT//
	property color defaultColorNightModeOn: "#AE0000"							//NMCOLOR2//
    
	property color highlightedColorNightModeOff: "#FA5501"			//1COLOR BG//
    property color highlightedColorNightModeOn: "#F50000"			//NMCOLOR1 BG//

    property int infoFieldItemFontSize: 35
    property int infoFieldValueFontSize: 35

    property int inputFieldItemFontSize: 35
    property int inputFieldValueFontSize: 35

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
