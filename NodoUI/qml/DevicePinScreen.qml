import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: devicePinScreen
    anchors.fill: parent

    property int labelSize: 0
    property int buttonTopMargin: 32

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceLockPinSettingsButton.buttonWidth > labelSize)
            labelSize = deviceLockPinSettingsButton.buttonWidth

        if(deviceAddressPinSettingsButton.buttonWidth > labelSize)
            labelSize = deviceAddressPinSettingsButton.buttonWidth
    }

    NodoButton {
        id: deviceLockPinSettingsButton
        anchors.left: devicePinScreen.left
        anchors.top: devicePinScreen.top
        text: qsTr("Lock PIN Settings")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        width: labelSize
        onClicked: {
            onClicked: { pageLoader.source = "DeviceLockPinScreen.qml" }
        }
    }

    NodoButton {
        id: deviceAddressPinSettingsButton
        anchors.left: devicePinScreen.left
        anchors.top: deviceLockPinSettingsButton.bottom
        anchors.topMargin: devicePinScreen.buttonTopMargin
        text: qsTr("Address PIN Settings")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        width: labelSize
        onClicked: {
            onClicked: { pageLoader.source = "DeviceAddressPinScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: devicePinScreen.top
        anchors.left: devicePinScreen.left
        anchors.right: devicePinScreen.right
        anchors.bottom: devicePinScreen.bottom
        anchors.topMargin: 0
    }
}

