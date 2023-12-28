import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: moneroLWSActiveScreen
	anchors.fill: parent
    property int labelSize: 90

    NodoInfoField {
        id: moneroLWSActiveAddressField
		anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSActiveScreen.top
        width: 460
        height: 38
        itemSize: labelSize
        itemText: "Address"
        valueText: "a very long address"
    }


    NodoInfoField {
        id: moneroLWSActiveHeightField
		anchors.left: moneroLWSActiveAddressField.right
        anchors.top: moneroLWSActiveScreen.top
		anchors.leftMargin: 10
        width: 260
        height: 38
        itemSize: labelSize
        itemText: "Height"
        valueText: "2999185"
    }

    NodoButton {
        id: moneroLWSDeactivateButton
		anchors.left: moneroLWSActiveHeightField.right
        anchors.top: moneroLWSActiveScreen.top
		anchors.leftMargin: 10
        text: qsTr("Deativate")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }

    Label {
        id: moneroLWSRescanHeightLabel
		anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSActiveAddressField.bottom
		anchors.topMargin: 10
        width: 100
        height: 38
        text: qsTr("Rescan Height")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoInputField {
        id: moneroLWSRescanHeightInput
		anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSRescanHeightLabel.bottom
		anchors.topMargin: 10
        width: 150
        height: 38
    }

    NodoButton {
        id: moneroLWSRescanButton
		anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSRescanHeightInput.bottom
		anchors.topMargin: 10
        text: qsTr("Rescan")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }
}
