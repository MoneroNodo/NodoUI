import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroLWSMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin
    anchors.topMargin: NodoSystem.subMenuTopMargin

    Component.onCompleted: {
        var dbusConnStat = moneroLWS.getDbusConnectionStatus()
        moneroLWSMenuBar.enabled = dbusConnStat
        if(true === dbusConnStat)
        {
            moneroLWS.listAccounts()
            // moneroLWS.listRequests()
        }
        // if(100 === syncInfo.getSyncPercentage())
        // {
        //     addAccountButton.enabled = true
        // }
        // else
        // {
        //     addAccountButton.enabled = false
        // }
    }

    Connections {
        target: syncInfo
        function onSyncDone() {
            addAccountButton.enabled = true
        }
    }

    Connections {
        target: moneroLWS
        function onDbusConnectionStatusChanged(status) {
            moneroLWSMenuBar.enabled = status;

            if(true === status)
            {
                moneroLWS.listAccounts()
                // moneroLWS.listRequests()
            }
        }

        function onAccountAdded() {
            activeButton.checked = true
            activeButton.clicked()
        }
    }

    TabBar {
        id: moneroLWSMenuBar
        anchors.top: moneroLWSMainScreen.top
        anchors.left: moneroLWSMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        //contentWidth: 1400
        width: 1360//inactiveButton.x + inactiveButton.width

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: addAccountButton
            y: (moneroLWSMenuBar.height - addAccountButton.height)/2
            text: qsTr("ADD WALLET")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSAddAccountScreen.qml" }
        }

        // NodoTabButton {
        //     id: accountRequestsButton
        //     y: (moneroLWSMenuBar.height - accountRequestsButton.height)/2
        //     anchors.left: addAccountButton.right
        //     anchors.leftMargin: NodoSystem.nodoTopMargin
        //     text: qsTr("WALLET REQUESTS")
        //     font.family: NodoSystem.fontInter.name
        //     font.pixelSize: NodoSystem.topMenuButtonFontSize
        //     onClicked: { pageLoader.source = "MoneroLWSAccountRequestsScreen.qml" }
        // }

        NodoTabButton {
            id: activeButton
            y: (moneroLWSMenuBar.height - activeButton.height)/2
            anchors.left: addAccountButton.right
            anchors.leftMargin: NodoSystem.nodoTopMargin
            text: qsTr("ACTIVE")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSActiveScreen.qml" }
        }

        NodoTabButton {
            id: inactiveButton
            y: (moneroLWSMenuBar.height - inactiveButton.height)/2
            anchors.left: activeButton.right
            anchors.leftMargin: NodoSystem.nodoTopMargin
            text: qsTr("INACTIVE")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSInactiveScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: moneroLWSMenuBar.bottom
        anchors.left: moneroLWSMainScreen.left
        anchors.right: moneroLWSMainScreen.right
        anchors.bottom: moneroLWSMainScreen.bottom
        anchors.topMargin: 40
        source: "MoneroLWSAddAccountScreen.qml"
    }
}
