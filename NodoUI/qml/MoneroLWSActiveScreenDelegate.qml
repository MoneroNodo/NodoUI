import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: parent.width
    height: moneroLWSActiveHeightField.y + moneroLWSActiveHeightField.height + NodoSystem.cardTopMargin//196
    color: NodoSystem.cardBackgroundColor//nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn  : NodoSystem.dataFieldTextBGColorNightModeOff
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
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.leftMargin: NodoSystem.cardLeftMargin - 2
        anchors.rightMargin: NodoSystem.cardLeftMargin - 2
        itemSize: 180
        height: NodoSystem.nodoItemHeight
        itemText: systemMessages.messages[NodoMessages.Message.Address] //qsTr("Address")
        valueText: activeAddress
        valueFontSize: 31 
    }


    NodoInfoField {
        id: moneroLWSActiveHeightField
        anchors.left: moneroLWSActiveAddressField.left
        anchors.top: moneroLWSActiveAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        itemSize: 180
        width: 400
        height: NodoSystem.nodoItemHeight
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoInputField {
        id: moneroLWSRescanHeightInput
        anchors.left: moneroLWSActiveHeightField.right
        anchors.top: moneroLWSActiveHeightField.top
        anchors.leftMargin: 25
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
        anchors.leftMargin: 25
        text: qsTr("Rescan")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
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

    NodoButton {
        id: moneroLWSDeactivateButton
        anchors.right: mainRect.right//moneroLWSRescanButton.right
        anchors.rightMargin: NodoSystem.cardTopMargin
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: NodoSystem.cardTopMargin
        //anchors.top: moneroLWSActiveHeightField.top
        //anchors.leftMargin: 25
        text: qsTr("Deactivate")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.deactivateAccount(moneroLWSActiveAddressField.valueText)
        }
    }
}
