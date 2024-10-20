import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0
import QtWebView

Item {
    id: moneroPayReceiveRequestScreen

    property int labelSize: 300
    property int inputFieldWidth: 600
    property int addressFieldWidth: 1850
    property double exchangeRate
    property string exchangeName
    property double xmrAmount

    Connections {
        target: priceTicker
        function onCurrencyReceived() {
            exchangeName = nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
            exchangeRate = priceTicker.getCurrency()
            if(-1 === exchangeRate)
            {
                fiatRequestfield.readOnlyFlag = true
            }
            else
            {
                fiatRequestfield.readOnlyFlag = false
            }
        }
    }

    Component.onCompleted: {
        exchangeName = nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
        exchangeRate = priceTicker.getCurrency()

        if(-1 === exchangeRate)
        {
            fiatRequestfield.readOnlyFlag = true
        }
        else
        {
            fiatRequestfield.readOnlyFlag = false
        }
    }

    Rectangle {
        id: requestCurrenciesRect
        anchors.top: moneroPayReceiveRequestScreen.top
        anchors.left: moneroPayReceiveRequestScreen.left
        width: 1900
        height: 95
        color: "black"

        NodoInputField {
            id: xmrRequestfield
            anchors.top: requestCurrenciesRect.top
            anchors.left: requestCurrenciesRect.left
            itemSize: 210
            width: 1000
            height: 95
            itemText: qsTr("XMR")
            valueText: "0.000000000000"
            textFlag: Qt.ImhDigitsOnly
            itemFontSize: 80
            valueFontSize: 80

            onTextEditFinished: {
                if(valueText === "")
                {
                    valueText = "0.000000000000"
                }

                xmrAmount = parseFloat(xmrRequestfield.valueText)

                if(xmrAmount > 9000000)
                {
                    xmrAmount = 0.0
                    paymentsPopup.commandID = -1
                    paymentsPopup.applyButtonText = qsTr("Value out of range")
                    paymentsPopup.open()
                }
                if(-1 !== exchangeRate)
                {
                    fiatRequestfield.valueText = (xmrAmount*exchangeRate).toFixed(2)
                }
            }
        }

        NodoInputField {
            id: fiatRequestfield
            anchors.top: requestCurrenciesRect.top
            anchors.left: xmrRequestfield.right
            anchors.leftMargin: 25
            itemSize: 210
            width: 700
            height: 95
            itemText: moneroPayReceiveRequestScreen.exchangeName
            valueText: "0.00"
            textFlag: Qt.ImhDigitsOnly
            itemFontSize: 80
            valueFontSize: 80

            onTextEditFinished: {
                if(valueText === "")
                {
                    valueText = "0.00"
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
        anchors.left: moneroPayReceiveRequestScreen.left
        anchors.top: requestCurrenciesRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.right: descriptionInputfield.right
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoInputField{
            id: blockConfirmationsField
            anchors.left: blockConfirmationsRect.left
            anchors.top: blockConfirmationsRect.top
            height: blockConfirmationsRect.height
            itemSize: labelSize
            width: labelSize + 70
            itemText:  qsTr("Block Confirmations")
            valueText: "10"
            textFlag: Qt.ImhDigitsOnly
            validator: RegularExpressionValidator {
                regularExpression: /^[1-9]$|^1[0-9]$|^20$/
            }
            readOnlyFlag: zeroConfirmationSwitch.checked
        }

        Rectangle {
            id: zeroConfirmationSwitchRect
            anchors.left: blockConfirmationsField.right
            anchors.top: blockConfirmationsField.top
            height: blockConfirmationsRect.height
            anchors.leftMargin: 25

            NodoLabel{
                id: zeroConfirmationSwitchText
                height: zeroConfirmationSwitchRect.height
                anchors.left: zeroConfirmationSwitchRect.left
                anchors.top: zeroConfirmationSwitchRect.top
                text: qsTr("0 Confirmations")
            }

            NodoSwitch {
                id: zeroConfirmationSwitch
                anchors.left: zeroConfirmationSwitchText.right
                anchors.leftMargin: NodoSystem.padding
                height: zeroConfirmationSwitchRect.height
                width: 2*zeroConfirmationSwitch.height
                display: AbstractButton.IconOnly
                checked: true
            }
        }
    }

    NodoInputField {
        id: descriptionInputfield
        anchors.top: blockConfirmationsRect.bottom
        anchors.left: moneroPayReceiveRequestScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: addressFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Note (Optional)")
        valueText: ""
    }

    NodoButton {
        id: receivePaymentButton
        anchors.top: descriptionInputfield.bottom
        anchors.left: moneroPayReceiveRequestScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Receive Payment")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: xmrAmount === 0 ? false : true
        onClicked: {
            var confirmationValue = zeroConfirmationSwitch.checked ? 0 :  parseInt(blockConfirmationsField.valueText)
            moneroPay.xmrRequestPayment(xmrRequestfield.valueText, fiatRequestfield.valueText, priceTicker.getCurrentCurrencyIndex(), descriptionInputfield.valueText, confirmationValue)
        }
    }
}

