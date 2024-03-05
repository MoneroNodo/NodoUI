import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: moneroLWSInactiveScreen
    property int labelSize: 0
	anchors.fill: parent

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroLWSinactiveAddressField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSinactiveAddressField.labelRectRoundSize

        if(moneroLWSinactiveHeightField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSinactiveHeightField.labelRectRoundSize
    }

    NodoInfoField {
        id: moneroLWSinactiveAddressField
		anchors.left: moneroLWSInactiveScreen.left
        anchors.top: moneroLWSInactiveScreen.top
        width: labelSize + 330
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Address")
        valueText: "a very long address"
    }


    NodoInfoField {
        id: moneroLWSinactiveHeightField
		anchors.left: moneroLWSinactiveAddressField.right
        anchors.top: moneroLWSInactiveScreen.top
		anchors.leftMargin: 10
        width: labelSize+130
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Height")
        valueText: "2999185"
    }

    NodoButton {
        id: moneroLWSReactivateButton
		anchors.left: moneroLWSinactiveHeightField.right
        anchors.top: moneroLWSInactiveScreen.top
		anchors.leftMargin: 10
        text: qsTr("Reativate")
        height: NodoSystem.infoFieldLabelHeight
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
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }
}
