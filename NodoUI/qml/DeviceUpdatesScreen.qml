import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceUpdatesScreen
    anchors.fill: parent
    property int labelSize: 0
    property int nodoTopMargin: 20

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()

        deviceUpdatesNodoSwitchSwitch.checked = nodoConfig.getUpdateStatus("nodo")
        deviceUpdatesMoneroDaemonSwitch.checked = nodoConfig.getUpdateStatus("monero")
        deviceUpdatesXmrigSwitch.checked = nodoConfig.getUpdateStatus("xmrig")
        deviceUpdatesMoneroLWSSwitch.checked = nodoConfig.getUpdateStatus("lws")
        deviceUpdatesMoneroPaySwitch.checked = nodoConfig.getUpdateStatus("pay")
        deviceUpdatesBlockExplorerSwitch.checked = nodoConfig.getUpdateStatus("exp")
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceUpdatesNodoSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesNodoSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroDaemonSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroDaemonSwitchText.labelRectRoundSize

        if(deviceUpdatesXmrigSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesXmrigSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroLWSSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroLWSSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroPaySwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroPaySwitchText.labelRectRoundSize

        if(deviceUpdatesBlockExplorerSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesBlockExplorerSwitchText.labelRectRoundSize
    }

    Rectangle {
        id: deviceUpdatesNodoSwitchRect
        anchors.left: deviceUpdatesScreen.left
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceUpdatesNodoSwitchText
            height: deviceUpdatesNodoSwitchRect.height
            anchors.left: deviceUpdatesNodoSwitchRect.left
            anchors.top: deviceUpdatesNodoSwitchRect.top
            text: qsTr("Nodo")
        }

        NodoSwitch {
            id: deviceUpdatesNodoSwitchSwitch
            anchors.left: deviceUpdatesNodoSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceUpdatesNodoSwitchRect.height
            width: 2*deviceUpdatesNodoSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoConfig.setUpdateStatus("nodo", checked)
            }
        }
    }

    Rectangle {
        id: deviceUpdatesMoneroDaemonSwitchRect
        anchors.left: deviceUpdatesScreen.left
        anchors.top: deviceUpdatesNodoSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceUpdatesMoneroDaemonSwitchText
            height: deviceUpdatesMoneroDaemonSwitchRect.height
            anchors.left: deviceUpdatesMoneroDaemonSwitchRect.left
            anchors.top: deviceUpdatesMoneroDaemonSwitchRect.top
            text: qsTr("Monero Daemon")
        }

        NodoSwitch {
            id: deviceUpdatesMoneroDaemonSwitch
            anchors.left: deviceUpdatesMoneroDaemonSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceUpdatesMoneroDaemonSwitchRect.height
            width: 2*deviceUpdatesMoneroDaemonSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoConfig.setUpdateStatus("monero", checked)
            }
        }
    }

    Rectangle {
        id: deviceUpdatesXmrigSwitchRect
        anchors.left: deviceUpdatesScreen.left
        anchors.top: deviceUpdatesMoneroDaemonSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceUpdatesXmrigSwitchText
            height: deviceUpdatesXmrigSwitchRect.height
            anchors.left: deviceUpdatesXmrigSwitchRect.left
            anchors.top: deviceUpdatesXmrigSwitchRect.top
            text: qsTr("XMRig")
        }

        NodoSwitch {
            id: deviceUpdatesXmrigSwitch
            anchors.left: deviceUpdatesXmrigSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceUpdatesXmrigSwitchRect.height
            width: 2*deviceUpdatesXmrigSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoConfig.setUpdateStatus("xmrig", checked)
            }
        }
    }

    Rectangle {
        id: deviceUpdatesMoneroLWSSwitchRect
        anchors.left: deviceUpdatesScreen.left
        anchors.top: deviceUpdatesXmrigSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceUpdatesMoneroLWSSwitchText
            height: deviceUpdatesMoneroLWSSwitchRect.height
            anchors.left: deviceUpdatesMoneroLWSSwitchRect.left
            anchors.top: deviceUpdatesMoneroLWSSwitchRect.top
            text: qsTr("Monero LWS")
        }

        NodoSwitch {
            id: deviceUpdatesMoneroLWSSwitch
            anchors.left: deviceUpdatesMoneroLWSSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceUpdatesMoneroLWSSwitchRect.height
            width: 2*deviceUpdatesMoneroLWSSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoConfig.setUpdateStatus("lws", checked)
            }
        }
    }

    Rectangle {
        id: deviceUpdatesMoneroPaySwitchRect
        anchors.left: deviceUpdatesScreen.left
        anchors.top: deviceUpdatesMoneroLWSSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceUpdatesMoneroPaySwitchText
            height: deviceUpdatesMoneroPaySwitchRect.height
            anchors.left: deviceUpdatesMoneroPaySwitchRect.left
            anchors.top: deviceUpdatesMoneroPaySwitchRect.top
            text: qsTr("MoneroPay")
        }

        NodoSwitch {
            id: deviceUpdatesMoneroPaySwitch
            anchors.left: deviceUpdatesMoneroPaySwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceUpdatesMoneroPaySwitchRect.height
            width: 2*deviceUpdatesMoneroPaySwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoConfig.setUpdateStatus("pay", checked)
            }
        }
    }

    Rectangle {
        id: deviceUpdatesBlockExplorerSwitchRect
        anchors.left: deviceUpdatesScreen.left
        anchors.top: deviceUpdatesMoneroPaySwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: deviceUpdatesBlockExplorerSwitchText
            height: deviceUpdatesBlockExplorerSwitchRect.height
            anchors.left: deviceUpdatesBlockExplorerSwitchRect.left
            anchors.top: deviceUpdatesBlockExplorerSwitchRect.top
            text: qsTr("Block Explorer")
        }

        NodoSwitch {
            id: deviceUpdatesBlockExplorerSwitch
            anchors.left: deviceUpdatesBlockExplorerSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: deviceUpdatesBlockExplorerSwitchRect.height
            width: 2*deviceUpdatesBlockExplorerSwitchRect.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                nodoConfig.setUpdateStatus("exp", checked)
            }
        }
    }
}
