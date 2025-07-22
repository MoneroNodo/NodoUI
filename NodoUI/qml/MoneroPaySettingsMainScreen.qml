import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroPaySettingsMainScreen
    anchors.fill: parent

    Component.onCompleted: {
        moneroPaySettingsMainStackView.push("NodoLockScreen.qml", {parentID: 0})
    }

    Connections{
        target: moneroPaySettingsMainStackView.currentItem
        function onDeleteMe(screenID) {
            moneroPaySettingsMainStackView.pop()
            moneroPaySettingsMainStackView.push("MoneroPaySettingsConfigScreen.qml")
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
        id: moneroPaySettingsMainStackView
        anchors.fill: moneroPaySettingsMainScreen

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
