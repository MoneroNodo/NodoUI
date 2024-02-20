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
    property int hheight: 64 // 150

    Component.onCompleted: {
        nodoSystemStatus.updateRequested()
    }

    Rectangle {
        id: syncStatus
        anchors.left: statusScreen.left
        anchors.top: statusScreen.top
        anchors.topMargin: 20
        anchors.leftMargin: 50
        width: 560
        height: 500
        color: "black"

        Connections {
            target: nodoSystemStatus
            function onSystemStatusReady() {
                syncStatusField.valueText = (true === nodoSystemStatus.getBoolValueFromKey("synchronized")) ? "Synchronized" : "Syncing"
                timestampField.valueText = nodoSystemStatus.getIntValueFromKey("start_time")
                currentSyncHeightField.valueText = nodoSystemStatus.getIntValueFromKey("height")
                moneroVersionField.valueText = nodoSystemStatus.getStringValueFromKey("version")
                outgoingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
                incomingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
                whitePeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
                greyPeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
                updateAvailableField.valueText = (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? "Update available" : "Update not available"
            }
        }

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
            valueText: (true === nodoSystemStatus.getBoolValueFromKey("synchronized")) ? "Synchronized" : "Syncing"
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
            valueText: nodoSystemStatus.getIntValueFromKey("start_time")
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
            valueText: nodoSystemStatus.getIntValueFromKey("height")
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
            valueText: nodoSystemStatus.getIntValueFromKey("version")
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
            valueText: nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
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
            valueText: nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
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
            valueText: nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
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
            valueText: nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
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
            valueText: (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? "Update available" : "Update not available"
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
            valueText: ""
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
            valueText: ""
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
            valueText: ""
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
            valueText: ""
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
            valueText: ""
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
            valueText: ""
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
            valueText: "in use"
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
            valueText: "in use"
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
            valueText: "in use"

        }
    }
}

