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
    implicitWidth: 655
    height: 140 + popupMessage.paintedHeight
    modal: true
    property string applyButtonText: ""
    property int commandID: -1
    property string popupMessageText: qsTr("Are you sure?")
    parent: mainAppWindowMainRect
    signal applyClicked()
    property int displayRotation: nodoControl.getOrientation()
    property bool notificationOnly: false

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

        width: systemPopup.implicitWidth
        height: 140 + popupMessage.paintedHeight

        color: NodoSystem.popupBackgroundColor

        Text {
            id: popupMessage
            anchors.top: popupContent.top
            anchors.topMargin: 20
            x: 10//(popupContent.width - popupMessage.paintedWidth)/2
            width: systemPopup.width - 20
            height: popupMessage.paintedHeight

            text: systemPopup.popupMessageText
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
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
            visible: !systemPopup.notificationOnly

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
