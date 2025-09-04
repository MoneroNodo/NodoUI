import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: priceTickerScreensaver
    width: 1920
    height: 1080

    signal deleteMe(int screenID)

	property int currencyFontSize: 120
	property int rateFontSize: 305
	property int currencyTopMargin: 350
	property int rateTopMargin: currencyTopMargin - 20

    Connections {
        target: priceTicker
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
		
        function onCurrencyIndexChanged() {
            exchangeNameText.text =  nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
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
	}
	
    Rectangle {
        id: currenciesRect
        color: "black"
		anchors.top: priceTickerScreensaver.top
		anchors.left: priceTickerScreensaver.left
		anchors.topMargin: currencyTopMargin
		width: 280
		
		Text {
			id: xmrText
			anchors.top: currenciesRect.top
			anchors.left: currenciesRect.left
			anchors.leftMargin: 12
			verticalAlignment: Text.AlignVCenter
			font.family: NodoSystem.fontInter.name
			font.pixelSize: currencyFontSize
			color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
			text: "XMR"
		}
		
		NodoCanvas {
			id: currencySeparator
			anchors.top: xmrText.bottom
			anchors.left: currenciesRect.left
			anchors.topMargin: NodoSystem.cardLeftMargin
			anchors.leftMargin: 2
			width: 278//currenciesRect.width - 2*(NodoSystem.cardLeftMargin)
			height: 24
			color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
		}
		
		Text {
			id: exchangeNameText
			anchors.top: currencySeparator.bottom
			anchors.topMargin: NodoSystem.cardLeftMargin
			anchors.horizontalCenter: currenciesRect.horizontalCenter
			font.family: NodoSystem.fontInter.name
			font.pixelSize: currencyFontSize
			color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
			text: nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()]
		}
	}
	
    Rectangle {
        id: valuesRect
        color: "black"
		anchors.top: priceTickerScreensaver.top
		anchors.left: currenciesRect.right
		anchors.leftMargin: NodoSystem.cardLeftMargin
		anchors.topMargin: rateTopMargin
		width: width - currenciesRect.width
		
		Text {
			id: exchangeSymbolText
			anchors.top: valuesRect.top
			anchors.left: currenciesRect.left
			verticalAlignment: Text.AlignVCenter
			font.family: NodoSystem.fontInter.name
			font.pixelSize: rateFontSize
			color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
			text: nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()]
		}
		
		Text {
			id: exchangeRateText
			anchors.top: valuesRect.top
			anchors.left: exchangeSymbolText.right
			anchors.leftMargin: NodoSystem.cardLeftMargin
			verticalAlignment: Text.AlignVCenter
			font.family: NodoSystem.fontInter.name
			font.pixelSize: rateFontSize
			color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
			text: "---.--"
		}
    }
	
    Rectangle {
        id: rightMenu
        anchors.top: priceTickerScreensaver.top
		anchors.right: priceTickerScreensaver.right
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
}
