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
        deviceUpdatesMoneroLWSSwitch.checked = nodoConfig.getUpdateStatus("lws")
        deviceUpdatesMoneroPaySwitch.checked = nodoConfig.getUpdateStatus("pay")
        deviceUpdateAllButton.isActive = !nodoConfig.isUpdateLocked()
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceUpdatesNodoSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesNodoSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroDaemonSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroDaemonSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroLWSSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroLWSSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroPaySwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroPaySwitchText.labelRectRoundSize
    }
    Rectangle {
        id: deviceUpdateAllRect
        anchors.top: deviceUpdatesScreen.top
        anchors.left: deviceUpdatesScreen.left
        height: NodoSystem.nodoItemHeight

        NodoButton {
            id: deviceUpdateAllButton
            anchors.top: deviceUpdatesScreen.top
            anchors.left: deviceUpdatesScreen.left
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            text: qsTr("Check for Updates")
            onClicked: {
                deviceUpdateAllButton.isActive = false
                nodoControl.updateDevice()
            }

            Connections {
                target: nodoConfig
                function onLockGone() {
                    deviceUpdateAllButton.isActive = true
                }
            }
        }

    }

    Rectangle {
        id: deviceUpdatesNodoSwitchRect
        anchors.top: deviceUpdateAllRect.bottom
        anchors.left: deviceUpdatesScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
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

        NodoLabel {
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
        id: deviceUpdatesMoneroLWSSwitchRect
        anchors.left: deviceUpdatesScreen.left
        anchors.top: deviceUpdatesMoneroDaemonSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoLabel {
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

        NodoLabel {
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
}
