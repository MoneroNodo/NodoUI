import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: moneroLWSInactiveScreen
    property int labelSize: 90
	anchors.fill: parent

    NodoInfoField {
        id: moneroLWSinactiveAddressField
		anchors.left: moneroLWSInactiveScreen.left
        anchors.top: moneroLWSInactiveScreen.top
        width: 460
        height: 38
        itemSize: labelSize
        itemText: "Address"
        valueText: "a very long address"
    }


    NodoInfoField {
        id: moneroLWSinactiveHeightField
		anchors.left: moneroLWSinactiveAddressField.right
        anchors.top: moneroLWSInactiveScreen.top
		anchors.leftMargin: 10
        width: 260
        height: 38
        itemSize: labelSize
        itemText: "Height"
        valueText: "2999185"
    }

    NodoButton {
        id: moneroLWSReactivateButton
		anchors.left: moneroLWSinactiveHeightField.right
        anchors.top: moneroLWSInactiveScreen.top
		anchors.leftMargin: 10
        text: qsTr("Reativate")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }

    NodoButton {
        id: moneroLWSDeleteButton
		anchors.left: moneroLWSReactivateButton.right
        anchors.top: moneroLWSInactiveScreen.top
		anchors.leftMargin: 10
        text: qsTr("Delete")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }
}
