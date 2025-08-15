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

    property int labelSize: 240
    property int addressFieldWidth: 1240//width - NodoSystem.subMenuLeftMargin
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
        var dateTime;
        if (nodoControl.is24hEnabled())
            dateTime = Qt.formatDateTime(moneroPay.getLastTimestamp(), "d MMM hh:mm") + " UTC"
        else
            dateTime = Qt.formatDateTime(moneroPay.getLastTimestamp(), "d MMM h:mm AP") + " UTC"
        timestampField.valueText = dateTime;
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
        height: 220 + NodoSystem.nodoTopMargin
        color: "black"

        NodoInfoField {
            id: xmrPreviewfield
            anchors.top: currenciesRect.top
            anchors.left: currenciesRect.left
            width: addressFieldWidth
            itemSize: labelSize
            height: 110
            itemFontSize: 95
            valueFontSize: 95
            itemText: qsTr("XMR")
        }

        NodoInfoField {
            id: fiatPreviewfield
            anchors.top: xmrPreviewfield.bottom
            anchors.left: currenciesRect.left
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: addressFieldWidth
            itemSize: labelSize
            height: 110
            itemFontSize: 95
            valueFontSize: 95
            itemText: exchangeName
        }
    }

    NodoInfoField {
        id: descriptionPreviewField
        anchors.top: currenciesRect.bottom
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
        width: 740
        visible: true
        itemText: qsTr("Timestamp")
        valueText: ""
    }

    NodoLabel {
        id: sendPaymentLabel
        anchors.top: timestampField.bottom
        anchors.left: currenciesRect.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        horizontalAlignment: Text.AlignLeft
        text: qsTr("Awaiting Payment")
        height: NodoSystem.nodoItemHeight
        font.pixelSize: NodoSystem.buttonTextFontSize
    }

    NodoButton {
        id: newPaymentButton
        anchors.top: timestampField.bottom
        anchors.left: sendPaymentLabel.right
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.leftMargin: NodoSystem.subMenuLeftMargin
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
        anchors.top: moneroPayReceivePaymentPreviewScreen.top
        anchors.right: moneroPayReceivePaymentPreviewScreen.right
        anchors.rightMargin: 10 
        color: "black"
        width: 640
        height: 640

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

    NodoInfoField {
        id: moneroPayDepositAddressField
        anchors.top: qrCodeRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.left: moneroPayReceivePaymentPreviewScreen.left
        width: parent.width - NodoSystem.subMenuLeftMargin
        itemSize: labelSize - 120
        itemText: qsTr("Address")
        height: NodoSystem.nodoItemHeight
        valueFontSize: 30
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
