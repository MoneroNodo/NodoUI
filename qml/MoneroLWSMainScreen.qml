import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: moneroLWSMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    TabBar {
        id: moneroLWSMenuBar
        anchors.top: moneroLWSMainScreen.top
        anchors.left: moneroLWSMainScreen.left
        height: NodoSystem.topMenuButtonHeight

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
        anchors.topMargin: 20
        source: "MoneroLWSActiveScreen.qml"
    }
}


