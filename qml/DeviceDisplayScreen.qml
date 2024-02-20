import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
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
        width: 100
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
        height: 51
        snapMode: Slider.NoSnap
        stepSize: 1
        from: 1
        value: 25
        to: 100
        handleHight: 50
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
            text:  qsTr("")
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
            text: "Night mode"
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

            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: false
        }

        Text{
            id: deviceDisplayFlipOrientationSwitchText

            anchors.left: deviceDisplayFlipOrientationSwitchRect.right
            anchors.leftMargin: 16
            y: (deviceDisplayFlipOrientationSwitchRect.height - deviceDisplayFlipOrientationSwitchText.height)/2
            text: "Flip Orientation"
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
        width: 370
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: 40
        currentIndex: nodoControl.getScreenSaverType()
        model: ["News Carousel", "Analog Clock", "Off"]
        onCurrentIndexChanged: {
            nodoControl.setScreenSaverType(currentIndex)
        }
    }
}
