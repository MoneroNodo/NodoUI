import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: rebootScreen
    anchors.leftMargin: 20

    property int labelSize: 0
    property int inputFieldWidth: 900
    property bool inputFieldReadOnly: false
    signal openNextScreen(int screenID)


    Rectangle {
        id: rebootRect
        anchors.fill: parent
        color: "black"
        anchors.leftMargin: 20

        Rectangle {
            id: banner
            anchors.top: rebootRect.top
            anchors.left: rebootRect.left
            anchors.right: rebootRect.right
            height: 140
            color: "black"
            Text {
                text: qsTr("Nodo will now reboot.")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.textFontSize
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                width: banner.width
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            }
        }
    }

    Timer {
        id: rebootScreenTimer
        interval: 3000; running: true; repeat: false
        onTriggered: nodoControl.restartDevice();
    }
}
