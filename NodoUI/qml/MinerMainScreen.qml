import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: minerMainScreen
    property int labelSize: 0
    property int inputFieldWidth: 600
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    Rectangle {
        id: minerSwitchRect
		anchors.top: minerMainScreen.top
		anchors.left: minerMainScreen.left
        anchors.topMargin: 20
        height: NodoSystem.nodoItemHeight
		color: "black"

        NodoLabel{
            id: minerSwitchRectSwitchText
            height: minerSwitchRect.height
            anchors.top: minerSwitchRect.top
            anchors.left: minerSwitchRect.left
            text: qsTr("Miner")
        }

        NodoSwitch {
            id: minerSwitch
            anchors.left: minerSwitchRectSwitchText.right
            anchors.top: minerSwitchRectSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*minerSwitchRectSwitchText.height
            height: minerSwitchRectSwitchText.height
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("mining", "enabled") === "TRUE" ? true : false
        }
    }

    Text {
        id: minerLabel
		anchors.top: minerSwitchRect.bottom
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 100
        height: 38
        text: qsTr("Mining is done with P2Pool and XMRig")
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoInfoField {
        id: minerDepositAddressField
        anchors.top: minerLabel.bottom
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 800
        height: NodoSystem.infoFieldLabelHeight
        itemSize: 300
        itemText: qsTr("Deposit Address")
        valueText: nodoConfig.getStringValueFromKey("mining", "address")
    }

    Text {
        id: warningLabel
		anchors.top: minerDepositAddressField.bottom
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 1800
        height: 100
        wrapMode: Text.WordWrap
        text: qsTr("Warning: Your deposit address must be a primary address beginning with 4!\r\nWarning: The deposit address will be publicly viewable. For privacy, use a different wallet!")
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }
}


