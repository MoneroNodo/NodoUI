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
        anchors.leftMargin: 10
        model: inactiveListModel
        visible: true
        width: 1840
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
