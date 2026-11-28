import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroLWSInactiveScreen
	anchors.fill: parent

    function createListModels() {
        inactiveListModel.clear()
        let size = moneroLWS.getInactiveAccountSize();

        for (var index = 0; index < moneroLWS.getInactiveAccountSize(); index++) {
            var accountParams = { "inactiveAddress": moneroLWS.getInactiveAccountAddress(index), "scanHeight": moneroLWS.getInactiveAccountScanHeight(index)}
            inactiveListModel.append(accountParams)
        }
        if (size === 0) {
            listEmptyRect.visible = true;
        }
    }

    Component.onCompleted: {
        if(moneroLWS.isListAccountsCompleted())
        {
            createListModels()
        }
    }

    Connections {
        target: moneroLWS
        function onListAccountsCompleted() {
            createListModels()
        }
    }

    Rectangle {
        id: listEmptyRect
        anchors.left: moneroLWSInactiveScreen.left
        anchors.top: moneroLWSInactiveScreen.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        visible: false

        Text {
            id: listEmptyText
            height: NodoSystem.nodoItemHeight
            width: parent.width - listEmptyRect.width
            anchors.left: parent.right
            anchors.leftMargin: 25
            anchors.top: parent.top
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("NONE")
        }
    }

    ListView {
        id: inactiveList
        anchors.top: moneroLWSInactiveScreen.top
        anchors.left: moneroLWSInactiveScreen.left
        anchors.bottom: moneroLWSInactiveScreen.bottom
        model: inactiveListModel
        visible: true
        width: parent.width
        clip: true

        delegate: MoneroLWSInactiveScreenDelegate {
            id: inactiveListDelegate
            inactiveAddress: model.inactiveAddress
            scanHeight: model.scanHeight
            width: inactiveList.width
        }
        spacing: NodoSystem.nodoTopMargin
    }
    ListModel {
        id: inactiveListModel
    }
}
