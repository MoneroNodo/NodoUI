import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0
import QtWebView

Item {
    id: moneroPayReceivePaymentPreviewScreen

    property int labelSize: 300
    property int addressFieldWidth: width - NodoSystem.subMenuLeftMargin
    property double exchangeRate
    property string exchangeName
    property double xmrAmount
    property double fiatAmount
    property string qrCodeData
    property string description

    Component.onCompleted: {
        exchangeName = nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
        exchangeRate = priceTicker.getCurrency()
        xmrAmount = moneroPay.getLastXMRAmount()
        fiatAmount = moneroPay.getLastFiatAmount()
        description = moneroPay.getLastDescription();
        moneroPayDepositAddressField.valueText = moneroPay.getLastDepositAddress()
        timestampField.valueText = moneroPay.getLastTimestamp()
        xmrPreviewfield.valueText = xmrAmount.toFixed(12)
        fiatPreviewfield.valueText = fiatAmount.toFixed(2)


        qrCodeData = "monero:" + moneroPayDepositAddressField.valueText + "?tx_amount=" + (xmrAmount)

        var encodedDescription = moneroPay.getLastDescriptionHTMLEncoded()
        if(encodedDescription !== "")
        {
            qrCodeData = qrCodeData + "&tx_description=" + encodedDescription
        }
    }

    Rectangle {
        id: currenciesRect
        anchors.top: moneroPayReceivePaymentPreviewScreen.top
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        width: 1900
        height: 270 + NodoSystem.nodoTopMargin
        color: "black"

        NodoInfoField {
            id: xmrPreviewfield
            anchors.top: currenciesRect.top
            anchors.left: currenciesRect.left
            width: addressFieldWidth
            height: 135
            itemFontSize: 120
            valueFontSize: 120
            itemText: qsTr("XMR")
        }

        NodoInfoField {
            id: fiatPreviewfield
            anchors.top: xmrPreviewfield.bottom
            anchors.left: currenciesRect.left
            width: addressFieldWidth
            height: 135
            itemFontSize: 120
            valueFontSize: 120
            itemText: exchangeName
        }
    }

    NodoInfoField {
        id: moneroPayDepositAddressField
        anchors.top: currenciesRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        width: addressFieldWidth
        //itemSize: 230
        itemText: qsTr("Address")
        height: NodoSystem.nodoItemHeight
        valueFontSize: NodoSystem.descriptionTextFontSize
    }

    NodoInfoField {
        id: descriptionPreviewField
        anchors.top: moneroPayDepositAddressField.bottom
        anchors.topMargin: visible === true ? NodoSystem.nodoTopMargin : 0
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        width: addressFieldWidth
        height: visible === true ? NodoSystem.nodoItemHeight : 0
        itemSize: labelSize
        itemText: qsTr("Note")
        visible: description === "" ? false : true
        valueText: description
    }

    NodoInfoField {
        id: timestampField
        anchors.top: descriptionPreviewField.bottom
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        width: 460
        visible: true
        itemText: qsTr("Timestamp")
        valueText: ""
    }


    NodoLabel {
        id: sendPaymentLabel
        anchors.top: currenciesRect.top
        anchors.left: currenciesRect.left
        horizontalAlignment: Text.AlignLeft
        text: qsTr("Awaiting Payment")
        height: NodoSystem.nodoItemHeight
    }
    
    NodoButton {
        id: newPaymentButton
        anchors.top: timestampField.bottom //anchors.top: descriptionPreviewField.top
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("New Payment")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: true
        onClicked: {
            paymentPreviewPopup.commandID = 1
            paymentPreviewPopup.applyButtonText = newPaymentButton.text
            paymentPreviewPopup.open()
        }
    }

    Rectangle {
        id: qrCodeRect
        anchors.bottom: moneroPayReceivePaymentPreviewScreen.bottom
        anchors.right: moneroPayReceivePaymentPreviewScreen.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        color: "black"
        width: 512
        height: 512

        QtQuick2QREncode {
            id: qr
            width: qrCodeRect.width
            height: qrCodeRect.height
            qrSize: Qt.size(width,width)
            qrData: qrCodeData
            qrForeground: "black"
            qrBackground: "#F5F5F5"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }

    NodoPopup {
        id: paymentPreviewPopup
        onApplyClicked: {
            close()

            if (commandID === 1)
            {
                moneroPay.newPaymentRequest()
            }
        }
    }
}
