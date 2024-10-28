import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0
import QtWebView

Item {
    id: moneroPayReceivePaymentResultScreen

    property int labelSize: 300
    property int addressFieldWidth: 1850
    property double exchangeRate
    property string exchangeName
    property double xmrAmount
    property double fiatAmount
    property string qrCodeData
    property int transactionID
    property string description

    Component.onCompleted: {
        exchangeName = nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
        exchangeRate = priceTicker.getCurrency()
        xmrAmount = moneroPay.getLastXMRAmount()
        fiatAmount = moneroPay.getLastFiatAmount()
        xmrTransferredfield.valueText = xmrAmount.toFixed(12)
        fiatTransferredfield.valueText = fiatAmount.toFixed(2)

        receivedDepositAddressField.valueText = moneroPay.getLastDepositAddress()
        transactionIDTransferredField.valueText = moneroPay.getLastTransactionID()
        descriptionTransferredfield.valueText = moneroPay.getLastDescription()
        receivedTimestampField.valueText = moneroPay.getLastTimestamp()
    }

    Rectangle {
        id: paymentSuccess
        anchors.top: moneroPayReceivePaymentResultScreen.top
        anchors.horizontalCenter: moneroPayReceivePaymentResultScreen.horizontalCenter
        width: 400
        height: 400
        color: "black"

        WebView {
            id: paymentSuccessAnim
            anchors.fill: parent
            enabled: false
            url: "qrc:/Images/MPAY_tick.html"
        }
    }

    Rectangle {
        id: currenciesTransferredRect
        anchors.top: paymentSuccess.bottom
        anchors.topMargin: 2*(NodoSystem.nodoTopMargin)
        anchors.left: moneroPayReceivePaymentResultScreen.left
        width: receivedTimestampField.x + receivedTimestampField.width
        height: receivedTimestampField.height
        color: "black"

        NodoLabel {
            id: completeLabel
            anchors.top: currenciesTransferredRect.top
            anchors.left: currenciesTransferredRect.left
            horizontalAlignment: Text.AlignLeft
            text: qsTr("Payment Received")
            height: 64
        }

        NodoInfoField {
            id: xmrTransferredfield
            anchors.top: currenciesTransferredRect.top
            anchors.left: completeLabel.right
            anchors.leftMargin: 15
            itemSize: 90
            width: 390
            height: NodoSystem.nodoItemHeight
            itemText: qsTr("XMR")
            valueText: ""
        }

        NodoInfoField {
            id: fiatTransferredfield
            anchors.top: currenciesTransferredRect.top
            anchors.left: xmrTransferredfield.right
            anchors.leftMargin: 15
            itemSize: 90
            width: 390
            height: NodoSystem.nodoItemHeight
            itemText: exchangeName
            valueText: ""
        }


        NodoInfoField {
            id: receivedTimestampField
            anchors.top: currenciesTransferredRect.top
            anchors.left: fiatTransferredfield.right
            anchors.leftMargin: 15
            height: NodoSystem.nodoItemHeight
            itemSize: 0
            width: 725
            visible: true
            itemText: qsTr("Timestamp")
            valueText: xmrAmount
        }
    }

    NodoInfoField {
        id: receivedDepositAddressField
        anchors.top: currenciesTransferredRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        width: addressFieldWidth
        itemText: qsTr("Deposit Address")
        valueText: ""
    }

    NodoInfoField {
        id: transactionIDTransferredField
        anchors.top: receivedDepositAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        width: addressFieldWidth
        itemSize: labelSize
        itemText: qsTr("Transaction ID")
        valueText: ""
    }

    NodoInfoField {
        id: descriptionTransferredfield
        anchors.top: transactionIDTransferredField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: addressFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Note")
        valueText: "sample desc"
    }

    Rectangle {
        id: tmpRect
        anchors.top: descriptionTransferredfield.bottom
        anchors.horizontalCenter: moneroPayReceivePaymentResultScreen.horizontalCenter
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: gotoViewPaymentsButton.x + gotoViewPaymentsButton.width
        height: gotoViewPaymentsButton.height
        color: "black"

        NodoButton {
            id: gotoNewPaymentButton
            anchors.top: tmpRect.top
            anchors.left: tmpRect.left
            text: qsTr("New Payment")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: true
            onClicked: {
                receivedPaymentPopup.commandID = 0
                receivedPaymentPopup.applyButtonText = gotoNewPaymentButton.text
                receivedPaymentPopup.open()
            }
        }

        NodoButton {
            id: gotoViewPaymentsButton
            anchors.top: tmpRect.top
            anchors.left: gotoNewPaymentButton.right
            anchors.leftMargin: 25
            text: qsTr("View Payments")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: true
            onClicked: {
                receivedPaymentPopup.commandID = 1
                receivedPaymentPopup.applyButtonText = gotoViewPaymentsButton.text
                receivedPaymentPopup.open()
            }
        }
    }

    NodoPopup {
        id: receivedPaymentPopup
        onApplyClicked: {
            close()
            if(commandID === 0)
            {
                moneroPay.newPaymentRequest()
            }
            else if(commandID === 1)
            {
                moneroPay.openViewPaymentsScreenRequest()
            }
        }
    }
}

