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
            width: labelSize
            height: deviceSystemRecoveryRecoverFS.height
            anchors.left: deviceSystemRecoveryRecoverFS.right
            anchors.leftMargin: checkBoxMargin
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
            width: labelSize
            height: deviceSystemRecoveryResyncBlockchain.height
            anchors.left: deviceSystemRecoveryResyncBlockchain.right
            anchors.leftMargin: checkBoxMargin
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
