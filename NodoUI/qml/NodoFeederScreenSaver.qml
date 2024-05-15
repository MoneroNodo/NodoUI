import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: feederScreenSaver
    width: parent.width
    height: parent.height
    NewsMainScreen{
        x: 0
        y: 0
        width: feederScreenSaver.width
        height: feederScreenSaver.height
        isScreenSaver: true
    }
}
