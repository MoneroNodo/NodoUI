pragma Singleton
import QtQuick 2.15

Item
{
    readonly property FontLoader fontInter: FontLoader { source: "qrc:/NodoSystem/InterDisplay.ttf"; id: fontInter }

    property int nodoItemHeight: 85

    property int topMenuYposition: 50//32 + 5
    property int topMenuButtonHeight: nodoItemHeight
    property int topMenuButtonFontSize: 48
    property int topMenuGapBetweenButtons: 25
    property int dateTimeFontSize: 56

    property int subMenuButtonHeight: nodoItemHeight
    property int subMenuButtonFontSize: topMenuButtonFontSize
    property int textFontSize: 42
    property int buttonTextFontSize: topMenuButtonFontSize - 8 
    property int subMenuLeftMargin: 10
    property int subMenuTopMargin: 25

    property int descriptionTitleFontSize: textFontSize - 8
    property int descriptionTextFontSize: textFontSize - 2

    property color descriptionTextFontColorNightModeOff: "#A0A0A0" //RGB 160
    property color descriptionTextFontColorNightModeOn: "#870000" //R135

    property int topMenuTextTopPadding: 0

    property color red: "#C80000"    //R245
    property color amber: "#FF9F0A" //255,159,10
    property color green: "#48B400" //R72,G180,B0
    property string syncDot: "●"

    property color cardBackgroundColor: "#272727" //RGB 39
    property int cardLeftMargin: 10
    property int cardTopMargin: 15

    property color defaultColorNightModeOff: "#F5F5F5"				//1TEXT FONT//
	property color defaultColorNightModeOn: "#AE0000"							//NMCOLOR2//
    
	property color highlightedColorNightModeOff: "#F86F2A"			//1COLOR BG//
    property color highlightedColorNightModeOn: red //"#F50000"			//NMCOLOR1 BG//

    property int infoFieldItemFontSize: textFontSize
    property int infoFieldValueFontSize: textFontSize

    property int inputFieldItemFontSize: textFontSize
    property int inputFieldValueFontSize: textFontSize

    property color dataFieldTextColorNightModeOn: defaultColorNightModeOn //"#AE0000"						//NMCOLOR2//
    property color dataFieldTextColorNightModeOff: defaultColorNightModeOff //"#F5F5F5"		//1TEXT FONT//

    property color dataFieldTitleBGColorNightModeOn: "#2F2F2F" //RGB 47
    property color dataFieldTitleBGColorNightModeOff: "#2F2F2F"

    property color dataFieldTextBGColorNightModeOn: "#212121" //RGB 33
    property color dataFieldTextBGColorNightModeOff: "#212121"

    property color buttonTextColorNightModeOn: defaultColorNightModeOff //"#F5F5F5"			//1TEXT FONT//
    property color buttonBGColorNightModeOn: defaultColorNightModeOn //"#AE0000"							//NMCOLOR2//			

    property color buttonTextColorNightModeOff: defaultColorNightModeOff //"#F5F5F5"			//1TEXT FONT//
    property color buttonBGColorNightModeOff: highlightedColorNightModeOff //"#FA5501"				//1COLOR BG//

    property color dayTextColorNightModeOn: highlightedColorNightModeOn //"#F50000"				//NMCOLOR1 BG//
    property color dayTextColorNightModeOff: "#CFCFCF"				//ANALOG CLOCK DAY COLOR//

    property color dateTextColorNightModeOn: defaultColorNightModeOn //"#AE0000"						//NMCOLOR2 CLOCK NIGHT COLOR//
    property color dateTextColorNightModeOff: "#9D9D9D"				//ANALOG CLOCK DAY COLOR//

    property color switchBackgroundColor: "#414141"	//RGB65
    property color buttonDisabledColor: "#414141"					//BUTTON DISABLED//
    property color buttonBorderColor: "#555555" //  RGB85

    property int digitalClockPixelSize: 740

    property int padding: 0
    property int textPadding: 15

    property int nodoItemWidth: 300
    property int nodoTopMargin: 20

    property int comboboxFontSize: 25

    property color comboBoxHighlightedItemBGColorNightModeOff: //highlightedColorNightModeOff "#FA5501" 	//1COLOR BG//
    property color comboBoxHighlightedItemBGColorNightModeOn: highlightedColorNightModeOn //"#F50000"		//NMCOLOR1 BG//

    property color comboBoxTextColor: defaultColorNightModeOff //"#F5F5F5"							//1TEXT FONT//

    //property color lockIndicatorBorderColorNightModeOn: highlightedColorNightModeOn //"#F50000"
    //property color lockIndicatorFilledColorNightModeOn: highlightedColorNightModeOn //"#F50000"
    property color lockIndicatorBorderColor: highlightedColorNightModeOff //"#FA5501"						//1COLOR BG//
    property color lockIndicatorFilledColor: highlightedColorNightModeOff //"#FA5501"						//1COLOR BG//
    property color lockIndicatorEmptyColor: "black"
    property color lockButtonColor: dataFieldTextBGColorNightModeOff//"#232323"												//3COLOR BG//
    property color lockButtonTextColor: defaultColorNightModeOff //"#F5F5F5"						//1TEXT FONT//
    property int lockButtonTextSize: 55
    property int lockButtonWidth: 160
    property int lockButtonHeight: 160
    property int lockPinDiameter: 33


    property color keyboardButtonUnpressed: dataFieldTextBGColorNightModeOff//"#282828"
    property color keyboardButtonPressed: switchBackgroundColor//"#323232"						//KBONPRESS//
    property color keyboardBackgroundColor: "black"
    property color textColorOnUnpressedButton: defaultColorNightModeOff //"#F5F5F5"				//1TEXT FONT//
    property color capsLockOnColor: highlightedColorNightModeOff //"#FA5501"							//1COLOR BG//

    property color inputPreviewBackgroundColor: keyboardButtonUnpressed						//3COLOR BG//
    property color inputPreviewTextColor: defaultColorNightModeOff //"#F5F5F5"						//1TEXT FONT//

    property color popupBackgroundColor: dataFieldTitleBGColorNightModeOff//"#232323"								//2COLOR BG//
}
