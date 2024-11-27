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
    property int addressFieldWidth: 1900
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


    Rectangle{
        id: qrCodeRect
        anchors.top: moneroPayReceivePaymentPreviewScreen.top
        anchors.topMargin: 1
        anchors.horizontalCenter: moneroPayReceivePaymentPreviewScreen.horizontalCenter
        color: "black"
        width: 480
        height: 480

        QtQuick2QREncode {
            id: qr
            width: qrCodeRect.width
            height: qrCodeRect.height
            qrSize: Qt.size(width,width)
            qrData: qrCodeData
            qrForeground: "black"
            qrBackground: "#FCFCFC"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }

    Rectangle {
        id: currenciesRect
        anchors.top: qrCodeRect.bottom
        anchors.topMargin: 2*(NodoSystem.nodoTopMargin) //+ 10
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        width: timestampField.x + timestampField.width
        height: timestampField.height
        color: "black"

        NodoLabel {
            id: sendPaymentLabel
            anchors.top: currenciesRect.top
            anchors.left: currenciesRect.left
            horizontalAlignment: Text.AlignLeft
            text: qsTr("Awaiting Payment")
            height: NodoSystem.nodoItemHeight
        }

        NodoInfoField {
            id: xmrPreviewfield
            anchors.top: currenciesRect.top
            anchors.left: sendPaymentLabel.right
            anchors.leftMargin: 15
            itemSize: 120
            width: 510
            height: NodoSystem.nodoItemHeight
            itemText: qsTr("XMR")
        }

        NodoInfoField {
            id: fiatPreviewfield
            anchors.top: currenciesRect.top
            anchors.left: xmrPreviewfield.right
            anchors.leftMargin: 5
            itemSize: 120
            width: 340
            height: NodoSystem.nodoItemHeight
            itemText: exchangeName
        }

        NodoInfoField {
            id: timestampField
            anchors.top: currenciesRect.top
            anchors.left: fiatPreviewfield.right
            anchors.leftMargin: 5
            height: NodoSystem.nodoItemHeight
            itemSize: 220
            width: 460
            visible: true
            itemText: qsTr("Timestamp")
            valueText: ""
        }
    }

    NodoInfoField {
        id: moneroPayDepositAddressField
        anchors.top: currenciesRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        width: addressFieldWidth
        itemSize: 230
        itemText: qsTr("Subaddress")
        height: NodoSystem.nodoItemHeight
        valueFontSize: 27
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

    NodoButton {
        id: newPaymentButton
        anchors.top: descriptionPreviewField.top
        anchors.horizontalCenter: moneroPayReceivePaymentPreviewScreen.horizontalCenter
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("New Payment")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: true
        onClicked: {
            paymentPreviewPopup.commandID = 1
            paymentPreviewPopup.applyButtonText = newPaymentButton.text
            paymentPreviewPopup.open()
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
