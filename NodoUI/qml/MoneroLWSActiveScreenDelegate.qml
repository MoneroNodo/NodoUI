import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: 1870
    height: 196
    color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn  : NodoSystem.dataFieldTextBGColorNightModeOff
    property string activeAddress: ""
    property int scanHeight: 0
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
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.top: mainRect.top
        anchors.topMargin: 10
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        itemSize: 175
        height: NodoSystem.nodoItemHeight
        itemText: systemMessages.messages[NodoMessages.Message.Address] //qsTr("Address")
        valueText: activeAddress
        valueFontSize: 28 
    }


    NodoInfoField {
        id: moneroLWSActiveHeightField
        anchors.left: moneroLWSActiveAddressField.left
        anchors.top: moneroLWSActiveAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        itemSize: 185
        width: 380
        height: NodoSystem.nodoItemHeight
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoButton {
        id: moneroLWSDeactivateButton
        anchors.left: moneroLWSActiveHeightField.right
        anchors.top: moneroLWSActiveHeightField.top
        anchors.leftMargin: 20
        text: qsTr("Deactivate")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.deactivateAccount(moneroLWSActiveAddressField.valueText)
        }
    }

    NodoInputField {
        id: moneroLWSRescanHeightInput
        anchors.left: moneroLWSDeactivateButton.right
        anchors.top: moneroLWSActiveHeightField.top
        anchors.leftMargin: 40
        width: labelSize + 250
        height: NodoSystem.nodoItemHeight
        itemText: qsTr("Rescan Height")
        valueText: ""
        textFlag: Qt.ImhDigitsOnly
    }

    NodoButton {
        id: moneroLWSRescanButton
        anchors.left: moneroLWSRescanHeightInput.right
        anchors.top: moneroLWSRescanHeightInput.top
        anchors.leftMargin: 20
        text: qsTr("Rescan")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: moneroLWSRescanHeightInput.valueText.length > 0 ? true : false

        onClicked: {
            var m_height = moneroLWSRescanHeightInput.valueText.toString()

            if((moneroLWSRescanHeightInput.valueText === "") || (moneroLWSRescanHeightInput.valueText === "0"))
            {
                m_height = moneroLWSActiveHeightField.valueText
            }

            moneroLWS.rescan(moneroLWSActiveAddressField.valueText, m_height)
        }
    }
}
