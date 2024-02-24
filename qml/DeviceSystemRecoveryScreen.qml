import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Rectangle {
    id: deviceSystemRecoveryScreen
    color: "black"
    anchors.fill: parent

    NodoCheckBox
    {
        id: deviceSystemRecoveryRecoverFS
        anchors.left: deviceSystemRecoveryScreen.left
        anchors.top: deviceSystemRecoveryScreen.top
        checkBoxText: qsTr("Attempt to recover filesystem")
    }

    NodoCheckBox
    {
        id: deviceSystemRecoveryResyncBlockchain
        anchors.left: deviceSystemRecoveryScreen.left
        anchors.top: deviceSystemRecoveryRecoverFS.bottom
        anchors.topMargin: 32
        checkBoxText: qsTr("Purge and resync blockchain")
    }

    NodoButton {
        id: systemRecoveryStartButton
        anchors.left: deviceSystemRecoveryScreen.left
        anchors.top: deviceSystemRecoveryResyncBlockchain.bottom
        anchors.topMargin: 15
        text: qsTr("Start")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
        onClicked: {

        }
    }

    NodoButton {
        id: systemRecoveryCancelButton
        anchors.left: systemRecoveryStartButton.right
        anchors.top: systemRecoveryStartButton.top
        anchors.leftMargin: 15
        text: qsTr("Cancel")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
        onClicked: {
            pageLoader.source = "DeviceSystemScreen.qml"
        }
    }

    Loader {
        id: pageLoader
        anchors.top: deviceSystemRecoveryScreen.top
        anchors.left: deviceSystemRecoveryScreen.left
        anchors.right: deviceSystemRecoveryScreen.right
        anchors.bottom: deviceSystemRecoveryScreen.bottom
    }
}
