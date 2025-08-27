import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: analogClockClassic
    width: 1920
    height: 1080

    property real hours: 10
    property real minutes: 10
    property real seconds: 30
    property real miliseconds: 0

    property real hourAngle
    property real minuteAngle
    property real secondAngle

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

        hourAngle_classic = (hours * 30)
        minuteAngle_classic = (minutes*6)
        secondAngle_classic = seconds*6
    }

    Timer {
        interval: 25; running: true; repeat: true;
        onTriggered: analogClockClassic.timeChanged()
    }

    Rectangle {
        id: background_classic;
        anchors.centerIn: parent
        width: analogClockClassic.width
        height: analogClockClassic.height
        color: "black"

        Component.onCompleted: {
            timeChanged()
        }

        Image {
            id: clock_face_image_classic
            x: 0
            y: 0
            width: parent.width
            height: parent.height

            source: (nodoControl.appTheme ? "qrc:/Images/Nodo_AnalogClassic_Red.png" : "qrc:/Images/Nodo_AnalogClassic_White.png")
            antialiasing: true
            fillMode: Image.PreserveAspectFit
        }


        Image {
            id: hour_image_classic
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
                angle: analogClockClassic.hourAngle
            }
        }

        Image {
            id: minute_image_classic
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
                angle: analogClockClassic.minuteAngle
            }
        }

        Image {
            id: second_image_classic
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
                angle: analogClockClassic.secondAngle
            }
        }
    }
}
