import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: firstTimeSetupScreen
    signal deleteMe(int screenID)

    Connections{
        target: devicePinScreenStackView.currentItem
        function onOpenNextScreen(screenID) {
            devicePinScreenStackView.pop()
            switch(screenID)
            {
            case 1:
                devicePinScreenStackView.push("NodoFirstTimeLockPinScreen.qml")
                break

            //case 2:
            //    devicePinScreenStackView.push("NodoFirstTimeAddressPinScreen.qml")
            //    break

            case 2: //3:
                nodoControl.setFirstBootConfigDone()
                devicePinScreenStackView.push("NodoFirstTimeRebootScreen.qml")
                break
            }
        }
    }

    Image {
        id: img
        anchors.top: firstTimeSetupScreen.top
        anchors.left: firstTimeSetupScreen.left
        anchors.topMargin: 3
        anchors.leftMargin: 10
        source: (nodoControl.appTheme ? "qrc:/Images/nodologo_title_red.png" : "qrc:/Images/nodologo_title_white.png")
        fillMode: Image.PreserveAspectFit
    }


    Rectangle {
        id: firstTimeSetupRect
        anchors.fill: parent
        anchors.topMargin: 170
        color: "black"
        StackView {
            id: devicePinScreenStackView
            anchors.fill: parent
            initialItem: "NodoFirstTimeAdminPasswordScreen.qml"

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
}
