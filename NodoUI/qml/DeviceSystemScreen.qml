import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Rectangle {
    id: deviceSystemMainScreen
    anchors.fill: parent
    color: "black"

    Rectangle {
        id: deviceSystemScreen
        anchors.fill: parent
        property int buttonTopMargin: 32
        color: "black"
        visible: true

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
            anchors.topMargin: deviceSystemScreen.buttonTopMargin
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
            anchors.topMargin: deviceSystemScreen.buttonTopMargin
            text: qsTr("Recovery")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            backgroundColor:  nodoControl.appTheme ? "#F50000" : "#F50000"
            onClicked: {
                deviceSystemScreen.visible = false
                deviceSystemRecoveryMainScreen.visible = true
            }
        }
    }

    Rectangle {
        id: deviceSystemRecoveryMainScreen
        anchors.fill: parent
        color: "black"
        visible: false

        property int labelSize: 0
        property int checkBoxMargin: 5

        Component.onCompleted: {
            onCalculateMaximumTextLabelLength()
        }

        function onCalculateMaximumTextLabelLength() {
            if(deviceSystemRecoveryRecoverFSText.labelRectRoundSize > labelSize)
            labelSize = deviceSystemRecoveryRecoverFSText.labelRectRoundSize

            if(deviceSystemRecoveryResyncBlockchainText.labelRectRoundSize > labelSize)
            labelSize = deviceSystemRecoveryResyncBlockchainText.labelRectRoundSize
        }


        Rectangle {
            id: deviceSystemRecoveryScreen
            color: "black"
            anchors.fill: parent
            Rectangle {
                id: deviceSystemRecoveryScreenRect
                anchors.left: deviceSystemRecoveryScreen.left
                anchors.top: deviceSystemRecoveryScreen.top
                height: NodoSystem.nodoItemHeight
                color: "black"

                NodoCheckBox
                {
                    id: deviceSystemRecoveryRecoverFS
                    height: deviceSystemRecoveryScreenRect.height
                    width: height
                    anchors.left: deviceSystemRecoveryScreenRect.left
                    anchors.top: deviceSystemRecoveryScreenRect.top
                }

                NodoLabel{
                    id: deviceSystemRecoveryRecoverFSText
                    width: deviceSystemRecoveryMainScreen.labelSize
                    height: deviceSystemRecoveryRecoverFS.height
                    anchors.left: deviceSystemRecoveryRecoverFS.right
                    anchors.leftMargin: deviceSystemRecoveryMainScreen.checkBoxMargin
                    text: qsTr("Attempt to recover filesystem")
                }
            }

            Rectangle {
                id: deviceSystemRecoveryResyncBlockchainRect
                anchors.left: deviceSystemRecoveryScreen.left
                anchors.top: deviceSystemRecoveryScreenRect.bottom
                anchors.topMargin: NodoSystem.nodoTopMargin
                height: NodoSystem.nodoItemHeight
                color: "black"

                NodoCheckBox
                {
                    id: deviceSystemRecoveryResyncBlockchain
                    height: deviceSystemRecoveryResyncBlockchainRect.height
                    width: height
                    anchors.left: deviceSystemRecoveryResyncBlockchainRect.left
                    anchors.top: deviceSystemRecoveryResyncBlockchainRect.top
                }

                NodoLabel{
                    id: deviceSystemRecoveryResyncBlockchainText
                    width: deviceSystemRecoveryMainScreen.labelSize
                    height: deviceSystemRecoveryResyncBlockchain.height
                    anchors.left: deviceSystemRecoveryResyncBlockchain.right
                    anchors.leftMargin: deviceSystemRecoveryMainScreen.checkBoxMargin
                    text: qsTr("Purge and resync blockchain")
                }
            }

            NodoButton {
                id: systemRecoveryStartButton
                anchors.left: deviceSystemRecoveryScreen.left
                anchors.top: deviceSystemRecoveryResyncBlockchainRect.bottom
                anchors.topMargin: 80
                text: qsTr("Start")
                height: NodoSystem.nodoItemHeight
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.buttonTextFontSize
                onClicked: {
                    nodoControl.systemRecovery(deviceSystemRecoveryRecoverFS.checked, deviceSystemRecoveryResyncBlockchain.checked);
                }
            }

            NodoButton {
                id: systemRecoveryCancelButton
                anchors.left: systemRecoveryStartButton.right
                anchors.top: systemRecoveryStartButton.top
                anchors.leftMargin: 16
                text: qsTr("Cancel")
                height: NodoSystem.nodoItemHeight
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.buttonTextFontSize
                onClicked: {
                    deviceSystemScreen.visible = true
                    deviceSystemRecoveryMainScreen.visible = false
                }
            }
        }
    }
}
