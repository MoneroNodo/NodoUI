import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2

ApplicationWindow {
    id: mainAppWindow
    visible: true

    modality: Qt.WindowModal

    width: 1920
    height: 1080

    title: qsTr("NodoUI");

    NodoCurrencies{
        id: nodoCurrencies
    }

    NodoTimezones{
        id: nodoTimezones
    }

    Component.onCompleted: {
        translator.selectLanguage(translator.currentLanguage)
    }

    property bool screenLocked: false;

    StackView {
        id: mainAppStackView
        anchors.fill: parent
        initialItem: "NodoHomeScreen.qml"

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

    MouseArea {
        id: mainAppMouseAreaClicked
        anchors.fill: parent
        propagateComposedEvents: true

        onPressed: {
            mouse.accepted = false
            mainAppLockTimer.restart()
            if(screenLocked === true){
                mainAppWindow.screenLocked = false
                mainAppLockTimer.restart()
                mainAppStackView.pop()
            }
        }
    }

    function lockSystem()
    {
        if(screenLocked === false){
            mainAppLockTimer.stop()
            screenLocked = true
            if(0 === nodoControl.getScreenSaverType()) {
                mainAppStackView.push("NodoFeederScreenSaver.qml")
            }
            else if(1 === nodoControl.getScreenSaverType())
            {
                 mainAppStackView.push("NodoScreenSaver.qml")
            }
            else if(2 === nodoControl.getScreenSaverType())
            {
                mainAppStackView.push("NodoDigitalClock.qml")
            }
        }
    }

    Timer {
        id: mainAppLockTimer
        interval: nodoControl.getScreenSaverTimeout(); running: true; repeat: false
        onTriggered: lockSystem()
    }
    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: mainAppWindow.height
        width: mainAppWindow.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: mainAppWindow.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}

