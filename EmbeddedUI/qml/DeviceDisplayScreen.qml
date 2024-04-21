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
    property int dropdownLength: 600

    Component.onCompleted: {
        deviceDisplayCurrencyComboBox.currentIndex = priceTicker.getCurrentCurrencyIndex()
    }

    NodoLabel{
        id: deviceDisplaySliderLabel
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayScreen.top
        height: NodoSystem.nodoItemHeight
        text: qsTr("Brightness")
        verticalAlignment: Text.AlignVCenter
    }

    NodoSlider {
        id: deviceDisplaySlider
        anchors.left: deviceDisplaySliderLabel.right
        anchors.top: deviceDisplayScreen.top
        anchors.leftMargin: NodoSystem.padding
        width: 600
        height: NodoSystem.nodoItemHeight
        snapMode: Slider.NoSnap
        stepSize: 1
        from: 1
        value: 25
        to: 100
        handleHight: height*0.8
        handleWidth: handleHight
    }

    Rectangle {
        id: deviceDisplayNightModeSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplaySliderLabel.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: deviceDisplayNightModeSwitchText
            height: deviceDisplayNightModeSwitchRect.height
            anchors.left: deviceDisplayNightModeSwitchRect.left
            anchors.top: deviceDisplayNightModeSwitchRect.top
            text: qsTr("Night Mode")
        }

        NodoSwitch {
            id: deviceDisplayNightModeSwitch
            anchors.left: deviceDisplayNightModeSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceDisplayNightModeSwitchRect.height
            width: 2*deviceDisplayNightModeSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoControl.appTheme = themeMode.checked;
            }
        }
    }

    Rectangle {
        id: deviceDisplayFlipOrientationSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayNightModeSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: deviceDisplayFlipOrientationSwitchText
            height: deviceDisplayFlipOrientationSwitchRect.height
            anchors.left: deviceDisplayFlipOrientationSwitchRect.left
            anchors.top: deviceDisplayFlipOrientationSwitchRect.top
            text: qsTr("Flip Orientation")
        }

        NodoSwitch {
            id: deviceDisplayFlipOrientationSwitch
            anchors.left: deviceDisplayFlipOrientationSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceDisplayFlipOrientationSwitchRect.height
            width: 2*deviceDisplayFlipOrientationSwitchRect.height
            display: AbstractButton.IconOnly
            checked: false
        }
    }

    Rectangle {
        id: screenSaverRect
        anchors.left: deviceDisplaySliderLabel.left
        anchors.top: deviceDisplayFlipOrientationSwitchRect.bottom
        anchors.topMargin: 30
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: screenSaverLabel
            height: screenSaverRect.height
            anchors.top: screenSaverRect.top
            anchors.left: screenSaverRect.left
            text: qsTr("Screensaver")
        }

        NodoComboBox
        {
            id: screenSaverComboBox
            anchors.left: screenSaverLabel.right
            anchors.leftMargin: NodoSystem.padding
            anchors.top: screenSaverRect.top
            width: dropdownLength
            height: screenSaverRect.height
            currentIndex: nodoControl.getScreenSaverType()
            model: [qsTr("News Carousel"), qsTr("Analog Clock"), qsTr("Digital Clock"), qsTr("Off")]
            onCurrentIndexChanged: {
                nodoControl.setScreenSaverType(currentIndex)
            }
        }
    }

    Rectangle {
        id: languageRect
        anchors.left: deviceDisplaySlider.right
        anchors.top: deviceDisplayScreen.top
        anchors.leftMargin: 16
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayLanguageLabel
            height: languageRect.height
            anchors.top: languageRect.top
            anchors.left: languageRect.left
            text: qsTr("Language")
        }

        NodoComboBox
        {
            id: deviceDisplayLanguageComboBox
            anchors.left: deviceDisplayLanguageLabel.right
            anchors.top: deviceDisplayLanguageLabel.top
            width: dropdownLength
            height: languageRect.height
            currentIndex: translator.getLanguageIndex()
            model: translator.languages
            onCurrentIndexChanged: {
                translator.setLanguageIndex(currentIndex)
            }
        }
    }

    Rectangle {
        id: timezoneRect
        anchors.left: languageRect.left
        anchors.top: languageRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayTimezoneLabel
            height: timezoneRect.height
            anchors.left: timezoneRect.left
            anchors.top: timezoneRect.top
            text: qsTr("Time zone")
        }

        NodoComboBox
        {
            id: deviceDisplayTimezoneComboBox
            anchors.left: deviceDisplayTimezoneLabel.right
            anchors.top: timezoneRect.top
            width: dropdownLength
            height: timezoneRect.height
            currentIndex: nodoControl.getTimeZoneIndex()
            model: nodoTimezones.timezoneNames
            onCurrentIndexChanged: {
                nodoControl.setTimeZoneIndex(currentIndex)
            }
        }
    }

    Rectangle {
        id: currencyRect
        anchors.left: languageRect.left
        anchors.top: timezoneRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayCurrencyLabel
            height: currencyRect.height
            anchors.left: currencyRect.left
            anchors.top: currencyRect.top
            text: qsTr("Currency")
        }

        NodoComboBox
        {
            id: deviceDisplayCurrencyComboBox
            anchors.left: deviceDisplayCurrencyLabel.right
            anchors.top: deviceDisplayCurrencyLabel.top
            width: dropdownLength
            height: currencyRect.height
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
}
