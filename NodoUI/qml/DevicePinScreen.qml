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
    property int inputFieldWidth: 600
    property int defaultHeight: 64
    property bool pinFieldReadOnly: false
    property bool isPinEnabled: false

    Component.onCompleted: {
        isPinEnabled = nodoControl.isPinEnabled()

        if(isPinEnabled)
        {
            devicePinScreenStackView.push("NodoLockScreen.qml")
        }
        else
        {
            devicePinScreenStackView.push("NodoPinControlScreen.qml")
        }
    }

    Connections{
        target: devicePinScreenStackView.currentItem
        function onPinCodeCorrect() {
            devicePinScreenStackView.pop()
            devicePinScreenStackView.push("NodoPinControlScreen.qml")
        }
    }

    Connections{
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(errorCode === 9)
            {
                devicePinScreenStackView.pop()
                devicePinScreenStackView.push("NodoLockScreen.qml")
            }
        }
    }


    StackView {
        id: devicePinScreenStackView
        anchors.fill: devicePinScreen

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 0
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 0
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 0
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 0
            }
        }
    }
}

