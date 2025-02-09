import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodeBanlistScreen
    anchors.fill: parent

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

    Text {
        id: nodeBanlistScreenTitle
        height: 30
        width: parent.width
        anchors.top: nodeBanlistScreen.top
        anchors.left: nodeBanlistScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        //anchors.topMargin: NodoSystem.nodoTopMargin*3
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTitleFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("NODE IP BANLIST")
    }

    Rectangle {
        id: nodeBanlistScreenIndex1
        anchors.top: nodeBanlistScreenTitle.bottom
        anchors.left: nodeBanlistScreen.left
        anchors.topMargin: NodoSystem.cardTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"

            NodoCheckBox
            {
                id: nodeBanlistScreenIndex1Check
                height: nodeBanlistScreenIndex1.height
                width: height
                anchors.left: nodeBanlistScreenIndex1.left
                anchors.top: nodeBanlistScreenIndex1.top
                checked: nodoControl.getBanlistsListEnabled("boog900")
                onClicked: {
                    applyBanlistButton.isActive = true
                }
            }

            NodoLabel {
                id: nodeBanlistScreenIndex1Text
                width: labelSize - 40
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
                anchors.top: nodeBanlistScreenIndex2.top
                checked: nodoControl.getBanlistsListEnabled("gui-xmr-pm")
                onClicked: {
                    applyBanlistButton.isActive = true
                }
            }

            NodoLabel {
                id: nodeBanlistScreenIndex2Text
                width: labelSize - 40
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
        anchors.topMargin: NodoSystem.nodoTopMargin -2
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        width: nodeBanlistScreenIndex2Check.width + nodeBanlistScreenIndex2Text.width
        text: qsTr("Apply")
        isActive: false
        onClicked: {
            applyBanlistButton.isActive = false
            nodoControl.setBanlistsListEnabled("boog900", nodeBanlistScreenIndex1Check.checked);
            nodoControl.setBanlistsListEnabled("gui-xmr-pm", nodeBanlistScreenIndex2Check.checked);
            nodoControl.serviceManager("restart", "monerod");
        }
    }

    NodoButton {
        id: clearBanlistButton
        anchors.left: applyBanlistButton.right
        anchors.top: applyBanlistButton.top
        anchors.leftMargin: 25
        height: NodoSystem.nodoItemHeight
        width: applyBanlistButton.width
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: qsTr("Clear")
        onClicked: {
            applyBanlistButton.isActive = false
            nodeBanlistScreenIndex1Check.checked = false;
            nodeBanlistScreenIndex2Check.checked = false;
            applyBanlistButton.clicked();
        }
    }

    Text {
        id: nodeBanlistButtonDescription
        height: NodoSystem.nodoItemHeight
        width: nodeBanlistButtonDescription.paintedWidth
        anchors.left: clearBanlistButton.right
        anchors.leftMargin: 25
        anchors.top: applyBanlistButton.top
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("Monero Daemon will restart to apply changes.")
    }    

    Text {
        id: nodeBanlistScreenDescription
        height: nodeBanlistScreenDescription.paintedHeight
        width: parent.width
        anchors.top: applyBanlistButton.bottom
        anchors.left: nodeBanlistScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        anchors.topMargin: NodoSystem.nodoTopMargin -2
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("The Monero Research Lab (MRL) has decided to recommend that all Monero node operators enable a ban list of suspected spy node IP addresses. The spy nodes can reduce the privacy of Monero users.

Blocking the IP addresses by default is technically possible, but it would set a precedent of blocking IP addresses by a decision making process that is not decentralized. MRL has decided to ask node operators to block these IP addresses voluntarily instead of by default. We recommend enabling both banlists until a more permanent solution can be found.

More info on this issue and FAQs can be found on Monero's Official Repo:
https://github.com/monero-project/meta/issues/1124")
    }
}
