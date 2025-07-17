import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    property color defaultColor: NodoSystem.defaultColorNightModeOff
    property color highlightedColor: NodoSystem.defaultColorNightModeOn
    signal deleteMe(int screenID)

    Rectangle {
        id: mainAppWindowRectangle
        anchors.fill: parent
        color: "black"

        function findCurrencyIndex()
        {
            var currentCurrencyCode = priceTicker.getCurrentCurrencyCode();
            for (var i = 0; i < nodoCurrencies.currencyNames.length; i++) {
                if(currentCurrencyCode === nodoCurrencies.currencyCodes[i])
                {
                    priceTicker.setCurrentCurrencyIndex(i)
                    return;
                }
            }
        }

        Timer {
            id: dateTimer
            interval: 1000
            running: false
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var dateTime = nodoControl.getChangedDateTime()
                var m_daystr = Qt.formatDateTime(dateTime, "ddd")
                var m_day = Qt.formatDateTime(dateTime, "d")
                var m_month = Qt.formatDateTime(dateTime, "MMM")

                dateText.text = m_daystr.toUpperCase() + " " +m_day + " "  + m_month.toUpperCase()
                if (nodoControl.is24hEnabled())
                    timeText.text = Qt.formatDateTime(nodoControl.getChangedDateTime(), "hh:mm")
                else
                    timeText.text = Qt.formatDateTime(nodoControl.getChangedDateTime(), "h:mm AP")
            }
        }

        Component.onCompleted: {
            findCurrencyIndex()
            dateTimer.start()
/*            if(100 === syncInfo.getSyncPercentage() && moneroPay.isDepositAddressSet())
            {
                receiveButton.enabled = true
            }
            else
            {
                receiveButton.enabled = false
            }
*/
        }

        Connections {
            target: priceTicker
            function onCurrencyIndexChanged() {
                exchangeNameText.text =  "XMR-" + nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()] + ":"
                exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()]
                exchangeRateText.text = "---.--"

                var currencyRate = priceTicker.getCurrency()
                if((true === priceTicker.isCurrencyReceived()) && (-1 !== currencyRate))
                {
                    exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()]
                    exchangeRateText.text = priceTicker.getCurrencyString()
                }
            }

            function onCurrencyReceived() {
                exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()]
                exchangeRateText.text = priceTicker.getCurrencyString()
            }
        }

        TabBar {
            id: mainMenuBar
            anchors.top: mainAppWindowRectangle.top
            anchors.left: mainAppWindowRectangle.left
            anchors.leftMargin: 0
            height: NodoSystem.topMenuButtonHeight
            implicitWidth: 1450//newsButton.x + newsButton.width

            background: Rectangle {
                color: "black"
            }

            NodoTabButton {
                id: nodoLogoButton
                isLogo: true
                x: 0
                y: 0//(mainMenuBar.height - nodoLogoButton.height)/2
                text: " "
                width: NodoSystem.nodoItemHeight + 60 //300//288
                implicitHeight: NodoSystem.nodoItemHeight //120//110
                //height: NodoSystem.nodoItemHeight + 10
                //buttonBorderColor: "black"
                imagePath: (nodoControl.appTheme ? "qrc:/Images/Nodo_red.png" : "qrc:/Images/Nodo_white.png")
                onClicked: {
                    pageLoader.source = "NodoStatusScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: deviceButton
                anchors.top: nodoLogoButton.top
                anchors.topMargin: (nodoLogoButton.height - NodoSystem.topMenuButtonHeight)/2
                anchors.left: nodoLogoButton.right
                anchors.leftMargin: 1
                height: NodoSystem.topMenuButtonHeight
                text: qsTr("DEVICE")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "DeviceMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }

            NodoTabButton {
                id: nodeButton
                anchors.top: deviceButton.top
                anchors.left: deviceButton.right
                anchors.leftMargin: NodoSystem.nodoTopMargin
                height: NodoSystem.topMenuButtonHeight
                text: qsTr("NODE")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "NodeMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: moneroLWSButton
                anchors.top: deviceButton.top
                anchors.left: nodeButton.right
                anchors.leftMargin: NodoSystem.nodoTopMargin
                height: NodoSystem.topMenuButtonHeight
                text: qsTr("LWS")
                width: nodeButton.width
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                // enabled: syncInfo.getSyncPercentage() == 100
                onClicked: {
                    pageLoader.source = "MoneroLWSMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: mPayButton
                anchors.top: deviceButton.top
                anchors.left: moneroLWSButton.right
                height: NodoSystem.topMenuButtonHeight
                anchors.leftMargin: NodoSystem.nodoTopMargin
                text: qsTr("MONEROPAY")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "MoneroPayMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: newsButton
                anchors.top: deviceButton.top
                anchors.left: mPayButton.right//moneroLWSButton.right
                anchors.leftMargin: NodoSystem.nodoTopMargin
                height: NodoSystem.topMenuButtonHeight
                text: qsTr("NEWS")
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "NewsMainScreen.qml"
                    pageLoader.anchors.topMargin = NodoSystem.subMenuTopMargin + 64//60
                }
                visible: nodoControl.isFeedsEnabled()
            }
        }

        Rectangle {
            id: rightMenu
            anchors.top: mainMenuBar.top
            anchors.left: mainMenuBar.right
            anchors.right: mainAppWindowRectangle.right
            anchors.bottom: mainMenuBar.bottom
            color: "black"

            Text {
                id: dateText
                anchors.top: rightMenu.top
                anchors.bottom: rightMenu.bottom
                anchors.right: timeText.left
                anchors.rightMargin: 15
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                topPadding: NodoSystem.topMenuTextTopPadding
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }

            Text {
                id: timeText
                anchors.top: rightMenu.top
                anchors.bottom: rightMenu.bottom
                anchors.right: rightMenu.right
                anchors.rightMargin: 2
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                topPadding: NodoSystem.topMenuTextTopPadding
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontInter.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }
        }

        Connections {
            target: syncInfo
            function onSyncDone() {
                moneroLWSButton.enabled = true
            }
        }

        Connections {
            target: nodoControl
            function onTickerEnabledChanged(enabled) {
                priceTickerRect.visible = enabled;
            }
            function onFeedsEnabledChanged(enabled) {
                newsButton.visible = enabled;
            }
        }

        Rectangle {
            id: priceTickerRect
            anchors.right: mainAppWindowRectangle.right
            anchors.top: rightMenu.bottom
            anchors.topMargin: NodoSystem.subMenuTopMargin + 42//40
            color: "black"
            visible: nodoControl.isTickerEnabled()
            
            Text {
                id: exchangeNameText
                anchors.top: priceTickerRect.top
                anchors.bottom: priceTickerRect.bottom
                anchors.right: exchangeSymbolText.left
                anchors.rightMargin: 5
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                text: "XMR-" + nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()] + ":"
                topPadding: NodoSystem.topMenuTextTopPadding
                font.family: NodoSystem.fontInter.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }

            Text {
                id: exchangeSymbolText
                anchors.top: priceTickerRect.top
                anchors.bottom: priceTickerRect.bottom
                anchors.right: exchangeRateText.left
                anchors.rightMargin: 6
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                text: nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()]
                topPadding: NodoSystem.topMenuTextTopPadding
                font.family: NodoSystem.fontInter.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }

            Text {
                id: exchangeRateText
                anchors.top: priceTickerRect.top
                anchors.bottom: priceTickerRect.bottom
                anchors.right: priceTickerRect.right
                anchors.rightMargin: 2
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                text: "---.--"
                topPadding: NodoSystem.topMenuTextTopPadding
                font.family: NodoSystem.fontInter.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }
        }

        Loader {
            id: pageLoader
            anchors.top: mainMenuBar.bottom
            anchors.left: mainAppWindowRectangle.left
            anchors.right: mainAppWindowRectangle.right
            anchors.bottom: mainAppWindowRectangle.bottom
            source: "NodoStatusScreen.qml"
        }

    }
}
