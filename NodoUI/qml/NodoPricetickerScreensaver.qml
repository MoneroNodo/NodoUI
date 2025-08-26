import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: priceTickerScreensaverScreensaver
    width: 1920
    height: 1080

    signal deleteMe(int screenID)

    Connections {
        target: priceTickerScreensaver
        function findCurrencyIndex()
        {
            var currentCurrencyCode = priceTickerScreensaver.getCurrentCurrencyCode();
            for (var i = 0; i < nodoCurrencies.currencyNames.length; i++) {
                if(currentCurrencyCode === nodoCurrencies.currencyCodes[i])
                {
                    priceTickerScreensaver.setCurrentCurrencyIndex(i)
                    return;
                }
            }
        }
		
        function onCurrencyIndexChanged() {
            exchangeNameText.text =  nodoCurrencies.currencyCodes[priceTickerScreensaver.getCurrentCurrencyIndex()]
            exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTickerScreensaver.getCurrentCurrencyIndex()]
            exchangeRateText.text = "---.--"

            var currencyRate = priceTickerScreensaver.getCurrency()
            if((true === priceTickerScreensaver.isCurrencyReceived()) && (-1 !== currencyRate))
            {
                exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTickerScreensaver.getCurrentCurrencyIndex()]
                exchangeRateText.text = priceTickerScreensaver.getCurrencyString()
            }
        }

        function onCurrencyReceived() {
            exchangeSymbolText.text = nodoCurrencies.currencySymbols[priceTickerScreensaver.getCurrentCurrencyIndex()]
            exchangeRateText.text = priceTickerScreensaver.getCurrencyString()
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
		anchors.topMargin: 50
		font.family: NodoSystem.fontInter.name
		color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
		width: 400
		
		Text {
			id: xmrText
			anchors.top: currenciesRect.top
			anchors.left: currenciesRect.left
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 120
			text: "XMR"
		}
		
		Label {
			id: currencySeparator
			anchors.top: xmrText.bottom
			anchors.left: currenciesRect.left
			anchors.topMargin: NodoSystem.nodoTopMargin
			anchors.leftMargin: NodoSystem.cardLeftMargin
			width: currenciesRect.width - 2*(NodoSystem.cardLeftMargin)
			height: NodoSystem.nodoItemHeight / 2
		}
		
		Text {
			id: exchangeNameText
			anchors.top: currencySeparator.bottom
			anchors.left: currenciesRect.left
			anchors.topMargin: NodoSystem.nodoTopMargin
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 120
			text: nodoCurrencies.currencyCodes[priceTickerScreensaver.getCurrentCurrencyIndex()]
		}
	}
	
    Rectangle {
        id: valuesRect
        color: "black"
		anchors.top: priceTickerScreensaver.top
		anchors.left: currenciesRect.right
		anchors.leftMargin: NodoSystem.cardLeftMargin
		anchors.topMargin: 50
		font.family: NodoSystem.fontInter.name
		color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
		width: parent.width - currenciesRect.width
		
		Text {
			id: exchangeSymbolText
			anchors.top: valuesRect.top
			anchors.left: currenciesRect.left
			anchors.topMargin: NodoSystem.nodoTopMargin
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 120
			text: nodoCurrencies.currencySymbols[pricetickerScreensaver.getCurrentCurrencyIndex()]
		}
		
		Text {
			id: exchangeRateText
			anchors.top: valuesRect.top
			anchors.left: exchangeSymbolText.right
			anchors.leftMargin: NodoSystem.cardLeftMargin
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 120
			text: "---.--"
		}
    }
	
    Rectangle {
        id: rightMenu
        anchors.top: priceTickerScreensaver.top
		anchors.left: priceTickerScreensaver.right
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
