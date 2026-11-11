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
    anchors.topMargin: NodoSystem.subMenuTopMargin
    
    signal setButtonState(bool state)

    function updateButtons()
    {
        settingsButton.enabled = true
		if(100 === syncInfo.getSyncPercentage() && moneroPay.isDepositAddressSet())
        {
            receiveButton.enabled = true
            paymentsButton.enabled = true
            receiveButton.clicked()
        }
        else
        {
            receiveButton.enabled = false
            paymentsButton.enabled = false
            paymentsButton.clicked()
        }
    }

    Component.onCompleted: {
        updateButtons();
    }

    Connections {
        target: syncInfo
        function onSyncDone() {
            moneroPayMainScreen.setButtonState(true);
            updateButtons();
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
        width: 1360

        background: Rectangle {
            color: "black"
        }

        NodoTabButton {
            id: receiveButton
            y: (moneroPayMainMenuBar.height - receiveButton.height)/2
            text: qsTr("RECEIVE")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { moneroPayPageLoader.source = "MoneroPayReceiveMainScreen.qml" }
            enabled: true
            Connections {
                target: moneroPayMainScreen
                function onSetButtonState(state) {
                    receiveButton.enabled = (state && moneroPay.isDepositAddressSet())
                }
            }
        }
        NodoTabButton {
            id: paymentsButton
            y: receiveButton.y
            anchors.leftMargin: NodoSystem.nodoTopMargin
            anchors.left: receiveButton.right
            text: qsTr("PAYMENTS")
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            onClicked: { moneroPayPageLoader.source = "MoneroPayPaymentsScreen.qml" }
        }
        NodoTabButton {
            id: settingsButton
            y: receiveButton.y
            anchors.leftMargin: NodoSystem.nodoTopMargin
            anchors.left: paymentsButton.right
            text: qsTr("SETTINGS")
            font.family: NodoSystem.fontInter.name
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
        source: "MoneroPayPaymentsScreen.qml"
    }
}
