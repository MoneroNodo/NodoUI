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
        //deviceUpdatesMoneroPaySwitch.checked = nodoConfig.getUpdateStatus("pay")
        deviceUpdateAllButton.isActive = !nodoConfig.isUpdateLocked()
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceUpdatesNodoSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesNodoSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroDaemonSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroDaemonSwitchText.labelRectRoundSize

        if(deviceUpdatesMoneroLWSSwitchText.labelRectRoundSize > labelSize)
            labelSize = deviceUpdatesMoneroLWSSwitchText.labelRectRoundSize

        //if(deviceUpdatesMoneroPaySwitchText.labelRectRoundSize > labelSize)
        //    labelSize = deviceUpdatesMoneroPaySwitchText.labelRectRoundSize
    }

    Rectangle {
        id: deviceUpdateAllRect
        anchors.top: deviceUpdatesScreen.top
        anchors.left: deviceUpdatesScreen.left
        height: NodoSystem.nodoItemHeight

        NodoButton {
            id: deviceUpdateAllButton
            anchors.top: deviceUpdateAllRect.top
            anchors.left: deviceUpdateAllRect.left
            height: NodoSystem.nodoItemHeight
            width: labelSize
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            text: qsTr("Update All")
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

        Text {
            id: deviceUpdateAllText
            height: NodoSystem.nodoItemHeight
            width: parent.width - deviceUpdateAllRect.width
            anchors.left: deviceUpdateAllRect.right
            anchors.leftMargin: 25
            anchors.top: deviceUpdateAllRect.top
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("One tapped, this button will stay greyed out during the update process.")
        }
    }

    Rectangle {
        id: deviceUpdatesNodoSwitchRect
        anchors.top: deviceUpdateAllRect.bottom
        anchors.left: deviceUpdatesScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin*2
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: deviceUpdatesNodoSwitchText
            height: deviceUpdatesNodoSwitchRect.height
            anchors.left: deviceUpdatesNodoSwitchRect.left
            anchors.top: deviceUpdatesNodoSwitchRect.top
            itemSize: labelSize
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

        Text {
            id: deviceUpdatesNodoSwitchText
            height: NodoSystem.nodoItemHeight
            width: parent.width - deviceUpdatesNodoSwitchRect.width
            anchors.left: deviceUpdatesNodoSwitchRect.right
            anchors.leftMargin: 25
            anchors.top: deviceUpdatesNodoSwitchRect.top
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("Nodo v1.1 NodoUI v1.1")
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
            itemSize: labelSize
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

        Text {
            id: deviceUpdatesMoneroDaemonSwitchText
            height: NodoSystem.nodoItemHeight
            width: parent.width - deviceUpdatesMoneroDaemonSwitchRect.width
            anchors.left: deviceUpdatesMoneroDaemonSwitchRect.right
            anchors.leftMargin: 25
            anchors.top: deviceUpdatesMoneroDaemonSwitchRect.top
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("Monero v placeholder")
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
            itemSize: labelSize
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

        Text {
            id: deviceUpdatesMoneroLWSSwitchText
            height: NodoSystem.nodoItemHeight
            width: parent.width - deviceUpdatesMoneroLWSSwitchRect.width
            anchors.left: deviceUpdatesMoneroLWSSwitchRect.right
            anchors.leftMargin: 25
            anchors.top: deviceUpdatesMoneroLWSSwitchRect.top
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("LWS version placeholder text")
        }
    }
/*
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
            itemSize: labelSize
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
*/
}
