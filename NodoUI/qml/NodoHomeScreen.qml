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
                timeText.text = Qt.formatDateTime(nodoControl.getChangedDateTime(), "h:mm AP")
            }
        }

        Component.onCompleted: {
            findCurrencyIndex()
            dateTimer.start()
            if (100 === syncInfo.getSyncPercentage())
            {
                minerButton.enabled = true
            }
            else
            {
                minerButton.enabled = false
            }
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
                    exchangeRateText.text = currencyRate
                }
            }

            function onCurrencyReceived() {
                exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()]
                exchangeRateText.text = priceTicker.getCurrency()
            }
        }

        Connections {
            target: syncInfo
            function onSyncDone() {
                minerButton.enabled = true
            }
        }

        TabBar {
            id: mainMenuBar
            anchors.top: mainAppWindowRectangle.top
            anchors.left: mainAppWindowRectangle.left
            anchors.leftMargin: 10
            height: NodoSystem.topMenuButtonHeight
            implicitWidth: newsButton.x + newsButton.width

            background: Rectangle {
                color: "black"
            }

            NodoTabButton {
                id: nodoLogoButton
                x: 0
                y: (mainMenuBar.height - nodoLogoButton.height)/2
                text: " "
                width: 288
                implicitHeight: NodoSystem.topMenuButtonHeight
                buttonBorderColor: "black"
                imagePath: (nodoControl.appTheme ? "qrc:/Images/nodologo_title_red.png" : "qrc:/Images/nodologo_title_white.png")
                onClicked: {
                    pageLoader.source = "NodoStatusScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: deviceButton
                anchors.top: nodoLogoButton.top
                anchors.topMargin: (NodoSystem.topMenuButtonHeight - NodoSystem.nodoItemHeight)/2
                anchors.left: nodoLogoButton.right
                anchors.leftMargin: 20
                height: NodoSystem.nodoItemHeight
                text: qsTr("DEVICE")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "DeviceMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: networksButton
                anchors.top: deviceButton.top
                anchors.left: deviceButton.right
                height: NodoSystem.nodoItemHeight
                text: qsTr("NETWORKS")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "NetworksMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }

            NodoTabButton {
                id: nodeButton
                anchors.top: deviceButton.top
                anchors.left: networksButton.right
                height: NodoSystem.nodoItemHeight
                text: qsTr("NODE")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "NodeMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }
            NodoTabButton {
                id: minerButton
                anchors.top: deviceButton.top
                anchors.left: nodeButton.right
                height: NodoSystem.nodoItemHeight
                text: qsTr("MINER")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "MinerMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
                enabled: false

            }
            NodoTabButton {
                id: moneroLWSButton
                anchors.top: deviceButton.top
                anchors.left: minerButton.right
                height: NodoSystem.nodoItemHeight
                text: qsTr("LWS")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "MoneroLWSMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }

            NodoTabButton {
                id: mPayButton
                anchors.top: deviceButton.top
                anchors.left: moneroLWSButton.right
                height: NodoSystem.nodoItemHeight
                text: qsTr("MPAY")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "MoneroPayMainScreen.qml"
                    pageLoader.anchors.topMargin = 0
                }
            }

            NodoTabButton {
                id: newsButton
                anchors.top: deviceButton.top
                anchors.left: mPayButton.right
                height: NodoSystem.nodoItemHeight
                text: qsTr("NEWS")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: {
                    pageLoader.source = "NewsMainScreen.qml"
                    pageLoader.anchors.topMargin = 60
                }
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
                anchors.rightMargin: 20
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                topPadding: NodoSystem.topMenuTextTopPadding
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }

            Text {
                id: timeText
                anchors.top: rightMenu.top
                anchors.bottom: rightMenu.bottom
                anchors.right: rightMenu.right
                anchors.rightMargin: 10
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                topPadding: NodoSystem.topMenuTextTopPadding
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }
        }

        Rectangle {
            id: priceTickerRect
            anchors.right: mainAppWindowRectangle.right
            anchors.top: rightMenu.bottom
            anchors.topMargin: 35
            color: "black"

            Text {
                id: exchangeNameText
                anchors.top: priceTickerRect.top
                anchors.bottom: priceTickerRect.bottom
                anchors.right: exchangeSymbolText.left
                anchors.rightMargin: 2
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                text: "XMR-" + nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()] + ":"
                topPadding: NodoSystem.topMenuTextTopPadding
                font.family: NodoSystem.fontUrbanist.name
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
                font.family: NodoSystem.fontUrbanist.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }



            Text {
                id: exchangeRateText
                anchors.top: priceTickerRect.top
                anchors.bottom: priceTickerRect.bottom
                anchors.right: priceTickerRect.right
                anchors.rightMargin: 10
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                text: "---.--"
                topPadding: NodoSystem.topMenuTextTopPadding
                font.family: NodoSystem.fontUrbanist.name
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
