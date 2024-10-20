import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0
import QtWebView

Item {
    id: moneroPayReceiveMainScreen
    anchors.fill: parent
    property bool paymentReceivedScreenDisplayable: false

    StackView {
        id: moneroPayReceiveMainStackView
        anchors.fill: moneroPayReceiveMainScreen
        initialItem: "MoneroPayReceiveRequestScreen.qml"

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 0
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 0
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 0
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 0
            }
        }
    }

    Connections {
        target: moneroPay
        function onDepositAddressReceived() {
            paymentReceivedScreenDisplayable = true
            moneroPayReceiveMainStackView.pop()
            moneroPayReceiveMainStackView.push("MoneroPayReceivePaymentPreviewScreen.qml")
        }

        function onNewPaymentRequested() {
            paymentReceivedScreenDisplayable = false
            moneroPayReceiveMainStackView.pop()
            moneroPayReceiveMainStackView.push("MoneroPayReceiveRequestScreen.qml")
        }

        function onPaymentReceived() {
            if(true === paymentReceivedScreenDisplayable)
            {
                moneroPayReceiveMainStackView.pop()
                moneroPayReceiveMainStackView.push("MoneroPayReceivePaymentResultScreen.qml")
            }
        }
    }
}



