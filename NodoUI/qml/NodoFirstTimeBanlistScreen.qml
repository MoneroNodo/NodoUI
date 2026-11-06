import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodoFirstTimeBanlistScreen
	anchors.leftMargin: 20

    property int labelSize: 0
    property int checkBoxMargin: 0
    property int buttonWidth: 380

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(nodeBanlistScreenIndex1Text.labelRectRoundSize > labelSize)
        labelSize = nodeBanlistScreenIndex1Text.labelRectRoundSize

        if(nodeBanlistScreenIndex2Text.labelRectRoundSize > labelSize)
        labelSize = nodeBanlistScreenIndex2Text.labelRectRoundSize

        if(nodeBanlistScreenIndex3Text.labelRectRoundSize > labelSize)
        labelSize = nodeBanlistScreenIndex3Text.labelRectRoundSize
    }

    Rectangle {
        id: nodoFirstTimeBanlistRect
		anchors.fill: parent
		anchors.leftMargin: 20
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        color: "black"

            NodoLabel {
                id: enableAllBanlistsText
                height: nodoFirstTimeBanlistRect.height
				itemSize: 380
				anchors.left: nodoFirstTimeBanlistRect.left
                anchors.top: nodoFirstTimeBanlistRect.top
				text: qsTr("Enable All Banlists")
            }
			
			NodoSwitch {
				id: enableAllBanlistsSwitch
				anchors.left: enableAllBanlistsText.right
				anchors.leftMargin: NodoSystem.padding
				height: nodoFirstTimeBanlistRect.height
				width: 2*nodoFirstTimeBanlistRect.height
				display: AbstractButton.IconOnly
				checked: NodoFirstTimeBanlistScreen.enableAllBanlistsSwitchStatus
			/*	onCheckChanged: {
					var cur = NodoFirstTimeBanlistScreen.enableAllBanlistsSwitchStatus;
					if (cur != enableAllBanlistsSwitchStatus.checked)
					{
						nodoControl.setEnableAllBanlistsEnabled(enableAllBanlistsSwitch.checked);
						nodoFirstTimeBanlistScreen.enableAllBanlistsSwitchStatus = enableAllBanlistsSwitch.checked;
						nodoControl.sendUpdate();					
				}
			}
			
			Text {
				id: enableAllBanlistsDesc
				height: NodoSystem.nodoItemHeight
				width: parent.width - nodoFirstTimeBanlistRect.width
				anchors.top: enableAllBanlistsSwitch.top
				anchors.left: enableAllBanlistsSwitch.right
				anchors.leftMargin: 25
				verticalAlignment: Text.AlignVCenter
				font.family: NodoSystem.fontInter.name
				font.pixelSize: NodoSystem.descriptionTextFontSize
				color: NodoSystem.descriptionTextFontColorNightModeOff
				text: qsTr("Boog900, gui.xmr.pm, DNS Banlist")
			}

    NodoButton {
        id: applyFirstTimeBanlistButton
        anchors.left: nodeBanlistScreen.left
        anchors.top: nodoFirstTimeBanlistRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        width: 380
        text: qsTr("APPLY")
        isActive: false
        onClicked: {
            applyBanlistButton.isActive = false
            nodoControl.setBanlistsListEnabled("boog900", nodeBanlistScreenIndex1Check.checked);
            nodoControl.setBanlistsListEnabled("gui-xmr-pm", nodeBanlistScreenIndex2Check.checked);
            nodoControl.setBanlistsListEnabled("dns", nodeBanlistScreenIndex3Check.checked);
            nodoControl.serviceManager("restart", "monerod");
        }
    }

    NodoButton {
        id: nextButton
        anchors.left: applyBanlistButton.right
        anchors.top: applyBanlistButton.top
        anchors.leftMargin: 25
        height: NodoSystem.nodoItemHeight
        width: 380
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: qsTr("FINISH")
        onClicked: {
			close()
        }
    }   

    Text {
        id: nodeBanlistScreenDescription
        height: nodeBanlistScreenDescription.paintedHeight
        width: parent.width
        anchors.top: applyBanlistButton.bottom
        anchors.left: nodoFirstTimeBanlistScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        anchors.topMargin: NodoSystem.nodoTopMargin -2
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize - 8
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("The Monero Research Lab (MRL) has decided to recommend that all Monero node operators enable a ban list of suspected spy node IP addresses. The spy nodes can reduce the privacy of Monero users.

Blocking the IP addresses by default is technically possible, but it would set a precedent of blocking IP addresses by a decision making process that is not decentralized. MRL has decided to ask node operators to block these IP addresses voluntarily instead of by default. We recommend enabling all banlists until a more permanent solution can be found.

More info on this issue and FAQs can be found on Monero's Official Repo:
https://github.com/monero-project/meta/issues/1124")
    }
}
