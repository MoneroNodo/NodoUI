import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import NodoSystem 1.1
import NodoCanvas 1.0


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

    NodoMessages {
        id: systemMessages
    }

    property bool screenLocked: false;
    property bool screenSaverActive: false;

    Component.onCompleted:
    {
        VirtualKeyboardSettings.locale = nodoControl.getKeyboardLayoutLocale()
        VirtualKeyboardSettings.styleName = "nodo"

        nodoControl.restartScreenSaverTimer();

        if(nodoControl.isLockPinEnabled())
        {
            nodoControl.restartLockScreenTimer();
        }

        var bcDiskStatus = nodoControl.getBlockchainStorageStatus()
        if(1 === bcDiskStatus)
        {
            mainScreenPopup.commandID = -1;
            mainScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.NoStorageFound]
            mainScreenPopup.open();
        }
        else if(2 === bcDiskStatus)
        {
            mainScreenPopup.commandID = -1;
            mainScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.NewBlockChainStorageFound]
            mainScreenPopup.open();
        }
    }

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

            function onScreenSaverTimedout()
            {
                mainAppWindowMainRect.displayScreenSaver();
            }

            function onLockScreenTimedout()
            {
                if(nodoControl.isLockPinEnabled())
                {
                    mainAppWindowMainRect.lockScreen();
                }
            }

            function onFactoryResetRequested()
            {
                console.log("FactoryResetRequested")
                mainScreenPopup.commandID = 0;
                mainScreenPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.FactoryResetApprove]
                mainScreenPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Accept]
                mainScreenPopup.open();
            }

            function onPowerButtonPressDetected()
            {
                console.log("onPowerButtonPressDetected")
                mainScreenPopup.notificationOnly = true
                mainScreenPopup.commandID = -1;
                mainScreenPopup.popupMessageText = qsTr("Shutdown in 5 seconds.\nRelease to Cancel.")
                mainScreenPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Accept]
                mainScreenPopup.open();
            }

            function onPowerButtonReleaseDetected()
            {
                console.log("onPowerButtonReleaseDetected")
                mainScreenPopup.close();
            }
        }

        Connections{
            target: mainAppStackView.currentItem
            function onDeleteMe(screenID) {
                mainAppStackView.pop()
                if(0 === screenID)
                {
                    mainAppStackView.push("NodoHomeScreen.qml")
                }
            }
        }

        color: "black"

        StackView {
            id: mainAppStackView
            anchors.fill: parent
            initialItem: nodoControl.isFirstBootConfigDone() === true ? "NodoHomeScreen.qml" : "NodoFirstTimeSetupScreen.qml"
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

            onPressed: (mouse)=> {
                           mouse.accepted = false;
                           if(mainAppWindow.screenSaverActive === true){
                               if(mainAppStackView.depth > 1)
                               {
                                   mainAppStackView.pop();
                               }

                               if(mainAppWindow.screenLocked === true)
                               {
                                   mainAppWindow.screenLocked = false
                                   mainAppStackView.push("NodoLockScreen.qml")
                                   nodoControl.stopLockScreenTimer()
                               }
                               mainAppWindow.screenSaverActive = false
                           }
                           else
                           {
                               if(mainAppWindow.screenLocked === true)
                               {
                                   mainAppWindow.screenLocked = false
                               }
                           }

                           nodoControl.restartScreenSaverTimer();
                           if(nodoControl.isLockPinEnabled())
                           {
                               nodoControl.restartLockScreenTimer();
                           }
                       }
        }

        function displayScreenSaver()
        {
            if(mainAppWindow.screenSaverActive === false){
                var screenSaverType = nodoControl.getScreenSaverType() + (nodoControl.isFeedsEnabled() ? 0 : 1)

                if(0 === screenSaverType) {
                    mainAppStackView.push("NodoNewsScreensaver.qml")
                }
                else if(1 === screenSaverType)
                {
                    mainAppStackView.push("NodoAnalogClassic.qml")
                }
                else if(2 === screenSaverType)
                {
                    mainAppStackView.push("NodoAnalogClock.qml")
                }
                else if(3 === screenSaverType)
                {
                    mainAppStackView.push("NodoDigitalClock.qml")
                }
                else if(4 === screenSaverType)
                {
                    mainAppStackView.push("NodoDisplayOff.qml")
                }
                nodoControl.closePopup()
                nodoControl.stopScreenSaverTimer();
                mainAppWindow.screenSaverActive = true
            }
        }

        function lockScreen()
        {
            if(mainAppWindow.screenLocked === false)
            {
                nodoControl.stopLockScreenTimer();
                mainAppWindow.screenLocked = true
                if(mainAppWindow.screenSaverActive === false)
                {
                    nodoControl.closePopup()
                    mainAppStackView.push("NodoLockScreen.qml")
                }
            }
        }

        NodoInputFieldPreview
        {
            id: previewPanel
            x: 0
            y: mainAppWindowMainRect.height
            width: mainAppWindowMainRect.width
            height: NodoSystem.nodoItemHeight

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
                    y: mainAppWindowMainRect.height + previewPanel.height - inputPanel.height - 70
                }

                PropertyChanges {
                    target: previewPanel
                    y: mainAppWindowMainRect.height - inputPanel.height -70
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

        NodoPopup {
            id: mainScreenPopup
            onApplyClicked: {
                if(commandID === 0)
                {
                    nodoControl.factoryResetApproved();
                    mainAppStackView.push("FactoryResetScreen.qml")
                }
                close()
            }
        }
    }
}

