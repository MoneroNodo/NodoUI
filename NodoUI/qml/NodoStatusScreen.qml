import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Rectangle {
    id: statusScreen
    color: "black"
    anchors.fill: parent

    property int labelSize: 0
    property int fieldTopMargin: 5

    Component.onCompleted: {
        nodoSystemStatus.updateRequested()
        nodoControl.startServiceStatusUpdate()
        onCalculateMaximumTextLabelLength()
        nodoControl.startSystemStatusUpdate()
    }

    Component.onDestruction: {
        serviceStatusTimer.stop()
    }

    function onCalculateMaximumTextLabelLength() {
        if(syncStatusField.labelRectRoundSize > labelSize)
            labelSize = syncStatusField.labelRectRoundSize

        if(timestampField.labelRectRoundSize > labelSize)
            labelSize = timestampField.labelRectRoundSize

        if(currentBlockHeightField.labelRectRoundSize > labelSize)
            labelSize = currentBlockHeightField.labelRectRoundSize

        if(moneroVersionField.labelRectRoundSize > labelSize)
            labelSize = moneroVersionField.labelRectRoundSize

        if(outgoingConnectionsField.labelRectRoundSize > labelSize)
            labelSize = outgoingConnectionsField.labelRectRoundSize

        if(incomingConnectionsField.labelRectRoundSize > labelSize)
            labelSize = incomingConnectionsField.labelRectRoundSize

        if(whitePeerlistSizeField.labelRectRoundSize > labelSize)
            labelSize = whitePeerlistSizeField.labelRectRoundSize

        if(greyPeerlistSizeField.labelRectRoundSize > labelSize)
            labelSize = greyPeerlistSizeField.labelRectRoundSize

        if(updateAvailableField.labelRectRoundSize > labelSize)
            labelSize = updateAvailableField.labelRectRoundSize

        if(moneroNodeField.labelRectRoundSize > labelSize)
            labelSize = moneroNodeField.labelRectRoundSize

        if(minerServiceField.labelRectRoundSize > labelSize)
            labelSize = minerServiceField.labelRectRoundSize

        if(torServiceField.labelRectRoundSize > labelSize)
            labelSize = torServiceField.labelRectRoundSize

        if(i2pServiceField.labelRectRoundSize > labelSize)
            labelSize = i2pServiceField.labelRectRoundSize

        if(moneroLWSField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSField.labelRectRoundSize

        if(blockExplorerField.labelRectRoundSize > labelSize)
            labelSize = blockExplorerField.labelRectRoundSize

        if(cpuField.labelRectRoundSize > labelSize)
            labelSize = cpuField.labelRectRoundSize

        if(cpuTemperatureField.labelRectRoundSize > labelSize)
            labelSize = cpuTemperatureField.labelRectRoundSize

        if(ramField.labelRectRoundSize > labelSize)
            labelSize = ramField.labelRectRoundSize

        if(blockchainStorageField.labelRectRoundSize > labelSize)
            labelSize = blockchainStorageField.labelRectRoundSize

        if(systemStorageField.labelRectRoundSize > labelSize)
            labelSize = systemStorageField.labelRectRoundSize

        if(hashRateField.labelRectRoundSize > labelSize)
            labelSize = hashRateField.labelRectRoundSize

        if(dailyTXAvgField.labelRectRoundSize > labelSize)
            labelSize = dailyTXAvgField.labelRectRoundSize

        if(mempoolSizeField.labelRectRoundSize > labelSize)
            labelSize = mempoolSizeField.labelRectRoundSize

        if(avgTXFeeField.labelRectRoundSize > labelSize)
            labelSize = avgTXFeeField.labelRectRoundSize

        if(tXPerSecondField.labelRectRoundSize > labelSize)
            labelSize = tXPerSecondField.labelRectRoundSize

        if(blocksPerHourField.labelRectRoundSize > labelSize)
            labelSize = blocksPerHourField.labelRectRoundSize
    }


    Rectangle {
        id: syncStatus
        anchors.left: statusScreen.left
        anchors.top: statusScreen.top
        anchors.topMargin: 20
        anchors.leftMargin: 30
        width: 600
        height: 500
        color: "black"

        Connections {
            target: nodoSystemStatus
            function onSystemStatusReady() {
                syncStatusField.valueText = (true === nodoSystemStatus.getBoolValueFromKey("synchronized")) ? qsTr("Synchronized") : qsTr("Synchronizing")
                timestampField.valueText = nodoSystemStatus.getIntValueFromKey("start_time")
                currentBlockHeightField.valueText = nodoSystemStatus.getIntValueFromKey("height")
                moneroVersionField.valueText = nodoSystemStatus.getStringValueFromKey("version")
                outgoingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
                incomingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
                whitePeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
                greyPeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
                updateAvailableField.valueText = (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? qsTr("Update available") : qsTr("Update not available")
            }
        }

        Connections {
            target: nodoControl
            function onServiceStatusReady() {
                moneroNodeField.valueText = nodoControl.getServiceStatus("monerod")
                minerServiceField.valueText = nodoControl.getServiceStatus("miner")
                torServiceField.valueText = nodoControl.getServiceStatus("tor")
                i2pServiceField.valueText = nodoControl.getServiceStatus("i2p")
                moneroLWSField.valueText = nodoControl.getServiceStatus("monero-lws")
                blockExplorerField.valueText = nodoControl.getServiceStatus("block-explorer")
            }
        }

        Connections {
            target: nodoControl
            function onSystemStatusReady() {
                cpuField.valueText = nodoControl.getCPUUsage()
                cpuTemperatureField.valueText = nodoControl.getTemperature()
                ramField.valueText = nodoControl.getRAMUsage()
                blockchainStorageField.valueText = nodoControl.getBlockChainStorageUsage()
                systemStorageField.valueText = nodoControl.getSystemStorageUsage()
            }
        }


        Label {
            id: syncStatusTabName
            anchors.left: syncStatus.left
            anchors.top: syncStatus.top
            anchors.topMargin: 30
            width: syncStatusTabName.paintedWidth
            height: 16
            text: qsTr("Node")
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
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Sync Status")
            valueText: (true === nodoSystemStatus.getBoolValueFromKey("synchronized")) ? qsTr("Synchronized") : qsTr("Synchronizing")
        }

        NodoInfoField {
            id: timestampField
            anchors.left: syncStatus.left
            anchors.top: syncStatusField.bottom
            anchors.topMargin: fieldTopMargin

            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Timestamp")
            valueText: nodoSystemStatus.getIntValueFromKey("start_time")
        }

        NodoInfoField {
            id: currentBlockHeightField
            anchors.left: syncStatus.left
            anchors.top: timestampField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Block Height")
            valueText: nodoSystemStatus.getIntValueFromKey("height")
        }

        NodoInfoField {
            id: moneroVersionField
            anchors.left: syncStatus.left
            anchors.top: currentBlockHeightField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Version")
            valueText: nodoSystemStatus.getIntValueFromKey("version")
        }

        NodoInfoField {
            id: outgoingConnectionsField
            anchors.left: syncStatus.left
            anchors.top: moneroVersionField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Outgoing Peers")
            valueText: nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
        }

        NodoInfoField {
            id: incomingConnectionsField
            anchors.left: syncStatus.left
            anchors.top: outgoingConnectionsField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Incoming Peers")
            valueText: nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
        }

        NodoInfoField {
            id: whitePeerlistSizeField
            anchors.left: syncStatus.left
            anchors.top: incomingConnectionsField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("White Peerlist")
            valueText: nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
        }

        NodoInfoField {
            id: greyPeerlistSizeField
            anchors.left: syncStatus.left
            anchors.top: whitePeerlistSizeField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Grey Peerlist")
            valueText: nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
        }

        NodoInfoField {
            id: updateAvailableField
            anchors.left: syncStatus.left
            anchors.top: greyPeerlistSizeField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Update")
            valueText: (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? qsTr("Available") : qsTr("Up to date")
        }
    }

    Rectangle {
        id: systemStatus
        anchors.horizontalCenter: statusScreen.horizontalCenter
        anchors.top: statusScreen.top
        anchors.topMargin: 20

        width: 600
        height: 470
        color: "black"

        Label {
            id: systemStatusTabName
            anchors.left: systemStatus.left
            anchors.top: systemStatus.top
            anchors.topMargin: 30
            width: systemStatusTabName.paintedWidth
            height: 16
            text: qsTr("Services")
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
            anchors.topMargin: fieldTopMargin
            width: systemStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Monero Daemon")
            valueText: ""
        }

        NodoInfoField {
            id: minerServiceField
            anchors.left: systemStatus.left
            anchors.top: moneroNodeField.bottom
            anchors.topMargin: fieldTopMargin
            width: systemStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Monero Miner")
            valueText: ""
        }

        NodoInfoField {
            id: torServiceField
            anchors.left: systemStatus.left
            anchors.top: minerServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: systemStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Tor Service")
            valueText: ""
        }

        NodoInfoField {
            id: i2pServiceField
            anchors.left: systemStatus.left
            anchors.top: torServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: systemStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("I2P Service")
            valueText: ""
        }

        NodoInfoField {
            id: moneroLWSField
            anchors.left: systemStatus.left
            anchors.top: i2pServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: systemStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Monero LWS")
            valueText: ""
        }

        NodoInfoField {
            id: blockExplorerField
            anchors.left: systemStatus.left
            anchors.top: moneroLWSField.bottom
            anchors.topMargin: fieldTopMargin
            width: systemStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Block Explorer")
            valueText: ""
        }
    }

    Rectangle {
        id: moneroStatus
        anchors.horizontalCenter: statusScreen.horizontalCenter
        anchors.top: systemStatus.bottom
        anchors.topMargin: 20

        width: 600
        height: 470
        color: "black"

        Label {
            id: moneroStatusTabName
            anchors.left: moneroStatus.left
            anchors.top: moneroStatus.top
            anchors.topMargin: 30
            width: moneroStatusTabName.paintedWidth
            height: 16
            text: qsTr("Monero")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 40
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: hashRateField
            anchors.left: moneroStatus.left
            anchors.top: moneroStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: moneroStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Hash Rate")
            valueText: ""
        }

        NodoInfoField {
            id: dailyTXAvgField
            anchors.left: moneroStatus.left
            anchors.top: hashRateField.bottom
            anchors.topMargin: fieldTopMargin
            width: moneroStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Daily TX Avg (24h)")
            valueText: ""
        }

        NodoInfoField {
            id: mempoolSizeField
            anchors.left: moneroStatus.left
            anchors.top: dailyTXAvgField.bottom
            anchors.topMargin: fieldTopMargin
            width: moneroStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Mempool Size")
            valueText: ""
        }

        NodoInfoField {
            id: avgTXFeeField
            anchors.left: moneroStatus.left
            anchors.top: mempoolSizeField.bottom
            anchors.topMargin: fieldTopMargin
            width: moneroStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Avg TX fee (24h)")
            valueText: ""
        }

        NodoInfoField {
            id: tXPerSecondField
            anchors.left: avgTXFeeField.left
            anchors.top: avgTXFeeField.bottom
            anchors.topMargin: fieldTopMargin
            width: moneroStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("TX per second")
            valueText: ""
        }

        NodoInfoField {
            id: blocksPerHourField
            anchors.left: moneroStatus.left
            anchors.top: tXPerSecondField.bottom
            anchors.topMargin: fieldTopMargin
            width: moneroStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Blocks per hour")
            valueText: ""
        }
    }

    Rectangle {
        id: hardwareStatus
        anchors.right: statusScreen.right
        anchors.top: statusScreen.top
        anchors.topMargin: 20
        anchors.rightMargin: 30
        width: 600
        height: 500
        color: "black"

        Label {
            id: hardwareStatusTabName
            anchors.left: hardwareStatus.left
            anchors.top: hardwareStatus.top
            anchors.topMargin: 30
            width: hardwareStatusTabName.paintedWidth
            height: 16
            text: qsTr("System")
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
            anchors.topMargin: fieldTopMargin
            width: hardwareStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("CPU")
            valueText: "<loading>"
        }

        NodoInfoField {
            id: cpuTemperatureField
            anchors.left: hardwareStatus.left
            anchors.top: cpuField.bottom
            anchors.topMargin: fieldTopMargin
            width: hardwareStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Temperature")
            valueText: "<loading>"
        }

        NodoInfoField {
            id: ramField
            anchors.left: hardwareStatus.left
            anchors.top: cpuTemperatureField.bottom
            anchors.topMargin: fieldTopMargin
            width: hardwareStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("RAM")
            valueText: "in use"
        }

        NodoInfoField {
            id: blockchainStorageField
            anchors.left: hardwareStatus.left
            anchors.top: ramField.bottom
            anchors.topMargin: fieldTopMargin
            width: hardwareStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Blockchain Storage")
            valueText: "<loading>"
        }

        NodoInfoField {
            id: systemStorageField
            anchors.left: hardwareStatus.left
            anchors.top: blockchainStorageField.bottom
            anchors.topMargin: fieldTopMargin
            width: hardwareStatus.width
            height: NodoSystem.infoFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("System Storage")
            valueText: "<loading>"
        }
    }

    Timer {
        id: serviceStatusTimer
        interval: 3000;
        running: true;
        repeat: true;
        onTriggered:
        {
            nodoControl.startServiceStatusUpdate()
            nodoControl.startSystemStatusUpdate()
        }
    }
}

