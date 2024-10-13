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

    Component.onCompleted: {
        moneroLWS.listAccounts()
        moneroLWS.listRequests()
        if (100 === syncInfo.getSyncPercentage())
        {
            addAccountButton.enabled = true
        }
        else
        {
            addAccountButton.enabled = false
        }
    }

    Connections {
        target: syncInfo
        function onSyncDone() {
            addAccountButton.enabled = true
        }
    }

    TabBar {
        id: moneroLWSMenuBar
        anchors.top: moneroLWSMainScreen.top
        anchors.left: moneroLWSMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        contentWidth: 1400

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: activeButton
            y: (moneroLWSMenuBar.height - activeButton.height)/2
            text: qsTr("ACTIVE")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSActiveScreen.qml" }
        }
        NodoTabButton {
            id: inactiveButton
            y: (moneroLWSMenuBar.height - inactiveButton.height)/2
            anchors.left: activeButton.right
            text: qsTr("INACTIVE")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSInactiveScreen.qml" }
        }
        NodoTabButton {
            id: addAccountButton
            y: (moneroLWSMenuBar.height - addAccountButton.height)/2
            anchors.left: inactiveButton.right
            text: qsTr("ADD ACCOUNT")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSAddAccountScreen.qml" }
            enabled: false
        }
        NodoTabButton {
            id: accountRequestsButton
            y: (moneroLWSMenuBar.height - accountRequestsButton.height)/2
            anchors.left: addAccountButton.right
            text: qsTr("ACCOUNT CREATION REQUESTS")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { pageLoader.source = "MoneroLWSAccountRequestsScreen.qml" }
        }
    }

    Loader {
        id: pageLoader
        anchors.top: moneroLWSMenuBar.bottom
        anchors.left: moneroLWSMainScreen.left
        anchors.right: moneroLWSMainScreen.right
        anchors.bottom: moneroLWSMainScreen.bottom
        anchors.topMargin: 40
        source: "MoneroLWSActiveScreen.qml"
    }
}


