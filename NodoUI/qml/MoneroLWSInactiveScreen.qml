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

        for (var index = 0; index < moneroLWS.getInactiveAccountSize(); index++) {
            var accountParams = { "inactiveAddress": moneroLWS.getInactiveAccountAddress(index), "scanHeight": moneroLWS.getInactiveAccountScanHeight(index)}
            inactiveListModel.append(accountParams)
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

    ListView {
        id: inactiveList
        anchors.top: moneroLWSInactiveScreen.top
        anchors.left: moneroLWSInactiveScreen.left
        anchors.bottom: moneroLWSInactiveScreen.bottom
        anchors.leftMargin: NodoSystem.padding
        model: inactiveListModel
        visible: true
        width: 1880
        clip: true

        delegate: MoneroLWSInactiveScreenDelegate {
            id: inactiveListDelegate
            inactiveAddress: model.inactiveAddress
            scanHeight: model.scanHeight
            width: inactiveList.width
        }
        spacing: 15
    }
    ListModel {
        id: inactiveListModel
    }
}
