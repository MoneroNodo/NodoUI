import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroLWSActiveScreen
	anchors.fill: parent
    property int labelSize: 0

    function createListModels() {
        activeListModel.clear()
        let size = moneroLWS.getActiveAccountSize();

        for (var index = 0; index < size; index++) {
            var accountParams = { "activeAddress": moneroLWS.getActiveAccountAddress(index), "scanHeight": moneroLWS.getActiveAccountScanHeight(index)}
            activeListModel.append(accountParams)
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
        anchors.left: moneroLWSActiveScreen.left
        anchors.top: moneroLWSActiveScreen.top
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
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("None")
        }
    }

    ListView {
        id: activeList
        anchors.top: moneroLWSActiveScreen.top
        anchors.left: moneroLWSActiveScreen.left
        anchors.bottom: moneroLWSActiveScreen.bottom
        anchors.leftMargin: NodoSystem.padding
        model: activeListModel
        visible: true
        width: parent.width
        clip: true

        delegate: MoneroLWSActiveScreenDelegate {
            id: activeListDelegate
            activeAddress: model.activeAddress
            scanHeight: model.scanHeight
            width: activeList.width
        }
        spacing: NodoSystem.nodoTopMargin
    }
    ListModel {
        id: activeListModel
    }
}
