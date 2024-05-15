import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import NodoCanvas 1.0

/*
slider drag bugfix:
https://het.as.utexas.edu/HET/Software/html/demos-declarative-flickr-qml-flickr-common-slider-qml.html
*/

Slider {
    id: control
    value: 0.5
    property int handleHight: 20
    property int handleWidth: 20
    property int handlePadding: 6

    onValueChanged: updatePos();
    property int xMax: width - handle.width - (2*handlePadding)
    onXMaxChanged: updatePos();

    function updatePos() {
        if (control.to > control.from) {
            var pos = handlePadding + (value - control.from) * control.xMax / (control.to - control.from);
            pos = Math.min(pos, width - handle.width - handlePadding);
            pos = Math.max(pos, handlePadding);
            handle.x = pos;
        } else {
            handle.x = handlePadding;
        }
    }

    background: NodoCanvas {
        id: sliderBackground
        x: 0
        y: 0
        width: control.width
        height: control.height
        color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
    }

    handle: NodoCanvas {
        id: sliderHandle
        // cornerColor: sliderBackground.color
        x: control.visualPosition * (control.width - width)
        y: control.height / 2 - height / 2
        width: handleWidth
        height: handleHight
        color: "#ffffff"

        MouseArea {
            id: mouse
            anchors.fill: parent; drag.target: parent
            drag.axis: Drag.XAxis; drag.minimumX: handlePadding; drag.maximumX: control.width - handle.width - handlePadding
            onPositionChanged: { value = (control.to - control.from) * (handle.x-handlePadding) / control.xMax + control.from; }
        }
    }
}
