import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Shapes 1.15
import NodoSystem 1.1

Rectangle {
    id: canvas
    color: canvas.color
    property color cornerColor: "black"
    property int rectangleWidth: 11
    property int rectangleHeight: 8
    antialiasing: true

    Shape {
        x: 0
        y: 0
        width: rectangleWidth
        height: rectangleHeight
	antialiasing: true
        ShapePath {
            strokeWidth: 0
            strokeColor: cornerColor
            fillColor: cornerColor
            startX: 0; startY: 0
            PathLine { x: 0; y: rectangleHeight}
            PathLine { x: rectangleWidth; y: 0}
        }
    }

    Shape {
        x: canvas.width - rectangleWidth
        y: 0
        width: rectangleWidth
        height: rectangleHeight
	antialiasing: true
        ShapePath {
            strokeWidth: 0
            strokeColor: cornerColor
            fillColor: cornerColor
            startX: 0; startY: 0
            PathLine { x: rectangleWidth; y: 0}
            PathLine { x: rectangleWidth; y: rectangleHeight}
        }
    }

    Shape {
        x: 0
        y: canvas.height - rectangleHeight
        width: rectangleWidth
        height: rectangleHeight
	antialiasing: true
        ShapePath {
            strokeWidth: 0
            strokeColor: cornerColor
            fillColor: cornerColor
            startX: 0; startY: 0
            PathLine { x: 0; y: rectangleHeight}
            PathLine { x: rectangleWidth; y: rectangleHeight}
        }
    }

    Shape {
        x: canvas.width -rectangleWidth
        y: canvas.height - rectangleHeight
        width: rectangleWidth
        height: rectangleHeight
	antialiasing: true
        ShapePath {
            strokeWidth: 0
            strokeColor: cornerColor
            fillColor: cornerColor
            startX: rectangleWidth; startY: 0
            PathLine { x: rectangleWidth; y: rectangleHeight}
            PathLine { x: 0; y: rectangleHeight}
        }
    }
}

