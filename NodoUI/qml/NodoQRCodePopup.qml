import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Popup {
    id: qrCodePopup
    x: (parent.width - width)/2
    y: (parent.height - height)/2
    implicitWidth: 800
    height: implicitWidth + 100
    modal: true
    parent: mainAppWindowMainRect
    property int displayRotation: nodoControl.getOrientation()
    property string qrCodeData
    property string closeButtonText
    property int qrCodeLeftMargin: 20

    Connections {
        target: nodoControl
        function onClosePopupRequested()
        {
            qrCodePopup.close()
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

        width: qrCodePopup.implicitWidth
        height: qrCodePopup.height
        color: NodoSystem.popupBackgroundColor

        Rectangle{
            id: qrCodeRect
            width: qrCodePopup.implicitWidth - (2*qrCodeLeftMargin)
            height: width
            y: 10
            anchors.leftMargin: qrCodeLeftMargin
            anchors.horizontalCenter: popupContent.horizontalCenter
            QtQuick2QREncode {
                id: qr
                width: qrCodeRect.width
                height: qrCodeRect.height
                qrSize: Qt.size(width,width)
                qrData: qrCodeData
                qrForeground: "black"
                qrBackground: "#F2F2F7"
                qrMargin: 8
                qrMode: QtQuick2QREncode.MODE_8    //encode model
                qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
            }
        }

        NodoButton {
            id: closeButton
            text: closeButtonText
            anchors.top: qrCodeRect.bottom
            anchors.topMargin: 25
            anchors.horizontalCenter: popupContent.horizontalCenter
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            visible: true
            onClicked: {
                qrCodePopup.close()
            }
        }
    }
}
