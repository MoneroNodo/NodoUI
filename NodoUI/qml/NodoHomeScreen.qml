import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    property color defaultColor: NodoSystem.defaultColorNightModeOff
    property color highlightedColor: NodoSystem.defaultColorNightModeOn

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

        Component.onCompleted: {
            findCurrencyIndex()
        }

        Connections {
            target: priceTicker
            function onCurrencyIndexChanged() {
                exchangeNameText.text =  "XMR-" + nodoCurrencies.currencyCodes[priceTicker.getCurrentCurrencyIndex()] + ":"
                exchangeRateText.text = nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()] + "---.--"
            }

            function onCurrencyReceived() {
                exchangeRateText.text = nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()] + priceTicker.getCurrency()
            }
        }

        TabBar {
            id: mainMenuBar
            anchors.top: mainAppWindowRectangle.top
            anchors.left: mainAppWindowRectangle.left
            anchors.leftMargin: 10
            height: NodoSystem.topMenuButtonHeight

            background: Rectangle {
                color: "black"
            }

            NodoTabButton {
                id: nodoLogoButton
                y: (mainMenuBar.height - nodoLogoButton.height)/2
                text: " "
                width: 288 //180
                imagePath: (nodoControl.appTheme ? "qrc:/Images/nodologo_large_resized_red.png" :
                "qrc:/Images/nodologo_large_resized.png")
                onClicked: { pageLoader.source = "NodoStatusScreen.qml" }
            }

            NodoTabButton {
                id: networksButton
                anchors.top: nodoLogoButton.top
                anchors.left: nodoLogoButton.right
                anchors.leftMargin: 10
                implicitHeight: NodoSystem.topMenuButtonHeight
                text: qsTr("NETWORKS")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: { pageLoader.source = "NetworksMainScreen.qml" }
            }
            NodoTabButton {
                id: deviceButton
                anchors.top: nodoLogoButton.top
                anchors.left: networksButton.right
                implicitHeight: NodoSystem.topMenuButtonHeight
                text: qsTr("DEVICE")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: { pageLoader.source = "DeviceMainScreen.qml" }
            }
            NodoTabButton {
                id: nodeButton
                anchors.top: nodoLogoButton.top
                anchors.left: deviceButton.right
                implicitHeight: NodoSystem.topMenuButtonHeight
                text: qsTr("NODE")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: { pageLoader.source = "NodeMainScreen.qml" }
            }
            NodoTabButton {
                id: minerButton
                anchors.top: nodoLogoButton.top
                anchors.left: nodeButton.right
                implicitHeight: NodoSystem.topMenuButtonHeight
                text: qsTr("MINER")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: { pageLoader.source = "MinerMainScreen.qml" }
            }
            NodoTabButton {
                id: moneroLWSButton
                anchors.top: nodoLogoButton.top
                anchors.left: minerButton.right
                implicitHeight: NodoSystem.topMenuButtonHeight
                text: qsTr("LWS")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: { pageLoader.source = "MoneroLWSMainScreen.qml" }
            }

            NodoTabButton {
                id: newsButton
                anchors.top: nodoLogoButton.top
                anchors.left: moneroLWSButton.right
                implicitHeight: NodoSystem.topMenuButtonHeight
                text: qsTr("NEWS")
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.topMenuButtonFontSize
                onClicked: { pageLoader.source = "NewsMainScreen.qml" }
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
                id: exchangeNameText
                anchors.top: rightMenu.top
                anchors.bottom: rightMenu.bottom
                anchors.right: exchangeRateText.left
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
                id: exchangeRateText
                anchors.top: rightMenu.top
                anchors.bottom: rightMenu.bottom
                anchors.right: dateText.left
                anchors.rightMargin: 20
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                text: nodoCurrencies.currencySymbols[priceTicker.getCurrentCurrencyIndex()] + "---.--"
                topPadding: NodoSystem.topMenuTextTopPadding
                font.family: NodoSystem.fontUrbanist.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: NodoSystem.topMenuButtonFontSize
            }

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


                Timer {
                    id: dateTimer
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        var m_day = Qt.formatDateTime(nodoControl.getChangedDateTime(), "d")
                        var m_month = Qt.formatDateTime(nodoControl.getChangedDateTime(), "MMM")
                        var m_year = Qt.formatDateTime(nodoControl.getChangedDateTime(), "yyyy")

                        dateText.text = m_day + " "  + m_month.toUpperCase() + " " + m_year
                    }
                }
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

                Timer {
                    id: hourTimer
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        timeText.text = Qt.formatDateTime(nodoControl.getChangedDateTime(), "h:mm AP")
                    }
                }
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
