import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0
import QtWebView

Item {
    id: moneroPayReceiveScreen
    anchors.fill: parent

    property int labelSize: 300
    property int inputFieldWidth: 600
    property int addressFieldWidth: 1850
    property double exchangeRate
    property double xmrAmount
    property string exchangeName
    property string paymentSuccessTick
    property string qrCodeData
    property int transactionID
    property bool cancelPaymentPopupIsOpen: false

    signal pageChangeRequested()

    Connections {
        target: priceTicker
        function onCurrencyReceived() {
            exchangeName = nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
            exchangeRate = priceTicker.getCurrency()
        }
    }

    Component.onCompleted: {
        exchangeName = nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
        exchangeRate = priceTicker.getCurrency()
    }

    Connections {
        target: moneroPay
        function onDepositAddressReceived() {
            transactionID = moneroPay.getLastPaymentID()
            var subaddress = moneroPay.getReceivedDepositAddress()
            var dateTime = Qt.formatDateTime(moneroPay.getTime(), "d MMM yyyy h:mm AP") + " UTC"
            timestampField.valueText = dateTime.toUpperCase()
            moneroPayDepositAddressField.valueText = subaddress

            qrCodeData = "monero:" + subaddress + "?tx_amount=" + (xmrAmount)

            var encodedDescription = moneroPay.getReceivedDescriptionHTMLEncoded()
            if(encodedDescription !== "")
            {
                qrCodeData = qrCodeData + "&tx_description=" + encodedDescription
            }
        }

        function onPaymentReceived() {
            if(cancelPaymentPopupIsOpen)
            {
                paymentsPopup.close()
            }

            var receivedXMR = moneroPay.getReceivedAmount()
            xmrTransferredfield.valueText = receivedXMR.toFixed(12)
            fiatTransferredfield.valueText = (receivedXMR*exchangeRate).toFixed(2)
            var dateTime = Qt.formatDateTime(moneroPay.getReceivedTimestamp(), "d MMM yyyy h:mm AP") + " UTC"
            receivedTimestampField.valueText = dateTime.toUpperCase()
            receivedDepositAddressField.valueText = moneroPay.getReceivedDepositAddress()
            transactionIDTransferredField.valueText = moneroPay.getReceivedTransactionID()
            descriptionTransferredfield.valueText = moneroPay.getReceivedDescription()

            paymentPreviewRect.visible = false
            paymentResultRect.visible = true

            paymentSuccessAnim.reload()
        }
    }

    Rectangle {
        id: requestAmountRect //screen1
        anchors.fill: parent
        color: "black"
        visible: true

        Rectangle {
            id: requestCurrenciesRect
            anchors.top: requestAmountRect.top
            anchors.left: requestAmountRect.left
            width: fiatRequestfield.x + fiatRequestfield.width
            height: fiatRequestfield.height
            color: "black"

            NodoInputField {
                id: xmrRequestfield
                anchors.top: requestCurrenciesRect.top
                anchors.left: requestCurrenciesRect.left
                itemSize: 90
                width: 390
                height: NodoSystem.infoFieldLabelHeight
                itemText: qsTr("XMR")
                valueText: "0.00"
                textFlag: Qt.ImhDigitsOnly

                onTextEditFinished: {
                    if(valueText === "")
                    {
                        valueText = 0.0
                    }

                    xmrAmount = parseFloat(xmrRequestfield.valueText)

                    if(xmrAmount > 9000000)
                    {
                        xmrAmount = 0.0
                        paymentsPopup.commandID = -1
                        paymentsPopup.applyButtonText = qsTr("Value out of range")
                        paymentsPopup.open()
                    }
                    fiatRequestfield.valueText = (xmrAmount*exchangeRate).toFixed(2)
                }

            }

            NodoInputField {
                id: fiatRequestfield
                anchors.top: requestCurrenciesRect.top
                anchors.left: xmrRequestfield.right
                anchors.leftMargin: 25
                itemSize: 90
                width: 390
                height: NodoSystem.infoFieldLabelHeight
                itemText: moneroPayReceiveScreen.exchangeName
                valueText: "0.00"
                textFlag: Qt.ImhDigitsOnly

                onTextEditFinished: {
                    if(valueText === "")
                    {
                        valueText = 0.0
                    }

                    xmrAmount = (parseFloat(fiatRequestfield.valueText)/exchangeRate)

                    if(xmrAmount > 9000000)
                    {
                        xmrAmount = 0.0
                        paymentsPopup.commandID = -1
                        paymentsPopup.applyButtonText = qsTr("Value out of range")
                        paymentsPopup.open()
                    }

                    xmrRequestfield.valueText = xmrAmount.toFixed(12)
                }
            }
        }

        Rectangle {
            id: blockConfirmationsRect
            anchors.left: requestAmountRect.left
            anchors.top: requestCurrenciesRect.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            anchors.right: descriptionInputfield.right
            height: NodoSystem.nodoItemHeight
            color: "black"

            NodoLabel{
                id: blockConfirmationsSliderLabel
                anchors.left: blockConfirmationsRect.left
                anchors.top: blockConfirmationsRect.top
                height: blockConfirmationsRect.height
                text: qsTr("Block Confirmations")
            }

            NodoLabel{
                id: blockConfirmationsSliderValueLabel
                anchors.left: blockConfirmationsSliderLabel.right
                anchors.top: blockConfirmationsRect.top
                height: blockConfirmationsRect.height
                text: blockConfirmationsSlider.value
                width: 64
                backgroundColor: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
            }

            NodoSlider {
                id: blockConfirmationsSlider
                anchors.left: blockConfirmationsSliderValueLabel.right
                anchors.top: blockConfirmationsRect.top
                anchors.leftMargin: NodoSystem.padding
                width: 836
                height: blockConfirmationsRect.height
                snapMode: Slider.SnapAlways
                stepSize: 1
                from: 0
                value: moneroPay.getDefaultBlockConfirmations()
                to: 10
                handleHight: height*0.8
                handleWidth: handleHight
                onValueChanged: {
                }
            }

            NodoLabel{
                id: blockConfirmationsDescriptionLabel
                anchors.left: blockConfirmationsSlider.right
                anchors.right: blockConfirmationsRect.right
                anchors.top: blockConfirmationsRect.top
                anchors.leftMargin: 15
                height: blockConfirmationsRect.height
                text: qsTr("Set to 0 for instant confirmations, default is 10")
            }
        }

        NodoInputField {
            id: descriptionInputfield
            anchors.top: blockConfirmationsRect.bottom
            anchors.left: requestAmountRect.left
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: addressFieldWidth
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Note (optional)")
            valueText: ""
        }

        NodoButton {
            id: receivePaymentButton
            anchors.top: descriptionInputfield.bottom
            anchors.left: requestAmountRect.left
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: qsTr("Receive Payment")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: xmrAmount === 0 ? false : true
            onClicked: {
                moneroPay.xmrRequestPayment(xmrRequestfield.valueText, fiatRequestfield.valueText, priceTicker.getCurrentCurrencyIndex(), descriptionInputfield.valueText, blockConfirmationsSlider.value)
                requestAmountRect.visible = false
                paymentPreviewRect.visible = true
            }
        }
    }

    Rectangle {
        id: paymentPreviewRect //screen2
        anchors.fill: parent
        color: "black"
        visible: false

        Rectangle{
            id: qrCodeRect
            anchors.top: paymentPreviewRect.top
            anchors.horizontalCenter: paymentPreviewRect.horizontalCenter
            color: "black"
            width: 450
            height: 450

            QtQuick2QREncode {
                id: qr
                width: qrCodeRect.width
                height: qrCodeRect.height
                qrSize: Qt.size(width,width)
                qrData: qrCodeData
                qrForeground: "black"
                qrBackground: "white"
                qrMargin: 8
                qrMode: QtQuick2QREncode.MODE_8    //encode model
                qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
            }
        }

        Rectangle {
            id: currenciesRect
            anchors.top: qrCodeRect.bottom
            anchors.topMargin: 2*(NodoSystem.nodoTopMargin)
            anchors.left: paymentPreviewRect.left
            width: timestampField.x + timestampField.width
            height: timestampField.height
            color: "black"

            NodoLabel {
                id: sendPaymentLabel
                anchors.top: currenciesRect.top
                anchors.left: currenciesRect.left
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Awaiting Payment")
                height: 64
            }

            NodoInfoField {
                id: xmrPreviewfield
                anchors.top: currenciesRect.top
                anchors.left: sendPaymentLabel.right
                anchors.leftMargin: 15
                itemSize: 90
                width: 390
                height: NodoSystem.infoFieldLabelHeight
                itemText: qsTr("XMR")
                valueText: xmrRequestfield.valueText
            }

            NodoInfoField {
                id: fiatPreviewfield
                anchors.top: currenciesRect.top
                anchors.left: xmrPreviewfield.right
                anchors.leftMargin: 15
                itemSize: 90
                width: 390
                height: NodoSystem.infoFieldLabelHeight
                itemText: moneroPayReceiveScreen.exchangeName
                valueText: fiatRequestfield.valueText
            }

            NodoInfoField {
                id: timestampField
                anchors.top: currenciesRect.top
                anchors.left: fiatPreviewfield.right
                anchors.leftMargin: 15
                height: NodoSystem.infoFieldLabelHeight
                itemSize: 0
                width: 725
                visible: true
                itemText: qsTr("Timestamp")
                valueText: ""
            }
        }

        NodoInfoField {
            id: moneroPayDepositAddressField
            anchors.top: currenciesRect.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            anchors.left: paymentPreviewRect.left
            width: addressFieldWidth
            itemSize: labelSize
            itemText: qsTr("Deposit Address")
            height: NodoSystem.infoFieldLabelHeight
        }

        NodoInfoField {
            id: descriptionPreviewField
            anchors.top: moneroPayDepositAddressField.bottom
            anchors.topMargin: visible === true ? NodoSystem.nodoTopMargin : 0
            anchors.left: paymentPreviewRect.left
            width: addressFieldWidth
            height: visible === true ? NodoSystem.infoFieldLabelHeight : 0
            itemSize: labelSize
            itemText: qsTr("Description")
            visible: descriptionInputfield.valueText === "" ? false : true
            valueText: descriptionInputfield.valueText
        }

        Rectangle {
            id: previewButtonsRect
            anchors.top: descriptionPreviewField.bottom
            anchors.horizontalCenter: paymentPreviewRect.horizontalCenter
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: newPaymentButton.x + newPaymentButton.width
            height: newPaymentButton.height
            color: "black"


            NodoButton {
                id: cancelPaymentButton
                anchors.top: previewButtonsRect.top
                anchors.left: previewButtonsRect.left
                text: qsTr("Cancel Payment")
                height: NodoSystem.nodoItemHeight
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.buttonTextFontSize
                isActive: true
                onClicked: {
                    cancelPaymentPopupIsOpen = true
                    paymentsPopup.commandID = 0
                    paymentsPopup.applyButtonText = cancelPaymentButton.text
                    paymentsPopup.open()

                }
            }

            NodoButton {
                id: newPaymentButton
                anchors.top: previewButtonsRect.top
                anchors.left: cancelPaymentButton.right
                anchors.leftMargin: 25
                text: qsTr("New Payment")
                height: NodoSystem.nodoItemHeight
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.buttonTextFontSize
                isActive: true
                onClicked: {
                    paymentsPopup.commandID = 1
                    paymentsPopup.applyButtonText = newPaymentButton.text
                    paymentsPopup.open()
                }
            }
        }
    }

    Rectangle {
        id: paymentResultRect //screen3
        anchors.fill: parent
        color: "black"
        visible: false

        Rectangle {
            id: paymentSuccess
            anchors.top: paymentResultRect.top
            anchors.horizontalCenter: paymentResultRect.horizontalCenter
            width: 450
            height: 450
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
            anchors.left: paymentResultRect.left
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
                height: NodoSystem.infoFieldLabelHeight
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
                height: NodoSystem.infoFieldLabelHeight
                itemText: moneroPayReceiveScreen.exchangeName
                valueText: ""
            }


            NodoInfoField {
                id: receivedTimestampField
                anchors.top: currenciesTransferredRect.top
                anchors.left: fiatTransferredfield.right
                anchors.leftMargin: 15
                height: NodoSystem.infoFieldLabelHeight
                itemSize: 0
                width: 725
                visible: true
                itemText: qsTr("Timestamp")
                valueText: ""
            }
        }

        NodoInfoField {
            id: receivedDepositAddressField
            anchors.top: currenciesTransferredRect.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            width: 1850
            itemText: qsTr("Deposit Address")
            valueText: ""
        }

        NodoInfoField {
            id: transactionIDTransferredField
            anchors.top: receivedDepositAddressField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            height: NodoSystem.infoFieldLabelHeight
            width: 1850
            itemSize: labelSize
            itemText: qsTr("Transaction ID")
            valueText: ""
        }

        NodoInfoField {
            id: descriptionTransferredfield
            anchors.top: transactionIDTransferredField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: addressFieldWidth
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Description")
            valueText: "sample desc"
        }

        Rectangle {
            id: tmpRect
            anchors.top: descriptionTransferredfield.bottom
            anchors.horizontalCenter: paymentResultRect.horizontalCenter
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
                    paymentsPopup.commandID = 2
                    paymentsPopup.applyButtonText = gotoNewPaymentButton.text
                    paymentsPopup.open()
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
                    paymentsPopup.commandID = 3
                    paymentsPopup.applyButtonText = gotoViewPaymentsButton.text
                    paymentsPopup.open()
                }
            }
        }
    }

    // Timer {
    //     id: dateTimer
    //     interval: 10000
    //     running: true
    //     repeat: true
    //     triggeredOnStart: true
    //     onTriggered: {
    //         priceTicker.updateRequest()
    //     }
    // }

    NodoPopup {
        id: paymentsPopup
        onApplyClicked: {
            if(commandID === 0)
            {
                console.log(transactionID)
                moneroPay.cancelPayment(transactionID)
                transactionID = -1;
            }
            else if(commandID === 3)
            {
                pageChangeRequested()
            }

            requestAmountRect.visible = true
            paymentPreviewRect.visible = false
            paymentResultRect.visible = false
            xmrRequestfield.valueText = ""
            fiatRequestfield.valueText = ""
            xmrAmount = 0
            blockConfirmationsSlider.value = 10
            descriptionInputfield.valueText = ""

            close()
        }
    }
}



