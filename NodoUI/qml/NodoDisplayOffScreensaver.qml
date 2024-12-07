import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: displayOff
    width: 1920
    height: 1080
    
    Rectangle {
        id: displayOffBackground
        anchors.fill: parent
        color: "black"
    }
}
