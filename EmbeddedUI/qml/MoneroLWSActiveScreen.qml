import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1
import QtQuick.VirtualKeyboard 2.1

Item {
    id: moneroLWSActiveScreen
	anchors.fill: parent
    property int labelSize: 0

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroLWSActiveAddressField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSActiveAddressField.labelRectRoundSize

        if(moneroLWSActiveHeightField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSActiveHeightField.labelRectRoundSize
    }

    NodoInfoField {
        id: moneroLWSActiveAddressField
		anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSActiveScreen.top
        width: labelSize+300
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Address")
        valueText: "a very long address"
    }


    NodoInfoField {
        id: moneroLWSActiveHeightField
		anchors.left: moneroLWSActiveAddressField.right
        anchors.top: moneroLWSActiveScreen.top
        anchors.leftMargin: 20
        width: labelSize+300
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Height")
        valueText: "2999185"
    }

    NodoButton {
        id: moneroLWSDeactivateButton
		anchors.left: moneroLWSActiveHeightField.right
        anchors.top: moneroLWSActiveScreen.top
        anchors.leftMargin: 20
        text: qsTr("Deactivate")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }

    NodoInputField {
        id: moneroLWSRescanHeightInput
        anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSActiveAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 600
        height: NodoSystem.inputFieldLabelHeight
        itemText: qsTr("Rescan Height")
        valueText: ""
    }

    NodoButton {
        id: moneroLWSRescanButton
		anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSRescanHeightInput.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Rescan")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }
}
