import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceDisplayScreen
    anchors.fill: parent
    property alias themeMode: deviceDisplayNightModeSwitch
    themeMode.checked: nodoControl.appTheme
    property int dropdownLength: 1400

    Component.onCompleted: {
        deviceDisplayCurrencyComboBox.currentIndex = priceTicker.getCurrentCurrencyIndex()
        deviceDisplaySlider.value = nodoControl.getBacklightLevel()
    }

    Rectangle {
        id: deviceDisplayBrightnessRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceDisplaySliderLabel
            anchors.left: deviceDisplayBrightnessRect.left
            anchors.top: deviceDisplayBrightnessRect.top
            height: deviceDisplayBrightnessRect.height
            text: qsTr("Brightness")
        }

        NodoSlider {
            id: deviceDisplaySlider
            anchors.left: deviceDisplaySliderLabel.right
            anchors.top: deviceDisplayBrightnessRect.top
            anchors.leftMargin: NodoSystem.padding
            width: dropdownLength
            height: deviceDisplayBrightnessRect.height
            snapMode: Slider.NoSnap
            stepSize: 1
            from: 0
            value: 50
            to: 100
            handleHeight: height*0.8
            handleWidth: handleHeight
            onValueChanged: {
                nodoControl.setBacklightLevel(value)
            }
        }
    }

    Rectangle {
        id: deviceDisplayNightModeSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayBrightnessRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

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
            property int displayRotation: nodoControl.getOrientation()
            checked:
            {
                if((displayRotation === -90) || (displayRotation === 0))
                {
                    false
                }
                else if((displayRotation === 90) || (displayRotation === 180))
                {
                    true
                }
            }
            state:
            {
                if((displayRotation === -90) || (displayRotation === 0))
                {
                    "not_rotated"
                }
                else if((displayRotation === 90) || (displayRotation === 180))
                {
                    "rotated"
                }
            }
            onCheckedChanged: {
                if (checked)
                {
                    if(displayRotation == -90)
                        displayRotation = 90
                    else if(displayRotation == 0)
                        displayRotation = 180
                }
                else
                {
                    if(displayRotation == 90)
                        displayRotation = -90
                    else if(displayRotation == 180)
                        displayRotation = 0

                }
                nodoControl.setOrientation(displayRotation)
            }
        }
    }

    Rectangle {
        id: screenSaverRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayFlipOrientationSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
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
        anchors.left: deviceDisplayScreen.left
        anchors.top: screenSaverRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        visible: false


        NodoLabel {
            id: deviceDisplayLanguageLabel
            height: languageRect.height
            anchors.top: languageRect.top
            anchors.left: languageRect.left
            anchors.rightMargin: NodoSystem.padding
            text: qsTr("Language")
        }

        NodoComboBox
        {
            id: deviceDisplayLanguageComboBox
            anchors.left: deviceDisplayLanguageLabel.right
            anchors.leftMargin: NodoSystem.padding
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
        anchors.left: deviceDisplayScreen.left
        // anchors.top: languageRect.bottom
        anchors.top: screenSaverRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayTimezoneLabel
            height: timezoneRect.height
            anchors.top: timezoneRect.top
            anchors.left: timezoneRect.left
            anchors.rightMargin: NodoSystem.padding
            text: qsTr("Time Zone")
        }

        NodoComboBox
        {
            id: deviceDisplayTimezoneComboBox
            anchors.left: deviceDisplayTimezoneLabel.right
            anchors.leftMargin: NodoSystem.padding
            anchors.top: deviceDisplayTimezoneLabel.top
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
        anchors.left: deviceDisplayScreen.left
        anchors.top: timezoneRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayCurrencyLabel
            height: currencyRect.height
            anchors.top: currencyRect.top
            anchors.left: currencyRect.left
            anchors.rightMargin: NodoSystem.padding
            text: qsTr("Currency")
        }

        NodoComboBox
        {
            id: deviceDisplayCurrencyComboBox
            anchors.left: deviceDisplayCurrencyLabel.right
            anchors.leftMargin: NodoSystem.padding
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

    Rectangle {
        id: keyboardLayoutRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: currencyRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: keyboardLayoutLabel
            height: keyboardLayoutRect.height
            anchors.top: keyboardLayoutRect.top
            anchors.left: keyboardLayoutRect.left
            text: qsTr("Keyboard")
        }

        NodoComboBox
        {
            id: keyboardLayoutComboBox
            anchors.left: keyboardLayoutLabel.right
            anchors.leftMargin: NodoSystem.padding
            anchors.top: keyboardLayoutRect.top
            width: dropdownLength
            height: keyboardLayoutRect.height
            currentIndex: nodoControl.getKeyboardLayoutType()
            model: [qsTr("QWERTY"), qsTr("QWERTZ"), qsTr("AZERTY")]
            onCurrentIndexChanged: {
                nodoControl.setKeyboardLayoutType(currentIndex)
                VirtualKeyboardSettings.locale = nodoControl.getKeyboardLayoutLocale()
            }
        }
    }
}
