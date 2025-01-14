import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect

    property int ethConnIndex
    property int networkDelegateItemHeight: NodoSystem.nodoItemHeight
    property int labelSize: 200
    property bool showConnected: true
    property int buttonSize: 320
    property int defaultHeight: NodoSystem.nodoItemHeight + (NodoSystem.cardTopMargin*2)
    property int spacing: 1

    height: defaultHeight

    property string connectionName: networkManager.getEthernetConnectionName(ethConnIndex)
    property string connectionPath: networkManager.getEthernetConnectionPath(ethConnIndex)

    color: NodoSystem.cardBackgroundColor

    Label {
        id: ethConnLabel
        anchors.top: mainRect.top
        anchors.left: mainRect.left
        anchors.topMargin: (ethConnLabel.paintedHeight)/2
        anchors.leftMargin: NodoSystem.cardLeftMargin*2
        font.pixelSize: NodoSystem.buttonTextFontSize
        font.family: NodoSystem.fontInter.name
        height: 40
        text: mainRect.connectionName
        color: NodoSystem.cardBackgroundColor
    }

    NodoButton {
        id: connectButton
        anchors.top: mainRect.top
        anchors.right: mainRect.right
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.rightMargin: NodoSystem.cardTopMargin
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: systemMessages.messages[NodoMessages.Message.Connect]
        visible: true
        isActive: true
        fitMinimal: true

        onClicked: {
                connectButton.isActive = false
                connectButton.text = systemMessages.messages[NodoMessages.Message.Connecting]
                connectButton.update()
                networkManager.activateEthernetConnection(mainRect.ethConnIndex)
                mainRect.state = "" //Added later
        }
    }

    NodoButton {
        id: forgetButton
        anchors.top: mainRect.top
        anchors.right: connectButton.left
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.rightMargin: 25
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: systemMessages.messages[NodoMessages.Message.Forget]
        visible: networkManager.isEthernetConnectedBefore(ethConnIndex)
        isActive: true
        fitMinimal: true
        onClicked: {
            forgetButton.isActive = false
            networkManager.forgetWiredNetwork(mainRect.connectionPath)
            mainRect.state = "" //Added later
        }
    }
}
