import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Rectangle {
    id: root

    property string headerTextStr: "header"
    property string dataTextStr: "data"
    property string channelStr: "channel"
    property string dataTagStr: "tag"
    property string headerAuthStr: "auth"
    property string dataTimestampStr: "timestamp"
    property string imagePath: ""
    color: "black"

    ScrollView
    {
        id: scrollView
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        ScrollBar.horizontal.interactive: true
        ScrollBar.vertical.interactive: true

        clip: true

        Item {
            id: feedItem
            width: parent.width
            height: feedTitle.y + feedTitle.height + middleSection.anchors.topMargin + middleSection.height + feedBody.anchors.topMargin + feedBody.height
            implicitHeight: height
            Label { // TITLE
                id: feedTitle
                x: 10
                y: 12
                width: root.width - 2*feedTitle.x
                height: feedTitle.paintedHeight
                text: headerTextStr
                textFormat: Text.RichText
                color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
                font.family: NodoSystem.fontInter.name
                font.pixelSize: 100
                wrapMode: Text.WordWrap
            }

            Rectangle {
                id: middleSection
                anchors.left: feedTitle.left
                anchors.top: feedTitle.bottom
                anchors.topMargin: 15
                Label {
                    id: feedAuth
                    anchors.left: middleSection.left
                    anchors.top: middleSection.top
                    width: feedAuth.paintedWidth
                    height: 22
                    text: headerAuthStr
                    color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
                    font.family: NodoSystem.fontInter.name
                    //font.pixelSize: 38
                }

                Label {
                    id: feedChannel
                    anchors.left: feedAuth.right
                    anchors.top: middleSection.top
                    anchors.leftMargin: 10
                    width: feedChannel.paintedWidth
                    height: 22
                    text: channelStr
                    color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
                    font.family: NodoSystem.fontInter.name
                    font.pixelSize: 38
                }

                Label {
                    id: feedTimestamp
                    anchors.left: feedChannel.right
                    anchors.top: middleSection.top
                    anchors.leftMargin: 10
                    width: feedTimestamp.paintedWidth
                    height: 22
                    text: dataTimestampStr
                    color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
                    font.family: NodoSystem.fontInter.name
                    font.pixelSize: 38
                }
            }

            TextArea {
                id: feedBody
                anchors.left: middleSection.left
                anchors.top: middleSection.bottom
                anchors.topMargin: NodoSystem.subMenuTopMargin + 80//100
                width: root.width - 2*feedBody.x
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                readOnly: true
                selectByMouse: false
            }
        }
    }

    Image {
        id: imageNightModeOff
        visible: !nodoControl.appTheme
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.rightMargin: 100
        anchors.bottomMargin: 100
        width: root.height*0.4
        height: root.height*0.4
        fillMode: Image.PreserveAspectFit
        opacity: 0.2
        source: imagePath == "" ? "qrc:/Images/Nodo_white.png" : imagePath
    }

    Image {
        id: imageNightModeOn
        visible: nodoControl.appTheme
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.rightMargin: 100
        anchors.bottomMargin: 100
        width: root.height*0.4
        height: root.height*0.4
        fillMode: Image.PreserveAspectFit
        opacity: 0.2
        source: imagePath == "" ? "qrc:/Images/Nodo_red.png" : imagePath
    }

    Component.onCompleted: {
        feedBody.text = dataTextStr
    }
}

