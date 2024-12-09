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
    property int addressFieldWidth: 1900
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
        width: 512
        height: 512
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
            height: NodoSystem.nodoItemHeight
        }

        NodoInfoField {
            id: xmrTransferredfield
            anchors.top: currenciesTransferredRect.top
            anchors.left: completeLabel.right
            anchors.leftMargin: 15
            itemSize: 120
            width: 510
            height: NodoSystem.nodoItemHeight
            itemText: qsTr("XMR")
            valueText: ""
        }

        NodoInfoField {
            id: fiatTransferredfield
            anchors.top: currenciesTransferredRect.top
            anchors.left: xmrTransferredfield.right
            anchors.leftMargin: 5
            itemSize: 120
            width: 340
            height: NodoSystem.nodoItemHeight
            itemText: exchangeName
            valueText: ""
        }


        NodoInfoField {
            id: receivedTimestampField
            anchors.top: currenciesTransferredRect.top
            anchors.left: fiatTransferredfield.right
            anchors.leftMargin: 5
            height: NodoSystem.nodoItemHeight
            itemSize: 220
            width: 340
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
        itemSize: 230
        width: addressFieldWidth
        itemText: qsTr("Subaddress")
        valueText: ""
        valueFontSize: 28
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
        anchors.top: moneroPayReceivePaymentResultScreen.top
        anchors.left: moneroPayReceivePaymentResultScreen.left
        //anchors.horizontalCenter: moneroPayReceivePaymentResultScreen.horizontalCenter
        //anchors.topMargin: NodoSystem.nodoTopMargin
        width: gotoViewPaymentsButton.x + gotoViewPaymentsButton.width
        height: gotoViewPaymentsButton.height
        color: "black"

        NodoButton {
            id: gotoNewPaymentButton
            anchors.top: tmpRect.top
            anchors.left: tmpRect.left
            text: qsTr("New Payment")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontInter.name
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
            //anchors.top: tmpRect.top
            //anchors.left: gotoNewPaymentButton.right
            //anchors.leftMargin: 25
            anchors.top: gotoNewPaymentButton.bottom
            anchors.left: tmpRect.left
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: qsTr("View Payments")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontInter.name
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

