import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Rectangle {
    id: statusScreen
    color: "black"
    anchors.fill: parent

    property int labelSize: 240 // 150
    property int hheight: 44 // 150

    Rectangle {
        id: syncStatus
        anchors.left: statusScreen.left
        anchors.top: statusScreen.top
        anchors.topMargin: 20
        anchors.leftMargin: 50
        width: 560
        height: 500
        color: "black"

        Label {
            id: syncStatusTabName
            anchors.left: syncStatus.left
            anchors.top: syncStatus.top
            anchors.topMargin: 20
            width: syncStatusTabName.paintedWidth
            height: 16
            text: qsTr("Sync Status")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 40 // 24
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: syncStatusField
            anchors.left: syncStatus.left
            anchors.top: syncStatusTabName.bottom
            anchors.topMargin: 8 // 5
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Sync Status"
            valueText: "Synchronised"
        }

        NodoInfoField {
            id: timestampField
            anchors.left: syncStatus.left
            anchors.top: syncStatusField.bottom
            anchors.topMargin: 8

            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Timestamp"
            valueText: "28/10/2023, 14:03:55"
        }

        NodoInfoField {
            id: currentSyncHeightField
            anchors.left: syncStatus.left
            anchors.top: timestampField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Sync Height"
            valueText: "2292230"
        }

        NodoInfoField {
            id: moneroVersionField
            anchors.left: syncStatus.left
            anchors.top: currentSyncHeightField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Monero Version"
            valueText: "0.18.2.2-eac1b86bb"
        }

        NodoInfoField {
            id: outgoingConnectionsField
            anchors.left: syncStatus.left
            anchors.top: moneroVersionField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Outgoing Peers"
            valueText: "63"
        }

        NodoInfoField {
            id: incomingConnectionsField
            anchors.left: syncStatus.left
            anchors.top: outgoingConnectionsField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Incoming Peers"
            valueText: "0"
        }

        NodoInfoField {
            id: whitePeerlistSizeField
            anchors.left: syncStatus.left
            anchors.top: incomingConnectionsField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "White Peerlist"
            valueText: "999"
        }

        NodoInfoField {
            id: greyPeerlistSizeField
            anchors.left: syncStatus.left
            anchors.top: whitePeerlistSizeField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Grey Peerlist"
            valueText: "4691"
        }

        NodoInfoField {
            id: updateAvailableField
            anchors.left: syncStatus.left
            anchors.top: greyPeerlistSizeField.bottom
            anchors.topMargin: 8
            width: syncStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Update Available"
            valueText: "false"
        }
    }


    Rectangle {
        id: systemStatus
        anchors.horizontalCenter: statusScreen.horizontalCenter
        anchors.top: statusScreen.top
        anchors.topMargin: 20

        width: 560
        height: 500
        color: "black"

        Label {
            id: systemStatusTabName
            anchors.left: systemStatus.left
            anchors.top: systemStatus.top
            anchors.topMargin: 20
            width: systemStatusTabName.paintedWidth
            height: 16
            text: qsTr("System Status")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 40
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: moneroNodeField
            anchors.left: systemStatus.left
            anchors.top: systemStatusTabName.bottom
            anchors.topMargin: 8
            width: systemStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Monero Node"
            valueText: "running"
        }

        NodoInfoField {
            id: torServiceField
            anchors.left: systemStatus.left
            anchors.top: moneroNodeField.bottom
            anchors.topMargin: 8
            width: systemStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Tor Service"
            valueText: "Stopped"

        }

        NodoInfoField {
            id: i2pServiceField
            anchors.left: systemStatus.left
            anchors.top: torServiceField.bottom
            anchors.topMargin: 8
            width: systemStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "I2P Service"
            valueText: "Inactive (failed)"
        }

        NodoInfoField {
            id: moneroLWSField
            anchors.left: systemStatus.left
            anchors.top: i2pServiceField.bottom
            anchors.topMargin: 8
            width: systemStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Monero LWS"
            valueText: "inactive"

        }

        NodoInfoField {
            id: blockExplorerField
            anchors.left: systemStatus.left
            anchors.top: moneroLWSField.bottom
            anchors.topMargin: 8
            width: systemStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Block Explorer"
            valueText: "inactive"
        }
    }

    Rectangle {
        id: hardwareStatus
        anchors.right: statusScreen.right
        anchors.top: statusScreen.top
        anchors.topMargin: 20
        anchors.rightMargin: 50
        width: 560
        height: 500
        color: "black"

        Label {
            id: hardwareStatusTabName
            anchors.left: hardwareStatus.left
            anchors.top: hardwareStatus.top
            anchors.topMargin: 20
            width: hardwareStatusTabName.paintedWidth
            height: 16
            text: qsTr("Hardware Status")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 40
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: cpuField
            anchors.left: hardwareStatus.left
            anchors.top: hardwareStatusTabName.bottom
            anchors.topMargin: 8
            width: hardwareStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "CPU"
            valueText: "22.6 %"
        }

        NodoInfoField {
            id: cpuTemperatureField
            anchors.left: hardwareStatus.left
            anchors.top: cpuField.bottom
            anchors.topMargin: 8
            width: hardwareStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "CPU Temp"
            valueText: "<unknown> °C"
        }

        NodoInfoField {
            id: primaryStorageField
            anchors.left: hardwareStatus.left
            anchors.top: cpuTemperatureField.bottom
            anchors.topMargin: 8
            width: hardwareStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Primary Storage"
            valueText: "36.4 % in use"
        }

        NodoInfoField {
            id: backupStorageField
            anchors.left: hardwareStatus.left
            anchors.top: primaryStorageField.bottom
            anchors.topMargin: 8
            width: hardwareStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "Backup Storage"
            valueText: "59.0 % in use"
        }

        NodoInfoField {
            id: ramField
            anchors.left: hardwareStatus.left
            anchors.top: backupStorageField.bottom
            anchors.topMargin: 8
            width: hardwareStatus.width
            height: hheight
            itemSize: labelSize
            itemText: "RAM"
            valueText: "41 % in use"

        }
    }
}

