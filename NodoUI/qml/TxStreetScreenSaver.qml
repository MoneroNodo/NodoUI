import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtWebView

Item {
    id: txStreet
    anchors.fill: parent
    signal deleteMe(int screenID)
    WebView {
        id: txStreetWebView
        url: "https://example.com/"
        anchors.fill: parent
    }
}
