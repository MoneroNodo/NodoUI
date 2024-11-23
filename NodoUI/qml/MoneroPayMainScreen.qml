import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
	  property bool syncDoneSyncDone: false
    id: moneroPayMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin
    signal setButtonState(bool state)

    Component.onCompleted: {
		if(100 === syncInfo.getSyncPercentage() && moneroPay.isDepositAddressSet())
        {
            paymentsButton.checked = false
            settingsButton.enabled = true
            receiveButton.enabled = true
            receiveButton.checked = true
            receiveButton.clicked()
        }
        else
        {
            paymentsButton.checked = true
            paymentsButton.enabled = true
            receiveButton.checked = false
            receiveButton.enabled = false
            settingsButton.enabled = true

            paymentsButton.clicked()
        }
    }

    Connections {
        target: syncInfo
        function onSyncDone() {
            moneroPayMainScreen.setButtonState(true);
        }
    }

    Connections{
        target: moneroPay
        function onOpenViewPaymentsScreenRequested()
        {
            paymentsButton.checked = true
            paymentsButton.clicked()
        }

        function onDepositAddressSet(address, viewkey)
        {
            if((address.length === 95) && (viewkey.length === 64)) {
                receiveButton.enabled = (100 === syncInfo.getSyncPercentage())
                if (receiveButton.enabled && moneroPayPageLoader.source === "MoneroPayReceiveMainScreen.qml")
                {
                    receiveButton.checked = true
                }
                moneroPay.setDepositAddressSet(true)

            }
            else
                moneroPay.setDepositAddressSet(false)
        }
    }

    TabBar {
        id: moneroPayMainMenuBar
        anchors.top: moneroPayMainScreen.top
        anchors.left: moneroPayMainScreen.left
        height: NodoSystem.subMenuButtonHeight
        contentWidth: 1400

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: receiveButton
            y: (moneroPayMainMenuBar.height - receiveButton.height)/2
            text: qsTr("RECEIVE")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { moneroPayPageLoader.source = "MoneroPayReceiveMainScreen.qml" }
            enabled: false
            Connections {
                target: receiveButton
                function onSetButtonState(state) {
                    receiveButton.enabled = (state && moneroPay.isDepositAddressSet())
                }
            }
        }
        NodoTabButton {
            id: paymentsButton
            anchors.top: receiveButton.top
            anchors.left: receiveButton.right
            text: qsTr("PAYMENTS")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { moneroPayPageLoader.source = "MoneroPayPaymentsScreen.qml" }
        }
        NodoTabButton {
            id: settingsButton
            anchors.top: receiveButton.top
            anchors.left: paymentsButton.right
            text: qsTr("SETTINGS")
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { moneroPayPageLoader.source = "MoneroPaySettingsMainScreen.qml" }
        }
    }

    Loader {
        id: moneroPayPageLoader
        anchors.top: moneroPayMainMenuBar.bottom
        anchors.left: moneroPayMainScreen.left
        anchors.right: moneroPayMainScreen.right
        anchors.bottom: moneroPayMainScreen.bottom
        anchors.topMargin: 40
        source: "MoneroPaySettingsMainScreen.qml"
    }
}

