import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import NodoSystem 1.1

Item {
    id: feederScreenSaver
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    NewsMainScreen{
        x: 0
        y: 0
        width: feederScreenSaver.width
        height: feederScreenSaver.height
        isScreenSaver: true
    }
}
