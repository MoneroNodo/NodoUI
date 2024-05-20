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
import QtQuick.VirtualKeyboard.Styles 2.15

ApplicationWindow {
    id: mainAppWindow
    visible: true
    visibility: "FullScreen"

    modality: Qt.WindowModal
    property int displayRotation: nodoControl.getOrientation()

    contentOrientation: displayRotation == -90 ? Qt.InvertedLandscapeOrientation : displayRotation == 90 ? Qt.LandscapeOrientation : displayRotation == 0 ? Qt.PortraitOrientation : Qt.InvertedPortraitOrientation

    width: displayRotation == 0 || displayRotation == 180 ? 1920 : 1080
    height: displayRotation == 0 || displayRotation == 180 ? 1080 : 1920


    title: qsTr("NodoUI");

    NodoCurrencies{
        id: nodoCurrencies
    }

    NodoTimezones{
        id: nodoTimezones
    }

    property bool screenLocked: false;

    Rectangle {
        id: mainAppWindowMainRect

        rotation: displayRotation

        x: displayRotation == 0 || displayRotation == 180 ? 0 : -420
        y: displayRotation == 0 || displayRotation == 180 ? 0 : 420
        width: displayRotation == 0 || displayRotation == 180 ? mainAppWindow.width : mainAppWindow.height
        height: displayRotation == 0 || displayRotation == 180 ? mainAppWindow.height : mainAppWindow.width

        Connections {
            target: nodoControl
            function onOrientationChanged()
            {
                var orientation = nodoControl.getOrientation()
                mainAppWindow.displayRotation = orientation
                mainAppWindowMainRect.rotation = orientation
                mainAppWindow.contentOrientation = displayRotation == -90 ? Qt.InvertedLandscapeOrientation : displayRotation == 90 ? Qt.LandscapeOrientation : displayRotation == 0 ? Qt.PortraitOrientation : Qt.InvertedPortraitOrientation

            }
        }

        color: "black"

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

        NodoInputFieldPreview
        {
            id: previewPanel
            x: 0
            y: mainAppWindowMainRect.height
            width: mainAppWindowMainRect.width
            height: NodoSystem.infoFieldLabelHeight
            // focus: true


            Connections {
                target: nodoControl
                function onInputFieldTextChanged() {
                    previewPanel.text = nodoControl.getInputFieldText()
                }
            }
        }

        InputPanel {
            id: inputPanel
            z: 99
            x: 0
            y: mainAppWindowMainRect.height + previewPanel.height
            width: mainAppWindowMainRect.width

            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: mainAppWindowMainRect.height + previewPanel.height - inputPanel.height
                }

                PropertyChanges {
                    target: previewPanel
                    y: mainAppWindowMainRect.height - inputPanel.height
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

        function lockSystem()
        {
            if(screenLocked === false){
                mainAppLockTimer.stop()
                screenLocked = true
                mainAppStackView.pop()
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
            onTriggered: mainAppWindowMainRect.lockSystem()
        }
    }
}

