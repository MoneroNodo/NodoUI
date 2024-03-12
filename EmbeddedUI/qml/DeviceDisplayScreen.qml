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
        width: 470
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
        anchors.leftMargin: 75
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
        width: 470
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 32
        model: translator.languages
        displayText: translator.languageByCode(translator.currentLanguage)

        delegate: ItemDelegate {
            id: languageRect
            property string code: modelData
            width: deviceDisplayLanguageComboBox.width

            contentItem: Text {
                text: translator.languageByCode(code)
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
                font: deviceDisplayLanguageComboBox.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: code === translator.currentLanguage
            onClicked: translator.selectLanguage(languageRect.code)
        }
    }

}
