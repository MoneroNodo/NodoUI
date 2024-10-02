import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Rectangle {
    id: devicePinScreen
    anchors.fill: parent
    property bool isLockPinEnabled: false
    color: "black"

    Component.onCompleted: {
        isLockPinEnabled = nodoControl.isLockPinEnabled()

        if(isLockPinEnabled)
        {
            devicePinScreenStackView.push("NodoLockScreen.qml", {parentID: 1})
        }
        else
        {
            devicePinScreenStackView.push("NodoAddressPinControlScreen.qml")
        }
    }

    Connections{
        target: devicePinScreenStackView.currentItem
        function onDeleteMe(screenID) {
            devicePinScreenStackView.pop()
            devicePinScreenStackView.push("NodoAddressPinControlScreen.qml")
        }

    }

    Connections{
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(errorCode === 9)
            {
                devicePinScreenStackView.pop()
                devicePinScreenStackView.push("NodoLockScreen.qml", {parentID: 1})
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

