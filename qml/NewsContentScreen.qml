import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import QtWebKit 3.0
import QtWebEngine 1.2
import NodoSystem 1.1


Item {
    id: root

    property string headerTextStr: "header"
    property string dataTextStr: "data"
    property string channelStr: "channel"
    property string dataTagStr: "tag"
    property string headerAuthStr: "auth"
    property string dataTimestampStr: "timestamp"
    property string imagePath: ""

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        color: "black"

        Label {
            id: channelLabel
            x: tagLabel.x - channelLabel.paintedWidth - 10
            y: timestampLabel.y
            width: channelLabel.paintedWidth
            height: 22
            text: channelStr
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: 38
        }

        Label {
            id: tagLabel
            x: authLabel.x - tagLabel.paintedWidth - 10
            y: timestampLabel.y
            width: tagLabel.paintedWidth
            height: 22
            text: dataTagStr
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: 38
        }

        Label {
            id: authLabel
            x: timestampLabel.x - authLabel.paintedWidth - 10
            y: timestampLabel.y
            width: authLabel.paintedWidth
            height: 22
            text: headerAuthStr
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: 38
        }

        Label {
            id: timestampLabel
            x: timestamplabel.width + authLabel.width + 10
            y: textArea.paintedHeight + 12
            width: timestampLabel.paintedWidth
            height: 22
            text: dataTimestampStr
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: 38
        }

        Label { // TITLE
            id: textArea
            x: 8
            y: 12
            width: root.width - 2*x
            height: root.height - textArea.height
            text: headerTextStr
            textFormat: Text.RichText
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: 92
            wrapMode: Text.WordWrap
        }

        Flickable { // BODY
            id: view
            x: 8
            y: timestampLabel.y + timestampLabel.paintedHeight + 16
            width: root.width -1 - 2*x
            height: root.height - (timestampLabel.y + timestampLabel.paintedHeight) - 20
            contentWidth: view.width
            contentHeight: view.height
            interactive: true
            flickableDirection: Flickable.VerticalFlick
            boundsMovement: Flickable.StopAtBounds
            boundsBehavior: Flickable.StopAtBounds

            TextArea.flickable: TextArea {
                id: textArea1
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                width: view.width
                height: view.contentHeight
                readOnly: true
            }
             ScrollBar.vertical: ScrollBar {}
         }

        Component.onCompleted: {
            textArea1.text = dataTextStr
            console.log("loaded")
        }

        Image {
            id: imageNightModeOff
            visible: !nodoControl.appTheme
            x: view.width - imageNightModeOff.width
            y: view.height - imageNightModeOff.height
            width: view.height*0.5
            height: view.height*0.5
            fillMode: Image.PreserveAspectFit
            opacity: 0.2
            source: imagePath == "" ? "qrc:/Images/Nodo_white.png" : imagePath
        }

        Image {
            id: imageNightModeOn
            visible: nodoControl.appTheme
            x: view.width - imageNightModeOn.width
            y: view.height - imageNightModeOn.height
            width: view.height*0.5
            height: view.height*0.5
            fillMode: Image.PreserveAspectFit
            opacity: 0.2
            source: imagePath == "" ? "qrc:/Images/Nodo_red.png" : imagePath
        }
    }
}

