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

    property int labelSize: 240
    property int addressFieldWidth: 1240
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
        id: currenciesTransferredRect
        anchors.top: moneroPayReceivePaymentResultScreen.top
        anchors.left: moneroPayReceivePaymentResultScreen.left
        width: 1900
        height: 220 + NodoSystem.nodoTopMargin
        color: "black"

        NodoInfoField {
            id: xmrTransferredfield
            anchors.top: currenciesTransferredRect.top
            anchors.left: currenciesTransferredRect.left
            height: 110
            itemSize: labelSize
            width: addressFieldWidth
            itemFontSize: 95
            valueFontSize: 95
            itemText: qsTr("XMR")
            valueText: ""
        }

        NodoInfoField {
            id: fiatTransferredfield
            anchors.top: currenciesTransferredRect.top
            anchors.left: currenciesTransferredRect.left
            anchors.topMargin: NodoSystem.nodoTopMargin
            height: 110
            itemSize: labelSize
            width: addressFieldWidth
            itemFontSize: 95
            valueFontSize: 95
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
        id: descriptionTransferredfield
        anchors.top: currenciesTransferredRect.bottom
        anchors.left: moneroPayReceivePaymentResultScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: addressFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Note")
        valueText: "sample desc"
    }

    Rectangle {
        id: tmpRect
        anchors.top: currenciesTransferredRect.bottom
        anchors.left: moneroPayReceivePaymentResultScreen.left
        //anchors.horizontalCenter: moneroPayReceivePaymentResultScreen.horizontalCenter
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        width: 1240
        height: gotoViewPaymentsButton.height
        color: "black"

        NodoLabel {
            id: paymentSuccessLabel
            anchors.top: tmpRect.top
            anchors.left: tmpRect.left
            anchors.topMargin: NodoSystem.nodoTopMargin
            horizontalAlignment: Text.AlignLeft
            text: qsTr("Payment Received")
            height: NodoSystem.nodoItemHeight
            font.pixelSize: NodoSystem.buttonTextFontSize
        }

        NodoButton {
            id: gotoNewPaymentButton
            anchors.top: tmpRect.top
            anchors.left: paymentSuccessLabel.right
            anchors.leftMargin: NodoSystem.subMenuLeftMargin
            text: qsTr("New Payment")
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
            anchors.top: tmpRect.top
            anchors.left: gotoNewPaymentButton.right
            anchors.leftMargin: NodoSystem.subMenuLeftMargin
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: qsTr("View Payments")
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

    Rectangle {
        id: paymentSuccess
        anchors.top: moneroPayReceivePaymentResultScreen.top
        anchors.right: moneroPayReceivePaymentResultScreen.right
        anchors.rightMargin: 10
        width: 600
        height: 600
        color: "black"

        WebView {
            id: paymentSuccessAnim
            anchors.fill: parent
            enabled: false
            url: "qrc:/Images/MPAY_tick.html"
        }
    }

    NodoInfoField {
        id: transactionIDTransferredField
        anchors.bottom: receivedDepositAddressField.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.left: moneroPayReceivePaymentResultScreen.left
        height: NodoSystem.nodoItemHeight
        width: addressFieldWidth
        itemSize: labelSize
        itemText: qsTr("Transaction ID")
        valueText: ""
    }

    NodoInfoField {
        id: receivedDepositAddressField
        anchors.top: moneroPayReceivePaymentResultScreen.bottom
        anchors.left: moneroPayReceivePaymentResultScreen.left
        //anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        itemSize: 230
        width: addressFieldWidth
        itemText: qsTr("Address")
        valueText: ""
        valueFontSize: 30
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

