import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Rectangle {
    id: deviceSystemScreen
    anchors.fill: parent
    color: "black"

        NodoButton {
            id: systemResetButton
            anchors.left: deviceSystemScreen.left
            anchors.top: deviceSystemScreen.top
            text: qsTr("Restart")
            height: 38
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            textLeftPadding: 15
            textRightPadding: 15
            frameRadius: 4
        }

        NodoButton {
            id: systemShutdownButton
            anchors.left: deviceSystemScreen.left
            anchors.top: systemResetButton.bottom
            anchors.topMargin: 20
            text: qsTr("Shutdown")
            height: 38
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            textLeftPadding: 25
            textRightPadding: 25
            frameRadius: 4
        }

        NodoButton {
            id: systemRecoveryButton
            anchors.left: deviceSystemScreen.left
            anchors.top: systemShutdownButton.bottom
            anchors.topMargin: 20
            text: qsTr("Recovery")
            height: 38
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            textLeftPadding: 15
            textRightPadding: 15
            backgroundColor:  nodoControl.appTheme ? "#F50000" : "#F50000"
            frameRadius: 4
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
