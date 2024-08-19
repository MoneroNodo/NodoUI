import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

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
                deviceSystemPopup.commandID = 0;
                deviceSystemPopup.applyButtonText = systemResetButton.text
                deviceSystemPopup.open();
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
                deviceSystemPopup.commandID = 1;
                deviceSystemPopup.applyButtonText = systemShutdownButton.text
                deviceSystemPopup.open();
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
        property int checkBoxMargin: 0

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
                    deviceSystemPopup.commandID = 2;
                    deviceSystemPopup.applyButtonText = qsTr("Recover")
                    deviceSystemPopup.open();
                }
            }

            NodoButton {
                id: systemRecoveryCancelButton
                anchors.left: systemRecoveryStartButton.right
                anchors.top: systemRecoveryStartButton.top
                anchors.leftMargin: 16
                text: systemMessages.messages[NodoMessages.Message.Cancel]
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
    NodoPopup {
        id: deviceSystemPopup
        onApplyClicked: {
            if(commandID === 0)
            {
                nodoControl.restartDevice();
            }
            else if(commandID === 1)
            {
                nodoControl.shutdownDevice();
            }
            else if(commandID === 2)
            {
                nodoControl.systemRecovery(deviceSystemRecoveryRecoverFS.checked, deviceSystemRecoveryResyncBlockchain.checked);
            }
            close()
        }
    }
}
