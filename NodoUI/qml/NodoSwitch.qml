import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Switch {
    id: control

    indicator: NodoCanvas {
        id: background
        height: control.height
        width: control.width

        y: (parent.height  - height) / 2

        color: {
            if(control.checked)
            {
                if(nodoControl.appTheme)
                {
                    NodoSystem.highlightedColorNightModeOn
                }
                else
                {
                    NodoSystem.highlightedColorNightModeOff
                }
            }
            else
            {
                NodoSystem.switchBackgroundColor
            }
        }
        opacity: control.enabled ? 1.0 : 0.6

        NodoCanvas {
            id: knob
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
            PropertyChanges { target: background; color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff}
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
