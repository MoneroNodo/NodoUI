import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: deviceNewsFeedsScreen
    anchors.fill: parent
/*
    Rectangle {
        id: deviceNewsFeedsUseNewsSwitchRect
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeedsScreen.top
        height: 60

        NodoSwitch {
            id: deviceNewsFeedsUseNewsSwitch
            x: 0
            y: 0
            width: 80
            height: parent.height*0.66
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoControl.getScreenSaverType()

            onCheckedChanged: {
                nodoControl.setScreenSaverType(checked)
            }
        }

        Text{
            id: deviceNewsFeedsUseNewsSwitchText
            x: deviceNewsFeedsUseNewsSwitch.width + 10
            y: (deviceNewsFeedsUseNewsSwitch.height - deviceNewsFeedsUseNewsSwitchText.height)/2
            width: deviceNewsFeedsUseNewsSwitchText.paintedWidth
            height: deviceNewsFeedsUseNewsSwitchText.paintedHeight
            text: "Use news feeds as screen saver"
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }
    }
    */

    Label {
        id: deviceNewsFeedsIncludeFeedsLabel
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeedsScreen.top
        // anchors.topMargin: 10
        width: 100
        height: 38
        text: qsTr("Include these feeds:")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }


    NodoFeedsSwitch {
        id: deviceNewsFeed0Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeedsIncludeFeedsLabel.bottom
        index: 0
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed1Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed0Rect.bottom
        index: 1
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed2Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed1Rect.bottom
        index: 2
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed3Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed2Rect.bottom
        index: 3
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed4Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed3Rect.bottom
        index: 4
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed5Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed4Rect.bottom
        index: 5
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed6Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed5Rect.bottom
        index: 6
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed7Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed6Rect.bottom
        index: 7
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed8Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed7Rect.bottom
        index: 8
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed9Rect
        anchors.left: deviceNewsFeedsUseNewsSwitchRect.left
        anchors.top: deviceNewsFeed8Rect.bottom
        index: 9
    }
}
