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

        for (var index = 0; index < moneroLWS.getActiveAccountSize(); index++) {
            var accountParams = { "activeAddress": moneroLWS.getActiveAccountAddress(index), "scanHeight": moneroLWS.getActiveAccountScanHeight(index)}
            activeListModel.append(accountParams)
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
        id: activeList
        anchors.top: moneroLWSActiveScreen.top
        anchors.left: moneroLWSActiveScreen.left
        anchors.bottom: moneroLWSActiveScreen.bottom
        anchors.leftMargin: NodoSystem.padding
        model: activeListModel
        visible: true
        width: 1875
        clip: true

        delegate: MoneroLWSActiveScreenDelegate {
            id: activeListDelegate
            activeAddress: model.activeAddress
            scanHeight: model.scanHeight
            width: activeList.width
        }
        spacing: 15
    }
    ListModel {
        id: activeListModel
    }
}
