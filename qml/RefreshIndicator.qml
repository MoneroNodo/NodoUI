/*
MIT License

Copyright (c) 2020 Mohammad Hasanzadeh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*
RefreshIndicator code used here is from https://github.com/mohammadhasanzadeh/pulltorefreshhandler
*/


import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Shapes 1.12
import NodoSystem 1.1

Pane
{
    id: control
    width: 32
    height: 32
    padding: 0
    x: (handler.width - width) / 2
    y: (dragProgress > 100) ? 100 : dragProgress
    Material.elevation: 2
    background: Rectangle {
        id: backgroud_rect
        color: "#80808080"
        radius: width / 2
        layer.enabled: control.enabled && control.Material.elevation > 0
    }

    Shape
    {
        id: shape
        anchors.fill: parent
        asynchronous: true
        antialiasing: true
        smooth: true
        opacity: (dragProgress < 50) ? 0.5 : 1

        ShapePath
        {
            id: shape_path
            strokeWidth: 3
            strokeColor: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            startX: 24
            startY: 16
            fillColor: "transparent"

            PathAngleArc
            {
                centerX: 16
                centerY: 16
                radiusX: 8
                radiusY: 8
                startAngle: -20
                sweepAngle: (dragProgress < 50) ? (dragProgress * 280) / 50 : 280
            }
        }

        rotation:
        {
             if (dragProgress >= 100)
                 return rotation;
             if (dragProgress >= 50 && dragProgress <= 100)
                return ((dragProgress - 50) * 200) / 50;
             return 0;
        }
    }
}
