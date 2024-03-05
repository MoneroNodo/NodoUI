import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: moneroLWSAddAccountScreen
	anchors.fill: parent

    Label {
        id: moneroLWSMainAddressLabel
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSAddAccountScreen.top
        width: 200
        height: 38
        text: qsTr("Main Address (Starts with 4)")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoInputField {
        id: moneroLWSMainAddressInput
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSMainAddressLabel.bottom
		anchors.topMargin: 20
        width: 1813
        height: NodoSystem.infoFieldLabelHeight
    }


    Label {
        id: moneroLWSPrivateViewkeyLabel
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSMainAddressInput.bottom
		anchors.topMargin: 10
        width: 110
        height: 38
        text: qsTr("Private Viewkey")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoInputField {
        id: moneroLWSPrivateViewkeyInput
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSPrivateViewkeyLabel.bottom
		anchors.topMargin: 10
        width: 1813
        height: NodoSystem.infoFieldLabelHeight
    }

    NodoButton {
        id: moneroLWSAddAccountButton
		anchors.left: moneroLWSAddAccountScreen.left
        anchors.top: moneroLWSPrivateViewkeyInput.bottom
		anchors.topMargin: 20
        text: qsTr("Add Account")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }
}


