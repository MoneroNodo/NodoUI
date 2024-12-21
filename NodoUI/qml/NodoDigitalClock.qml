import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: digitalClock
    width: 1920
    height: 1080
    property int clockTopMargin: -50
    property int seperatorTopMargin: -150

    property int seperatorTimerCounter: 0

    property real hours: 10
    property real minutes: 10

    signal deleteMe(int screenID)

    function timeChanged() {
        var date = nodoControl.getChangedDateTime();

        minutes =  date.getMinutes()
        hours = date.getHours()
        if(hours > 12)
        {
            hours = hours - 12
        }

        digitalClockDate.text = Qt.formatDateTime(date, "dddd, d MMMM yyyy")
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true
        running: true

        onTriggered:
        {
            onTriggered: digitalClock.timeChanged()
        }
    }

    Timer {
        id: seperatorTimer
        interval: 250
        repeat: true
        running: true
        onTriggered:
        {
            seperatorTimerCounter++

            switch(seperatorTimerCounter)
            {
            case 2:
                digitalClockSeperator.visible = false
                break;

            case 5:
                digitalClockSeperator.visible = true
                seperatorTimerCounter = 0
                break;
            }
        }
    }

    Component.onCompleted: {
        timeChanged()
    }

    Rectangle {
        id: digitalClockBackground
        anchors.fill: parent
        color: "black"

        Rectangle {
            id: digitalClockDateBackground;
            anchors.horizontalCenter: parent.horizontalCenter
            width: digitalClockHour.paintedWidth + digitalClockSeperator.paintedWidth + digitalClockMinute.paintedWidth
            height: digitalClock.height*0.75
            color: "black"

            Text {
                id: digitalClockHour
                antialiasing: true
                anchors.top: digitalClockDateBackground.top
                anchors.left: digitalClockDateBackground.left
                anchors.topMargin: clockTopMargin
                text: hours == 0 ? "12" : hours
                font.pixelSize: NodoSystem.digitalClockPixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontInter.name
            }

            Text {
                id: digitalClockSeperator
                anchors.left: digitalClockHour.right
                anchors.top: digitalClockDateBackground.top
                height: digitalClockDateBackground.height
                anchors.topMargin: seperatorTopMargin
                text: ":"
                font.pixelSize: NodoSystem.digitalClockPixelSize
                verticalAlignment: Text.AlignTop
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontInter.name
            }

            Text {
                id: digitalClockMinute
                anchors.top: digitalClockDateBackground.top
                anchors.left: digitalClockSeperator.right
                anchors.topMargin: clockTopMargin
                text: minutes < 10 ? "0"+minutes : minutes
                font.pixelSize: NodoSystem.digitalClockPixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontInter.name
            }
        }

        Text {
            id: digitalClockDate
            //anchors.left: digitalClockBackground.left
            anchors.top: digitalClockDateBackground.bottom
            anchors.horizontalCenter: digitalClockBackground.horizontalCenter
            //anchors.leftMargin: 50
            width: 800
            height: 200
            text: Qt.formatDateTime(nodoControl.getChangedDateTime(), "dddd, d MMMM yyyy")
            font.pixelSize: 70
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontInter.name
        }
    }

}
