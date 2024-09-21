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
    color: "#141414"
    property int paymentIndex
    property int scanHeight: 0
    property int labelSize: 0
    property int paymentStatus
    property string transactionID
    property string timestamp
    property string description
    property double xmrAmount
    property double exchangeRate
    property int exchangeIndex
    property string exchangeName
    property string depositAddress
    property double fiatValue
    height: moneroPayReceivedClearPaymentField.height + moneroPayReceivedClearPaymentField.y + 15

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
        anchors.leftMargin: 15
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        width: 455
        itemText: qsTr("Status")
        valueText: {
            if(paymentStatus === 1)
            {
                qsTr("Received")
            }
            else if(paymentStatus === 2)
            {
                qsTr("Pending")
            }
            else if(paymentStatus === 3)
            {
                qsTr("Cancelled")
            }
            else {
                qsTr("Unknown")
            }
        }
    }

    NodoInfoField {
        id: moneroPayReceivedXMRValueField
        anchors.left: moneroPayReceivedPaymentStatusField.right
        anchors.top: moneroPayReceivedPaymentStatusField.top
        anchors.leftMargin: 5
        height: NodoSystem.infoFieldLabelHeight
        itemSize: 90
        width: 390
        itemText: "XMR"
        valueText: xmrAmount.toFixed(12)
    }

    NodoInfoField {
        id: moneroPayReceivedFiatValueField
        anchors.left: moneroPayReceivedXMRValueField.right
        anchors.top: moneroPayReceivedPaymentStatusField.top
        anchors.leftMargin: 5
        height: NodoSystem.infoFieldLabelHeight
        itemSize: 90
        width: 390
        itemText: exchangeName
        valueText: fiatValue.toFixed(2)
    }

    NodoInfoField {
        id: moneroPayReceivedTimestampField
        anchors.left: moneroPayReceivedFiatValueField.right
        anchors.top: moneroPayReceivedPaymentStatusField.top
        anchors.leftMargin: 5
        height: NodoSystem.infoFieldLabelHeight
        itemSize: 220
        width: 600
        itemText: qsTr("Timestamp")
        valueText: timestamp
    }

    NodoInfoField {
        id: moneroPayReceivedDepositAddressField
        anchors.left: moneroPayReceivedPaymentStatusField.left
        anchors.top: moneroPayReceivedPaymentStatusField.bottom
        anchors.topMargin: fieldTopMargin
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        width: 1850
        itemText: qsTr("Deposit Address")
        valueText: depositAddress
    }

    NodoCanvas {
        id: moneroPayReceivedTransactionIDField
        anchors.top: moneroPayReceivedDepositAddressField.bottom
        anchors.left: moneroPayReceivedPaymentStatusField.left
        width: 1850
        height: paymentsList.contentHeight
        anchors.topMargin: fieldTopMargin
        anchors.bottomMargin: 30
        color: "#141414"
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
                    height: NodoSystem.infoFieldLabelHeight
                    itemSize: labelSize
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
        height: visible === true ? NodoSystem.infoFieldLabelHeight : 0
        itemSize: labelSize
        width: 1850
        visible: description.length > 0 ? true : false
        itemText: qsTr("Description")
        valueText: description
    }

    NodoButton {
        id: moneroPayReceivedCancelPaymentField
        anchors.left: moneroPayReceivedPaymentStatusField.left
        anchors.top: moneroPayReceivedDescriptionField.bottom
        anchors.topMargin: visible === true ? fieldTopMargin : 0
        text: qsTr("Cancel Payment")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        visible: paymentStatus === 2 ? true : false
        onClicked: {
            moneroPay.cancelPayment(depositAddress)
            isActive = false
        }
    }

    NodoButton {
        id: moneroPayReceivedClearPaymentField
        anchors.left: moneroPayReceivedCancelPaymentField.visible ? moneroPayReceivedCancelPaymentField.right : moneroPayReceivedPaymentStatusField.left
        anchors.top: moneroPayReceivedDescriptionField.bottom
        anchors.topMargin: fieldTopMargin
        anchors.leftMargin: moneroPayReceivedCancelPaymentField.visible ? 15 : 0
        text: qsTr("Clear Payment")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroPay.deletePayment(paymentIndex)
        }
    }

    ListModel {
        id: transactionIDListModel
    }
}
