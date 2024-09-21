import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: factoryResetScreen
    signal deleteMe(int screenID)

    Connections {
        target: nodoControl
        function onFactoryResetStarted()
        {
            console.log("FactoryResetStarted")
            resetStatusText.text = systemMessages.messages[NodoMessages.Message.FactoryResetStarted]
        }

        function onFactoryResetCompleted()
        {
            console.log("FactoryResetCompleted")
            resetStatusText.text = systemMessages.messages[NodoMessages.Message.FactoryResetCompleted]
        }
    }

    Image {
        id: img
        anchors.top: factoryResetScreen.top
        anchors.left: factoryResetScreen.left
        anchors.topMargin: 3
        anchors.leftMargin: 10
        source: (nodoControl.appTheme ? "qrc:/Images/nodologo_title_red.png" : "qrc:/Images/nodologo_title_white.png")
        fillMode: Image.PreserveAspectFit
    }


    Rectangle {
        id: resetStatusRect
        anchors.top: img.bottom
        anchors.topMargin: 170
        anchors.left: factoryResetScreen.left
        anchors.leftMargin: 20
        anchors.right: factoryResetScreen.right
        height: 180
        color: "black"
        Text {
            id: resetStatusText
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            width: resetStatusRect.width
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
        }
    }
}

