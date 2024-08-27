import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: clock
    width: 1920
    height: 1080

    property real hours: 10
    property real minutes: 10
    property real seconds: 30
    property real miliseconds: 0


    property real hourAngle
    property real minuteAngle
    property real secondAngle

    property string dateString
    property string dayString

    property real hour_center_x_position: 23 // image width/2
    property real hour_center_y_position: 310 // rotational center of the handle

    property real minute_center_x_position: 17 // image width/2
    property real minute_center_y_position: 420 // rotational center of the handle

    property real second_center_x_position: 12// image width/2
    property real second_center_y_position: 476 // rotational center of the handle

    signal deleteMe(int screenID)

    function timeChanged() {
        var date = nodoControl.getChangedDateTime();

        miliseconds = date.getUTCMilliseconds()
        seconds = date.getUTCSeconds() + (miliseconds/1000);
        minutes =  date.getMinutes() + (seconds/60)
        hours = (date.getHours()) + (minutes/60)

        hourAngle = (hours * 30)
        minuteAngle = (minutes*6)
        secondAngle = seconds*6

        dayString = Qt.formatDateTime(nodoControl.getChangedDateTime(), "ddd ")
        dateString = Qt.formatDateTime(nodoControl.getChangedDateTime(), "d")
    }

    Timer {
        interval: 25; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }

    Rectangle {
        id: background;
        anchors.centerIn: parent
        width: clock.width
        height: clock.height
        color: "black"

        Component.onCompleted: {
            timeChanged()
        }

        Image {
            id: clock_face_image
            x: 0
            y: 0
            width: parent.width
            height: parent.height

            source: (nodoControl.appTheme ? "qrc:/Images/Nodo_ClockFace_Red.png" : "qrc:/Images/Nodo_ClockFace_White.png")
            antialiasing: true
            fillMode: Image.PreserveAspectFit
        }


        Image {
            id: hour_image
            x: (background.width/2) - (hour_center_x_position)
            y:  (background.height/2) - (hour_center_y_position);
            z: 1
            source: (nodoControl.appTheme ? "qrc:/Images/HourHand_Red.png" : "qrc:/Images/HourHand_White.png")
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                id: hourRotation
                origin.x: hour_center_x_position
                origin.y: hour_center_y_position
                angle: clock.hourAngle
            }
        }

        Image {
            id: minute_image
            x: (background.width/2) - (minute_center_x_position)
            y:  (background.height/2) - (minute_center_y_position);
            z: 5
            source: (nodoControl.appTheme ? "qrc:/Images/MinuteHand_Red.png" : "qrc:/Images/MinuteHand_White.png")
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                id: minuteRotation
                origin.x: minute_center_x_position
                origin.y: minute_center_y_position
                angle: clock.minuteAngle
            }
        }

        Image {
            id: second_image
            x: (background.width/2) - (second_center_x_position)
            y:  (background.height/2) - (second_center_y_position);
            z: 10
            source: (nodoControl.appTheme ? "qrc:/Images/SecondHand_Red.png" : "qrc:/Images/SecondHand_White.png")
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                id: secondRotation
                origin.x: second_center_x_position
                origin.y: second_center_y_position
                angle: clock.secondAngle
            }
        }

        Text {
            id: dateText
            anchors.right: background.right
            anchors.rightMargin: 400
            anchors.verticalCenter: background.verticalCenter
            color: nodoControl.appTheme ? NodoSystem.dateTextColorNightModeOn : NodoSystem.dateTextColorNightModeOff
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.dateTimeFontSize
            text: dateString.toUpperCase()
        }

        Text {
            id: dayText
            anchors.right: dateText.left
            anchors.verticalCenter: background.verticalCenter
            color: nodoControl.appTheme ? NodoSystem.dayTextColorNightModeOn : NodoSystem.dayTextColorNightModeOff
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.dateTimeFontSize
            text: dayString.toUpperCase()
        }
    }
}
