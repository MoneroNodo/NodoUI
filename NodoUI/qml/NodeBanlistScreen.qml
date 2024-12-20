import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodeBanlistScreen
    anchors.fill: parent
    color: "black"

    property int labelSize: 0
    property int checkBoxMargin: 0

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(nodeBanlistScreenIndex1Text.labelRectRoundSize > labelSize)
        labelSize = nodeBanlistScreenIndex1Text.labelRectRoundSize

        if(nodeBanlistScreenIndex2Text.labelRectRoundSize > labelSize)
        labelSize = nodeBanlistScreenIndex2Text.labelRectRoundSize
    }

    Rectangle {
        id: nodeBanlistScreenIndex1
        anchors.top: nodeBanlistScreen.top
        anchors.left: nodeBanlistScreen.left
        height: NodoSystem.nodoItemHeight
        color: "black"

            NodoCheckBox
            {
                id: nodeBanlistScreenIndex1Check
                height: nodeBanlistScreenIndex1.height
                width: height
                anchors.left: nodeBanlistScreenIndex1.left
                anchors.top: nodeBanlistScreenIndex1.top
            }

            NodoLabel {
                id: nodeBanlistScreenIndex1Text
                width: nodeBanlistScreen.labelSize
                height: nodeBanlistScreenIndex1Check.height
                anchors.left: nodeBanlistScreenIndex1Check.right
                anchors.leftMargin: nodeBanlistScreen.checkBoxMargin
                text: qsTr("Boog900")
            }
    }

    Rectangle {
        id: nodeBanlistScreenIndex2
        anchors.left: nodeBanlistScreen.left
        anchors.top: nodeBanlistScreenIndex1.bottom
        height: NodoSystem.nodoItemHeight
        anchors.topMargin: NodoSystem.nodoTopMargin
        color: "black"

            NodoCheckBox
            {
                id: nodeBanlistScreenIndex2Check
                height: nodeBanlistScreenIndex2.height
                width: height
                anchors.left: nodeBanlistScreenIndex2.left
                anchors.top: nodeBanlistScreenIndex1.top
            }

            NodoLabel {
                id: nodeBanlistScreenIndex2Text
                width: nodeBanlistScreen.labelSize
                height: nodeBanlistScreenIndex2Check.height
                anchors.left: nodeBanlistScreenIndex2Check.right
                anchors.leftMargin: nodeBanlistScreen.checkBoxMargin
                text: qsTr("gui.xmr.pm")
            }
    }

    NodoButton {
        id: applyBanlistButton
        anchors.left: nodeBanlistScreen.left
        anchors.top: nodeBanlistScreenIndex2.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: qsTr("Apply")
        onClicked: {}
    }

    NodoButton {
        id: clearBanlistButton
        anchors.left: applyBanlistButton.right
        anchors.top: applyBanlistButton.top
        anchors.leftMargin: 25
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: qsTr("Clear")
        onClicked: {}
    }

}
