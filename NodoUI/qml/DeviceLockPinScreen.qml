import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Rectangle {
    id: deviceLockPinScreen
    anchors.fill: parent

    property bool isLockPinEnabled: false
    color: "black"

    Component.onCompleted: {
        isLockPinEnabled = nodoControl.isLockPinEnabled()

        if(isLockPinEnabled)
        {
            deviceLockPinScreenStackView.push("NodoLockScreen.qml", {parentID: 0})
        }
        else
        {        
            deviceLockPinScreenStackView.push("NodoLockScreen.qml")
        }
    }

    Connections{
        target: deviceLockPinScreenStackView.currentItem
        function onDeleteMe(screenID) {
            deviceLockPinScreenStackView.pop()
            deviceLockPinScreenStackView.push("NodoLockPinControlScreen.qml")
        }

    }

    Connections{
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(errorCode === 9)
            {
                deviceLockPinScreenStackView.pop()
                deviceLockPinScreenStackView.push("NodoLockScreen.qml", {parentID: 0})
            }
        }
    }


    StackView {
        id: deviceLockPinScreenStackView
        anchors.fill: deviceLockPinScreen

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

