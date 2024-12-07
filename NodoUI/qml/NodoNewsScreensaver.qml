import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: feederScreenSaver
    signal deleteMe(int screenID)

    NewsMainScreen{
        x: 0
        y: 0
        width: feederScreenSaver.width
        height: feederScreenSaver.height
        isScreenSaver: true
    }
}
