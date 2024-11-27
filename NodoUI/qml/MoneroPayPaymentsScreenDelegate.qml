import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    property int componentWidth: 600
    property int fieldTopMargin: 5
    color: "#1F1F1F"
    property int paymentIndex
    property int scanHeight: 0
    property int labelSize: 0
    property int paymentStatus
    property string transactionID
    property string timestamp
    property string description
    property string descriptionHTMLEncoded
    property double xmrAmount
    property double exchangeRate
    property int exchangeIndex
    property string exchangeName
    property string depositAddress
    property double fiatValue
    height: moneroPayReceivedRemovePaymentButton.height + moneroPayReceivedRemovePaymentButton.y + 15

    Connections {
        target: moneroPay
        function onPaymentReceived()
        {
            updatePaymentStatus()
        }
    }

    Component.onCompleted: {
        updatePaymentStatus()
    }

    function updatePaymentStatus() {
        xmrAmount = moneroPay.getPaymentAmount(paymentIndex)/1000000000000;
        paymentStatus = moneroPay.getPaymentStatus(paymentIndex)
        var dateTime = Qt.formatDateTime(moneroPay.getPaymentTimestamp(paymentIndex), "d MMM yyyy h:mm AP") + " UTC"
        timestamp = dateTime.toUpperCase()
        depositAddress = moneroPay.getPaymentDepositAddress(paymentIndex)
        description = moneroPay.getPaymentDescription(paymentIndex)
        descriptionHTMLEncoded = moneroPay.getDescriptionHTMLEncoded(paymentIndex)
        exchangeName = nodoCurrencies.currencyCodes[exchangeIndex]
        fiatValue = moneroPay.getFiatAmount(paymentIndex)
        createListModels()
    }

    function createListModels() {
        transactionIDListModel.clear()
        var pCount = moneroPay.transactionIDSize(paymentIndex)
        for (var index = 0; index < pCount; index++) {
            var pIndex = { "trID": moneroPay.getPaymentTransactionID(paymentIndex, index) }
            transactionIDListModel.append(pIndex)
        }
    }

    NodoInfoField {
        id: moneroPayReceivedPaymentStatusField
        anchors.top: mainRect.top
        anchors.left: mainRect.left
        anchors.topMargin: 15
        anchors.leftMargin: 8
        height: NodoSystem.nodoItemHeight
        itemSize: 180
        width: 495
        itemText: qsTr("Status")
        valueText: {
            if(paymentStatus === 1)
            {
                qsTr("Received")
            }
            else if (paymentStatus === 4)
            {
                qsTr("Not Received")
            }
            else {
                ""
            }
        }
    }

    NodoInfoField {
        id: moneroPayReceivedXMRValueField
        anchors.left: moneroPayReceivedPaymentStatusField.right
        anchors.top: moneroPayReceivedPaymentStatusField.top
        anchors.leftMargin: 5
        height: NodoSystem.nodoItemHeight
        itemSize: 120
        width: 500
        itemText: "XMR"
        valueText: xmrAmount.toFixed(12)
    }

    NodoInfoField {
        id: moneroPayReceivedFiatValueField
        anchors.left: moneroPayReceivedXMRValueField.right
        anchors.top: moneroPayReceivedPaymentStatusField.top
        anchors.leftMargin: 5
        height: NodoSystem.nodoItemHeight
        itemSize: 120
        width: 300
        itemText: exchangeName
        valueText: fiatValue.toFixed(2)
    }

    NodoInfoField {
        id: moneroPayReceivedTimestampField
        anchors.left: moneroPayReceivedFiatValueField.right
        anchors.top: moneroPayReceivedPaymentStatusField.top
        anchors.leftMargin: 5
        height: NodoSystem.nodoItemHeight
        itemSize: 220
        width: 560
        itemText: qsTr("Timestamp")
        valueText: timestamp
    }

    NodoInfoField {
        id: moneroPayReceivedDepositAddressField
        anchors.left: moneroPayReceivedPaymentStatusField.left
        anchors.top: moneroPayReceivedPaymentStatusField.bottom
        anchors.topMargin: fieldTopMargin
        height: NodoSystem.nodoItemHeight
        itemSize: 210
        width: 1880
        itemText: qsTr("Subaddress")
        valueText: depositAddress
        valueFontSize: 27
    }

    NodoCanvas {
        id: moneroPayReceivedTransactionIDField
        anchors.top: moneroPayReceivedDepositAddressField.bottom
        anchors.left: moneroPayReceivedPaymentStatusField.left
        width: 1880
        height: paymentsList.contentHeight
        anchors.topMargin: fieldTopMargin
        anchors.bottomMargin: 30
        color: "#1F1F1F"
        clip: true

        ListView {
            id: paymentsList
            anchors.left: moneroPayReceivedTransactionIDField.left
            anchors.top: moneroPayReceivedTransactionIDField.top
            anchors.right: moneroPayReceivedTransactionIDField.right
            anchors.bottom: moneroPayReceivedTransactionIDField.bottom
            model: transactionIDListModel
            delegate: Component {
                NodoInfoField {
                    id: infoField
                    height: NodoSystem.nodoItemHeight
                    itemSize: labelSize - 40
                    width: ListView.view.width
                    itemText: qsTr("Transaction ID")
                    valueText: model.trID

                }
            }

            spacing: fieldTopMargin
        }
    }

    NodoInfoField {
        id: moneroPayReceivedDescriptionField
        anchors.left: moneroPayReceivedPaymentStatusField.left
        anchors.top: moneroPayReceivedTransactionIDField.bottom
        anchors.topMargin: visible === true ? fieldTopMargin : 0
        height: visible === true ? NodoSystem.nodoItemHeight : 0
        itemSize: labelSize
        width: 1880
        visible: description.length > 0 ? true : false
        itemText: qsTr("Note")
        valueText: description
    }

    NodoButton {
        id: moneroPayReceivedRemovePaymentButton
        anchors.left: moneroPayReceivedPaymentStatusField.left
        anchors.top: moneroPayReceivedDescriptionField.bottom
        anchors.topMargin: fieldTopMargin
        text: qsTr("Clear Payment")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroPay.deletePayment(depositAddress)
        }
    }

    NodoButton {
        id: moneroPayReceivedQRCodeButton
        anchors.left: moneroPayReceivedRemovePaymentButton.right
        anchors.top: moneroPayReceivedRemovePaymentButton.top
        anchors.leftMargin: 25
        text: qsTr("View QR")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            mainRectPopup.qrCodeData = "monero:" + depositAddress + "?tx_amount=" + (xmrAmount)

            if(descriptionHTMLEncoded !== "")
            {
                mainRectPopup.qrCodeData = mainRectPopup.qrCodeData + "&tx_description=" + descriptionHTMLEncoded
            }

            mainRectPopup.closeButtonText = qsTr("Close")
            mainRectPopup.open();
        }
    }

    ListModel {
        id: transactionIDListModel
    }

    NodoQRCodePopup {
        id: mainRectPopup
    }
}
