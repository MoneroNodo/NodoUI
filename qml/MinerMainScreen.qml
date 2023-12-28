import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: minerMainScreen
    property int labelSize: 120
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    Rectangle {
        id: minerSwitchRect
		anchors.top: minerMainScreen.top
		anchors.left: minerMainScreen.left
        anchors.topMargin: 20
        height: 40
		color: "black"

        Text{
            id: minerSwitchRectSwitchText
            x: 0
            y: (minerSwitch.height - minerSwitchRectSwitchText.paintedHeight)/2
            width: minerSwitchRectSwitchText.paintedWidth
            height: minerSwitchRectSwitchText.paintedHeight
            text: "Miner"
            verticalAlignment: Text.AlignBottom
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: minerSwitch
            x: minerSwitchRectSwitchText.width + 20
            y: 0
            height: 40
            width: 80
            text: qsTr("")
            display: AbstractButton.IconOnly
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
        height: 38
        itemSize: 150
        itemText: "Mining Difficulty"
        valueText: "1234"

    }

    NodoInfoField {
        id: minerDepositAddressField
		anchors.top: miningDifficultyField.bottom
		anchors.left: minerMainScreen.left
		anchors.topMargin: 10
        width: 800
        height: 38
        itemSize: 150
        itemText: "Deposit Address"
        valueText: "some long deposit address"
    }

    Label {
        id: warningLabel
		anchors.top: minerDepositAddressField.bottom
		anchors.left: minerMainScreen.left
		anchors.topMargin: 10
        width: 900
        height: 38
        text: qsTr("Warning: Your deposit address must start with 4! Warning: The deposit address will be publicly viewable. For privacy, use a different vallet!")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }
}


