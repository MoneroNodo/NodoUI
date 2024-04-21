import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Rectangle {
    id: deviceSystemScreen
    anchors.fill: parent
    color: "black"
    property int buttonTopMargin: 32

        NodoButton {
            id: systemResetButton
            anchors.left: deviceSystemScreen.left
            anchors.top: deviceSystemScreen.top
            text: qsTr("Restart")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            onClicked: {
                nodoControl.restartDevice();
            }
        }

        NodoButton {
            id: systemShutdownButton
            anchors.left: deviceSystemScreen.left
            anchors.top: systemResetButton.bottom
            anchors.topMargin: buttonTopMargin
            text: qsTr("Shutdown")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            onClicked: {
                nodoControl.shutdownDevice();
            }
        }

        NodoButton {
            id: systemRecoveryButton
            anchors.left: deviceSystemScreen.left
            anchors.top: systemShutdownButton.bottom
            anchors.topMargin: buttonTopMargin
            text: qsTr("Recovery")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            backgroundColor:  nodoControl.appTheme ? "#F50000" : "#F50000"
            onClicked: {
                pageLoader.source = "DeviceSystemRecoveryScreen.qml"
            }
        }

    Loader {
        id: pageLoader
        anchors.top: deviceSystemScreen.top
        anchors.left: deviceSystemScreen.left
        anchors.right: deviceSystemScreen.right
        anchors.bottom: deviceSystemScreen.bottom
    }
}
