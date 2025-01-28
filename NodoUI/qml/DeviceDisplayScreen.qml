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
    property int labelSize: 260
    property int dropdownLength: width - labelSize - NodoSystem.subMenuLeftMargin

    Component.onCompleted: {
        deviceDisplayCurrencyComboBox.currentIndex = priceTicker.getCurrentCurrencyIndex()
        deviceDisplaySlider.value = nodoControl.getBacklightLevel()
        screenSaverStartAfterInput.valueText = Math.round(nodoControl.getScreenSaverTimeout() / 1000 / 60);
    }

    Rectangle {
        id: deviceDisplayBrightnessRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplaySliderLabel
            anchors.left: deviceDisplayBrightnessRect.left
            anchors.top: deviceDisplayBrightnessRect.top
            height: deviceDisplayBrightnessRect.height
            width: labelSize
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
        id: screenSaverRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: deviceDisplayBrightnessRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"
        width: screenSaverLabel.width + screenSaverComboBox.width

        NodoLabel {
            id: screenSaverLabel
            height: screenSaverRect.height
            anchors.top: screenSaverRect.top
            anchors.left: screenSaverRect.left
            width: labelSize
            text: qsTr("Screensaver")
        }

        NodoComboBox {
            id: screenSaverComboBox
            anchors.left: screenSaverLabel.right
            anchors.leftMargin: NodoSystem.padding
            anchors.top: screenSaverRect.top
            width: 25 + deviceDisplayNightModeSwitch.width + deviceDisplayFlipOrientationSwitch.x + deviceDisplayFlipOrientationSwitch.width //dropdownLength
            height: screenSaverRect.height
            currentIndex: nodoControl.getScreenSaverType()
            model:
            {
                if (nodoControl.isFeedsEnabled())
                {
                    [qsTr("News"), qsTr("Analog Clock"), qsTr("Digital Clock"), qsTr("Display Off"), qsTr("None")]
                }
                else
                {
                    [qsTr("Analog Clock"), qsTr("Digital Clock"), qsTr("Display Off"), qsTr("None")]
                }
            }
            onCurrentIndexChanged: {
                nodoControl.setScreenSaverType(currentIndex)
            }
        }
    }

    Connections {
        target: nodoControl
        function onFeedsEnabledChanged(enabled) {
            deviceDisplayManageFeedsButton.enabled = enabled;
            var ss = nodoControl.getScreenSaverType();
            if (enabled)
            {
                screenSaverComboBox.model = [qsTr("News"), qsTr("Analog Clock"), qsTr("Digital Clock"), qsTr("Display Off"), qsTr("None")];
                screenSaverComboBox.currentIndex = ss + 1;
            }
            else
            {
                screenSaverComboBox.model = [qsTr("Analog Clock"), qsTr("Digital Clock"), qsTr("Display Off"), qsTr("None")];
                screenSaverComboBox.currentIndex = ss - 1;
            }
        }
    }

    Rectangle {
        id: screenSaverStartAfterRect
        anchors.left: screenSaverRect.right
        anchors.top: deviceDisplayBrightnessRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.leftMargin: 25
        height: NodoSystem.nodoItemHeight

        NodoInputField {
            id: screenSaverStartAfterInput
            anchors.left: screenSaverStartAfterRect.left
            anchors.top: screenSaverStartAfterRect.top
            height: NodoSystem.nodoItemHeight
            width: itemSize + deviceDisplayNightModeSwitch.width
            itemSize: labelSize - 20
            itemText: qsTr("Start after")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 1; top: 60; }
            onTextEditFinished: {
                nodoControl.setScreenSaverTimeout(screenSaverStartAfterInput.valueText * 60)
            }
        }

        Rectangle {
            id: screenSaverStartAfterMinutesRect
            anchors.left: screenSaverStartAfterInput.right
            anchors.top: screenSaverStartAfterInput.top
            anchors.leftMargin: 10
            color: "black"

            Text {
                id: screenSaverStartAfterMinutes
                anchors.left: screenSaverStartAfterMinutesRect.left
                anchors.top: screenSaverStartAfterMinutesRect.top
                text: qsTr("minutes")
                height: NodoSystem.nodoItemHeight
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.inputFieldValueFontSize
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
            }
        }
    }

    Rectangle {
        id: deviceDisplayNightModeSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: screenSaverRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"
        width: deviceDisplayNightModeSwitchText.width + deviceDisplayNightModeSwitch.width

        NodoLabel {
            id: deviceDisplayNightModeSwitchText
            height: deviceDisplayNightModeSwitchRect.height
            anchors.left: deviceDisplayNightModeSwitchRect.left
            anchors.top: deviceDisplayNightModeSwitchRect.top
            width: labelSize
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
        anchors.left: deviceDisplayNightModeSwitchRect.right
        anchors.top: screenSaverRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.leftMargin: 25
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayFlipOrientationSwitchText
            height: deviceDisplayFlipOrientationSwitchRect.height
            anchors.left: deviceDisplayFlipOrientationSwitchRect.left
            anchors.top: deviceDisplayFlipOrientationSwitchRect.top
            width: labelSize - 20
            text: qsTr("Flip Display")
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
            width: labelSize
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
        id: keyboardLayoutRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: languageRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: keyboardLayoutLabel
            height: keyboardLayoutRect.height
            anchors.top: keyboardLayoutRect.top
            anchors.left: keyboardLayoutRect.left
            width: labelSize
            text: qsTr("Keyboard")
        }

        NodoComboBox {
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

    Rectangle {
        id: deviceDisplay24hTimeSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: keyboardLayoutRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"
        width: deviceDisplay24hTimeSwitchText.width + deviceDisplay24hTimeSwitch.width

        NodoLabel {
            id: deviceDisplay24hTimeSwitchText
            height: deviceDisplay24hTimeSwitchRect.height
            anchors.left: deviceDisplay24hTimeSwitchRect.left
            anchors.top: deviceDisplay24hTimeSwitchRect.top
            width: labelSize
            text: qsTr("24h Time")
        }

        NodoSwitch {
            id: deviceDisplay24hTimeSwitch
            anchors.left: deviceDisplay24hTimeSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceDisplay24hTimeSwitchRect.height
            width: 2*deviceDisplay24hTimeSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged:
                nodoControl.set24hEnabled(deviceDisplay24hTimeSwitch.checked);
        }
    }

    Rectangle {
        id: timezoneRect
        anchors.left: deviceDisplay24hTimeSwitchRect.right
        anchors.leftMargin: 25
        anchors.top: keyboardLayoutRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayTimezoneLabel
            height: timezoneRect.height
            anchors.top: timezoneRect.top
            anchors.left: timezoneRect.left
            anchors.rightMargin: NodoSystem.padding
            width: labelSize - 20
            text: qsTr("Time Zone")
        }

        NodoComboBox
        {
            id: deviceDisplayTimezoneComboBox
            anchors.left: deviceDisplayTimezoneLabel.right
            anchors.leftMargin: NodoSystem.padding
            anchors.top: deviceDisplayTimezoneLabel.top
            width: dropdownLength - deviceDisplay24hTimeSwitchRect.width - 5//dropdownLength
            height: timezoneRect.height
            currentIndex: nodoControl.getTimeZoneIndex()
            model: nodoTimezones.timezoneNames
            onCurrentIndexChanged: {
                nodoControl.setTimeZoneIndex(currentIndex)
            }
        }
    }

    Rectangle {
        id: deviceDisplayPricetickerSwitchRect
        anchors.left: deviceDisplayScreen.left
        anchors.top: timezoneRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"
        width: deviceDisplayPricetickerSwitchText.width + deviceDisplayPricetickerSwitch.width

        NodoLabel {
            id: deviceDisplayPricetickerSwitchText
            height: deviceDisplayPricetickerSwitchRect.height
            anchors.left: deviceDisplayPricetickerSwitchRect.left
            anchors.top: deviceDisplayPricetickerSwitchRect.top
            width: labelSize
            text: qsTr("Price Ticker")
        }

        NodoSwitch {
            id: deviceDisplayPricetickerSwitch
            anchors.left: deviceDisplayPricetickerSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceDisplayPricetickerSwitchRect.height
            width: 2*deviceDisplayPricetickerSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoControl.isTickerEnabled()
            onCheckedChanged: nodoControl.setTickerEnabled(deviceDisplayPricetickerSwitch.checked)
        }
    }

    Rectangle {
        id: currencyRect
        anchors.left: deviceDisplayPricetickerSwitchRect.right
        anchors.top: timezoneRect.bottom
        anchors.leftMargin: 25
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceDisplayCurrencyLabel
            height: currencyRect.height
            anchors.top: currencyRect.top
            anchors.left: currencyRect.left
            anchors.rightMargin: NodoSystem.padding
            width: labelSize - 20
            text: qsTr("Currency")

        }

        NodoComboBox
        {
            id: deviceDisplayCurrencyComboBox
            anchors.left: deviceDisplayCurrencyLabel.right
            anchors.leftMargin: NodoSystem.padding
            anchors.top: deviceDisplayCurrencyLabel.top
            width: dropdownLength - deviceDisplayPricetickerSwitchRect.width - 5
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
        id: deviceDisplayFeedsSwitchRect
        anchors.left: deviceDisplayScreen.left
        //anchors.leftMargin: 30
        anchors.top: deviceDisplayPricetickerSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"
        width: deviceDisplayFeedsSwitchText.width + deviceDisplayFeedsSwitch.width

        NodoLabel {
            id: deviceDisplayFeedsSwitchText
            height: deviceDisplayFeedsSwitchRect.height
            anchors.left: deviceDisplayFeedsSwitchRect.left
            anchors.top: deviceDisplayFeedsSwitchRect.top
            width: labelSize
            text: qsTr("News Feeds")
        }

        NodoSwitch {
            id: deviceDisplayFeedsSwitch
            anchors.left: deviceDisplayFeedsSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceDisplayFeedsSwitchRect.height
            width: 2*deviceDisplayFeedsSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoControl.isFeedsEnabled()
            onCheckedChanged: nodoControl.setFeedsEnabled(deviceDisplayFeedsSwitch.checked)
        }

        NodoButton  {
            id: deviceDisplayManageFeedsButton
            anchors.left: deviceDisplayFeedsSwitchRect.right
            anchors.leftMargin: 25
            anchors.top: deviceDisplayPricetickerSwitchRect.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            height: NodoSystem.nodoItemHeight
            //width: 320
            text: qsTr("Manage Feeds")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            enabled: nodoControl.isFeedsEnabled()
            onClicked: { pageLoader.source = "DeviceNewsFeedsScreen.qml" }
        }
    }
}
