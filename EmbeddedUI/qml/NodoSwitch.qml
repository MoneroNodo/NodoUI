import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Switch {
    id: control

    indicator: NodoCanvas {
        id: background
        height: control.height
        width: control.width

        y: (parent.height  - height) / 2

        color: control.checked ? (nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff) : NodoSystem.switchBackgroundColor
        NodoCanvas {
            id: knob
            cornerColor: background.color
            x: control.checked ? control.width - control.height*0.9 : control.height*0.1
            y: (control.height - height) / 2
            width: parent.height*0.8
            height: parent.height*0.8
            color: "white"
        }
    }

    onCheckedChanged: {
        if(checked == true)
        {
            control.state = "on"
        }
        else
        {
            control.state = "off"
        }
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: background; color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff }
            PropertyChanges { target: knob; x: control.width - control.height*0.9 }
            PropertyChanges { target: control; checked: true }
        },
        State {
            name: "off"
            PropertyChanges { target: background; color: NodoSystem.switchBackgroundColor }
            PropertyChanges { target: knob; x: control.height*0.1 }
            PropertyChanges { target: control; checked: false }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
        ColorAnimation { duration: 250 }
    }
}
