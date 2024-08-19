import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Popup {
    id: systemPopup
    x: (parent.width - width)/2
    y: (parent.height - height)/2
    width: 655
    height: 200
    modal: true
    property string applyButtonText: ""
    property int commandID: -1
    property string popupMessageText: qsTr("Are you sure?")
    parent: mainAppWindowMainRect
    signal applyClicked()
    property int displayRotation: nodoControl.getOrientation()

    Connections {
        target: nodoControl
        function onClosePopupRequested()
        {
            systemPopup.close()
        }
    }

    Overlay.modal: Item {
        Rectangle{
            color: 'black'
            opacity: 0.3
            width: displayRotation == 0 || displayRotation == 180 ? parent.width : parent.height
            height: displayRotation == 0 || displayRotation == 180 ? parent.height : parent.width
        }
    }

    background: null
    contentItem: NodoCanvas {
        id: popupContent

        width: systemPopup.width
        height: systemPopup.height

        color: NodoSystem.popupBackgroundColor

        Text {
            id: popupMessage
            anchors.top: popupContent.top
            anchors.topMargin: 20
            x: (popupContent.width - popupMessage.paintedWidth)/2

            text: systemPopup.popupMessageText
            font.pixelSize: NodoSystem.infoFieldItemFontSize
            font.family: NodoSystem.fontUrbanist.name
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
        }

        NodoButton {
            id: applyButton
            text: systemPopup.applyButtonText
            anchors.top: popupMessage.bottom
            anchors.left: popupContent.left
            anchors.topMargin: 30
            anchors.leftMargin: systemPopup.commandID > -1 ? 12 : (systemPopup.width - applyButton.width)/2
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize

            onClicked: {
                applyClicked()
            }
        }

        NodoButton {
            id: cancelButton
            text: systemMessages.messages[NodoMessages.Message.Cancel]
            anchors.top: applyButton.top
            anchors.left: applyButton.right
            anchors.leftMargin: 16
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            visible: systemPopup.commandID === -1 ? false : true
            onClicked: {
                systemPopup.close()
            }
        }
    }
}
