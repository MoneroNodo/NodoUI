import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: deviceDisplayScreen
    anchors.fill: parent
    property alias themeMode: deviceDisplayNightModeSwitch
    themeMode.checked: nodoControl.appTheme
    property int dropdownLength: 810

    Component.onCompleted: {
        deviceDisplayCurrencyComboBox.currentIndex = priceTicker.getCurrentCurrencyIndex()
    }

    Label {
        id: deviceDisplaySliderLabel
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayScreen.top
        width: 180
        height: 32
        text: qsTr("Brightness")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoSlider {
        id: deviceDisplaySlider
        anchors.left: deviceDisplaySliderLabel.right
        anchors.top: deviceDisplayScreen.top
        anchors.leftMargin: 32
        width: 600
        height: 32
        snapMode: Slider.NoSnap
        stepSize: 1
        from: 1
        value: 25
        to: 100
        handleHight: 64
        handleWidth: handleHight
        handleRadius: handleHight/2
    }

    Rectangle {
        id: deviceDisplayNightModeSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplaySliderLabel.bottom
        anchors.topMargin: 50
        height: 64
        width: 128
        color: "black"

        NodoSwitch {
            id: deviceDisplayNightModeSwitch
            height: 64
            width: 128
            text:  ""
            display: AbstractButton.IconOnly

            onCheckedChanged: {
                nodoControl.appTheme = themeMode.checked;
            }
        }

        Text{
            id: deviceDisplayNightModeSwitchText
            anchors.left: deviceDisplayNightModeSwitchRect.right
            anchors.leftMargin: 16
            y: (deviceDisplayNightModeSwitchRect.height - deviceDisplayNightModeSwitchText.height)/2
            text: qsTr("Night Mode")
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }
    }

    Rectangle {
        id: deviceDisplayFlipOrientationSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayNightModeSwitchRect.bottom
        anchors.topMargin: 30
        width: 128
        height: 64
        color: "black"

        NodoSwitch {
            id: deviceDisplayFlipOrientationSwitch
            height: 64
            width: 128

            text: ""
            display: AbstractButton.IconOnly
            checked: false
        }

        Text{
            id: deviceDisplayFlipOrientationSwitchText
            anchors.left: deviceDisplayFlipOrientationSwitchRect.right
            anchors.leftMargin: 16
            y: (deviceDisplayFlipOrientationSwitchRect.height - deviceDisplayFlipOrientationSwitchText.height)/2
            text: qsTr("Flip Orientation")
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }
    }


    Label {
        id: deviceDisplayScreensaverLabel
        anchors.left: deviceDisplaySliderLabel.left
        anchors.top: deviceDisplayFlipOrientationSwitchRect.bottom
        anchors.topMargin: 30
        width: 100
        text: qsTr("Screensaver")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }


    NodoComboBox
    {
        id: screenSaverComboBox
        anchors.left: deviceDisplaySliderLabel.left
        anchors.top: deviceDisplayScreensaverLabel.bottom
        anchors.topMargin: 16
        width: dropdownLength
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 32
        currentIndex: nodoControl.getScreenSaverType()
        model: [qsTr("News Carousel"), qsTr("Analog Clock"), qsTr("Digital Clock"), qsTr("Off")]
        onCurrentIndexChanged: {
            nodoControl.setScreenSaverType(currentIndex)
        }
    }

    Label {
        id: deviceDisplayLanguageLabel
        anchors.left: deviceDisplaySlider.right
        anchors.top: deviceDisplayScreen.top
        anchors.leftMargin: 175
        width: 180
        height: 32
        text: qsTr("Language")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoComboBox
    {
        id: deviceDisplayLanguageComboBox
        anchors.left: deviceDisplayLanguageLabel.left
        anchors.top: deviceDisplayLanguageLabel.bottom
        anchors.topMargin: 16
        width: dropdownLength
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 32
        currentIndex: translator.getLanguageIndex()
        model: translator.languages
        onCurrentIndexChanged: {
            translator.setLanguageIndex(currentIndex)
        }
    }

    Label {
        id: deviceDisplayTimezoneLabel
        anchors.left: deviceDisplayLanguageLabel.left
        anchors.top: deviceDisplayLanguageComboBox.bottom
        anchors.topMargin: 75
        width: 180
        height: 32
        text: qsTr("Time zone")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoComboBox
    {
        id: deviceDisplayTimezoneComboBox
        anchors.left: deviceDisplayTimezoneLabel.left
        anchors.top: deviceDisplayTimezoneLabel.bottom
        anchors.topMargin: 16
        width: dropdownLength
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 32
        currentIndex: nodoControl.getTimeZoneIndex()
        model: nodoTimezones.timezoneNames
        onCurrentIndexChanged: {
            nodoControl.setTimeZoneIndex(currentIndex)
        }
    }

    Label {
        id: deviceDisplayCurrencyLabel
        anchors.left: deviceDisplayLanguageLabel.left
        anchors.top: deviceDisplayTimezoneComboBox.bottom
        anchors.topMargin: 75
        width: 180
        height: 32
        text: qsTr("Currency")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoComboBox
    {
        id: deviceDisplayCurrencyComboBox
        anchors.left: deviceDisplayCurrencyLabel.left
        anchors.top: deviceDisplayCurrencyLabel.bottom
        anchors.topMargin: 16
        width: dropdownLength
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 32
        model: currencyListModel
        currentIndex: priceTicker.getCurrentCurrencyIndex()

        onCurrentIndexChanged: {
            priceTicker.setCurrentCurrencyIndex(currentIndex)
            priceTicker.setCurrentCurrencyCode(nodoCurrencies.currencyCodes[currentIndex])
        }
    }

    ListModel {
        id: currencyListModel
        Component.onCompleted: {
            for (var i = 0; i < nodoCurrencies.currencyNames.length; i++) {
                append(createCurrencyList(i));
            }
        }

        function createCurrencyList(index) {
            return {
                name: nodoCurrencies.currencyNames[index] + " (" + nodoCurrencies.currencySymbols[index] + ")"
            };
        }
    }
}
