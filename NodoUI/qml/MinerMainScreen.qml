import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: minerMainScreen
    anchors.fill: parent

    Component.onCompleted: {
        minerMainStackView.push("NodoLockScreen.qml", {parentID: 1})
    }

    Connections{
        target: minerMainStackView.currentItem
        function onDeleteMe(screenID) {
            minerMainStackView.pop()
            minerMainStackView.push("MinerConfigScreen.qml")
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
        id: minerMainStackView
        anchors.fill: minerMainScreen

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


