import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: 300

    property int ethConnIndex
    property int networkDelegateItemHeight: NodoSystem.nodoItemHeight
    property int labelSize: 200
    property bool showConnected: true
    property int buttonSize: 220
    property int defaultHeight: 100
    property int spacing: 1

    height: defaultHeight

    property string connectionName: networkManager.getEthernetConnectionName(ethConnIndex)
    property string connectionPath: networkManager.getEthernetConnectionPath(ethConnIndex)

    color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn  : NodoSystem.dataFieldTextBGColorNightModeOff

    Label {
        id: ethConnLabel
        anchors.top: mainRect.top
        anchors.left: mainRect.left
        anchors.topMargin: connectButton.y + (ethConnLabel.paintedHeight)/2
        anchors.leftMargin: 20
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        font.family: NodoSystem.fontUrbanist.name
        height: 40
        text: mainRect.connectionName
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
    }

    NodoButton {
        id: connectButton
        anchors.top: mainRect.top
        anchors.right: mainRect.right
        anchors.topMargin: 18
        anchors.rightMargin: 11
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: systemMessages.messages[NodoMessages.Message.Connect]
        visible: true
        isActive: true
        fitMinimal: true

        onClicked: {
                connectButton.isActive = false
                connectButton.text = systemMessages.messages[NodoMessages.Message.Connecting]
                connectButton.update()
                networkManager.activateEthernetConnection(mainRect.ethConnIndex)
        }
    }

    NodoButton {
        id: forgetButton
        anchors.top: mainRect.top
        anchors.right: connectButton.left
        anchors.topMargin: 18
        anchors.rightMargin: 10
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: systemMessages.messages[NodoMessages.Message.Forget]
        visible: networkManager.isEthernetConnectedBefore(ethConnIndex)
        isActive: true
        fitMinimal: true
        onClicked: {
            forgetButton.isActive = false
            networkManager.forgetWiredNetwork(mainRect.connectionPath)
        }
    }
}
