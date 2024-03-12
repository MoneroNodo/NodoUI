import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: minerMainScreen
    property int labelSize: 0
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(miningDifficultyField.labelRectRoundSize > labelSize)
            labelSize = miningDifficultyField.labelRectRoundSize

        if(minerDepositAddressField.labelRectRoundSize > labelSize)
            labelSize = minerDepositAddressField.labelRectRoundSize
    }

    Rectangle {
        id: minerSwitchRect
		anchors.top: minerMainScreen.top
		anchors.left: minerMainScreen.left
        anchors.topMargin: 20
        height: 64
		color: "black"

        Text{
            id: minerSwitchRectSwitchText
            x: 0
            y: (minerSwitch.height - minerSwitchRectSwitchText.paintedHeight)/2
            width: minerSwitchRectSwitchText.paintedWidth
            height: minerSwitchRectSwitchText.paintedHeight
            text: qsTr("Miner")
            verticalAlignment: Text.AlignBottom
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: minerSwitch
            x: minerSwitchRectSwitchText.width + 20
            y: 0
            height: 64
            width: 128
            text: ""
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("mining", "enabled") === "TRUE" ? true : false
        }
    }

    Label {
        id: minerLabel
		anchors.top: minerSwitchRect.bottom
		anchors.left: minerMainScreen.left
		anchors.topMargin: 10
        width: 100
        height: 38
        text: qsTr("Mining is done with P2Pool and XMRig")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoInfoField {
        id: miningDifficultyField
		anchors.top: minerLabel.bottom
		anchors.left: minerMainScreen.left
		anchors.topMargin: 10
        width: 400
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Mining Difficulty")
        valueText: nodoConfig.getIntValueFromKey("mining", "difficulty")

    }

    NodoInfoField {
        id: minerDepositAddressField
		anchors.top: miningDifficultyField.bottom
		anchors.left: minerMainScreen.left
		anchors.topMargin: 10
        width: 800
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Deposit Address")
        valueText: nodoConfig.getStringValueFromKey("mining", "address")
    }

    Label {
        id: warningLabel
		anchors.top: minerDepositAddressField.bottom
		anchors.left: minerMainScreen.left
		anchors.topMargin: 10
        width: 900
        height: 38
        text: qsTr("Warning: Your deposit address must be a primary address beginning with 4! Warning: The deposit address will be publicly viewable. For privacy, use a different wallet!")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }
}


