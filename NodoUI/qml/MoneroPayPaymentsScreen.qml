import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroPayPaymentsScreen
    anchors.fill: parent
    property int labelSize: 0

    function createListModels() {
        paymentsListModel.clear()
        var eRate = priceTicker.getCurrency()
        var eIndex = priceTicker.getCurrentCurrencyIndex()
        var pCount = moneroPay.getPaymentCount()
        for (var index = 0; index < pCount; index++) {
            var pIndex = { "paymentIndex": index, "exchangeRate": eRate, "exchangeIndex": eIndex}
            paymentsListModel.append(pIndex)
        }
    }

    Component.onCompleted: {
        createListModels()
    }

    Connections {
        target: moneroPay
        function onPaymentListReady()
        {
            createListModels()
        }
    }

    NodoButton {
        id: clearAllPaymentsButton
        anchors.top: moneroPayPaymentsScreen.top
        anchors.left: moneroPayPaymentsScreen.left
        text: qsTr("Clear All Payments")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: paymentsListModel.count > 0 ? true : false
        onClicked: {
            paymentsPopup.commandID = 0
            paymentsPopup.applyButtonText = "Apply"
            paymentsPopup.open()
        }
    }

    NodoCanvas {
        id: paymentsCanvas
        anchors.top: clearAllPaymentsButton.bottom
        anchors.left: moneroPayPaymentsScreen.left
        anchors.right: moneroPayPaymentsScreen.right
        anchors.bottom: moneroPayPaymentsScreen.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.bottomMargin: 30
        color: "black"
        clip: true

        ListView {
            id: paymentsList
            anchors.fill: parent
            model: paymentsListModel
            delegate: MoneroPayPaymentsScreenDelegate {
                id: paymentListDelegate
                paymentIndex: model.paymentIndex
                exchangeRate: model.exchangeRate
                exchangeIndex: model.exchangeIndex
                width: paymentsList.width
            }

            spacing: NodoSystem.nodoTopMargin
        }
    }

    ListModel {
        id: paymentsListModel
    }

    NodoPopup {
        id: paymentsPopup
        onApplyClicked: {
            if(commandID === 0)
            {
                moneroPay.clearAllPayments()
            }
            close()
        }
    }
}

