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
    anchors.topMargin: 60

    property int labelSize: 0
    property int fieldTopMargin: 5

    property int componentWidth: 600
    property int componentLeftMargin: 8
    property int componentBottomMargin: 8
    property int componentTopMargin: 34
    property int cardMargin: 13
    property color cardBackgroundColor: "#181818"

    property int statusScreenInfoFieldHeight: NodoSystem.nodoItemHeight

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
        updateServiceStatus()
        updateHardwareStatus()
        updateSystemStatus()
        checkNetworkConnection()
    }

    Connections {
        target: networkManager
        function onConnectionStatusChanged() {
            checkNetworkConnection()
        }
    }

    function checkNetworkConnection()
    {
        var statusCode = networkManager.getNetworkConnectionStatusCode()
        networkConnectionField.valueText = systemMessages.networkStatusMessages[statusCode]
    }

    function getServiceStatusText(message)
    {
        if(message === "inactive")
        {
            return systemMessages.serviceStatusMessages[NodoMessages.ServiceStatusMessages.Inactive]
        }
        else if(message === "active")
        {
            return systemMessages.serviceStatusMessages[NodoMessages.ServiceStatusMessages.Active]
        }
        else if(message === "activating")
        {
            return systemMessages.serviceStatusMessages[NodoMessages.ServiceStatusMessages.Activating]
        }
        else {
            return message
        }
    }

    function updateServiceStatus() {
        moneroNodeField.valueText = getServiceStatusText(nodoControl.getServiceStatus("monerod"))
        torServiceField.valueText = getServiceStatusText(nodoControl.getServiceStatus("tor"))
        i2pServiceField.valueText = getServiceStatusText(nodoControl.getServiceStatus("i2pd"))
        moneroLWSField.valueText = getServiceStatusText(nodoControl.getServiceStatus("monero-lws"))
        moneroPayField.valueText = getServiceStatusText(nodoControl.getServiceStatus("moneropay"))
    }

    function updateHardwareStatus() {
        cpuField.valueText = nodoControl.getCPUUsage()
        cpuTemperatureField.valueText = nodoControl.getTemperature()
        ramField.valueText = nodoControl.getRAMUsage()
        blockchainStorageField.valueText = nodoControl.getBlockChainStorageUsage()
        systemStorageField.valueText = nodoControl.getSystemStorageUsage()
    }

    function updateSystemStatus() {
        updateSyncPercentage()
        timestampField.valueText = nodoSystemStatus.getIntValueFromKey("start_time")
        currentBlockHeightField.valueText = nodoSystemStatus.getIntValueFromKey("height")
        moneroVersionField.valueText = nodoSystemStatus.getStringValueFromKey("version")
        outgoingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
        incomingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
        whitePeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
        greyPeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
        updateAvailableField.valueText = (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? qsTr("Update available") : qsTr("Up to date")
    }

    function updateSyncPercentage() {
        var syncPercentage = syncInfo.getSyncPercentage()
        if (networkManager.getNetworkConnectionStatusCode() !== 2 /*not connected*/)
        {
            syncStatusField.valueText = qsTr("Not Synchronizing")
            return
        }
        if(syncPercentage === 100)
        {
            syncStatusField.valueText = qsTr("Synchronized (100%)")
        }
        else if(syncPercentage >= 0)
        {
            syncStatusField.valueText = qsTr("Synchronizing (") + syncPercentage + "%)"
        }
        else if(syncPercentage === -1)
        {
            syncStatusField.valueText = qsTr("Not Synchronizing")
        }
        else
        {
            syncStatusField.valueText = qsTr("Waiting")
        }
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

        if(networkConnectionField.labelRectRoundSize > labelSize)
            labelSize = networkConnectionField.labelRectRoundSize

        if(moneroNodeField.labelRectRoundSize > labelSize)
            labelSize = moneroNodeField.labelRectRoundSize

        if(torServiceField.labelRectRoundSize > labelSize)
            labelSize = torServiceField.labelRectRoundSize

        if(i2pServiceField.labelRectRoundSize > labelSize)
            labelSize = i2pServiceField.labelRectRoundSize

        if(moneroLWSField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSField.labelRectRoundSize

        if(moneroPayField.labelRectRoundSize > labelSize)
            labelSize = moneroPayField.labelRectRoundSize

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
    }


    NodoCanvas {
        id: syncStatus
        anchors.left: statusScreen.left
        anchors.top: statusScreen.top
        anchors.topMargin: 5
        anchors.leftMargin: cardMargin
        width: componentWidth + 2 + (2*componentLeftMargin)
        height: networkConnectionField.y + networkConnectionField.height + componentBottomMargin//683
        color: cardBackgroundColor

        Connections {
            target: nodoSystemStatus
            function onSystemStatusReady() {
            updateSystemStatus()
            }
        }

        Connections {
            target: syncInfo
            function onSyncStatusReady() {
                updateSyncPercentage()
            }
        }

        Label {
            id: syncStatusTabName
            anchors.left: syncStatus.left
            anchors.top: syncStatus.top
            anchors.topMargin: componentTopMargin
            anchors.leftMargin: componentLeftMargin
            width: syncStatusTabName.paintedWidth
            height: 20
            text: qsTr("Monero Daemon")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: syncStatusField
            anchors.left: syncStatusTabName.left
            anchors.top: syncStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Sync Status")
            valueText: (true === nodoSystemStatus.getBoolValueFromKey("synchronized")) ? qsTr("Synchronized") : qsTr("Synchronizing")
        }

        NodoInfoField {
            id: timestampField
            anchors.left: syncStatusField.left
            anchors.top: syncStatusField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Timestamp")
            valueText: nodoSystemStatus.getIntValueFromKey("start_time")
        }

        NodoInfoField {
            id: currentBlockHeightField
            anchors.left: syncStatusField.left
            anchors.top: timestampField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Block Height")
            valueText: nodoSystemStatus.getIntValueFromKey("height")
        }

        NodoInfoField {
            id: moneroVersionField
            anchors.left: syncStatusField.left
            anchors.top: currentBlockHeightField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Version")
            valueText: nodoSystemStatus.getIntValueFromKey("version")
        }

        NodoInfoField {
            id: outgoingConnectionsField
            anchors.left: syncStatusField.left
            anchors.top: moneroVersionField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Outgoing Peers")
            valueText: nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
        }

        NodoInfoField {
            id: incomingConnectionsField
            anchors.left: syncStatusField.left
            anchors.top: outgoingConnectionsField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Incoming Peers")
            valueText: nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
        }

        NodoInfoField {
            id: whitePeerlistSizeField
            anchors.left: syncStatusField.left
            anchors.top: incomingConnectionsField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("White Peerlist")
            valueText: nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
        }

        NodoInfoField {
            id: greyPeerlistSizeField
            anchors.left: syncStatusField.left
            anchors.top: whitePeerlistSizeField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Grey Peerlist")
            valueText: nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
        }

        NodoInfoField {
            id: updateAvailableField
            anchors.left: syncStatusField.left
            anchors.top: greyPeerlistSizeField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Update")
            valueText: (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? qsTr("Update available") : qsTr("Up to date")
        }

        NodoInfoField {
            id: networkConnectionField
            anchors.left: syncStatusField.left
            anchors.top: updateAvailableField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Network")
        }
    }

    NodoCanvas {
        id: systemStatus
        anchors.horizontalCenter: statusScreen.horizontalCenter
        anchors.top: statusScreen.top
        anchors.topMargin: 10
        width: componentWidth + 2 + (2*componentLeftMargin)
        height: moneroPayField.y + moneroPayField.height + componentBottomMargin
        color: cardBackgroundColor

        Connections {
            target: nodoControl
            function onServiceStatusReady() {
                updateServiceStatus()
            }
        }

        Label {
            id: systemStatusTabName
            anchors.left: systemStatus.left
            anchors.top: systemStatus.top
            anchors.topMargin: componentTopMargin
            anchors.leftMargin: componentLeftMargin
            width: systemStatusTabName.paintedWidth
            height: 16
            text: qsTr("Services")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: moneroNodeField
            anchors.left: systemStatusTabName.left
            anchors.top: systemStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Monero Daemon")
            valueText: ""
        }

        NodoInfoField {
            id: torServiceField
            anchors.left: moneroNodeField.left
            anchors.top: moneroNodeField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Tor Service")
            valueText: ""
        }

        NodoInfoField {
            id: i2pServiceField
            anchors.left: moneroNodeField.left
            anchors.top: torServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("I2P Service")
            valueText: ""
        }

        NodoInfoField {
            id: moneroLWSField
            anchors.left: moneroNodeField.left
            anchors.top: i2pServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Monero LWS")
            valueText: ""
        }

        NodoInfoField {
            id: moneroPayField
            anchors.left: moneroNodeField.left
            anchors.top: moneroLWSField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("MoneroPay")
            valueText: ""
        }

    }

    NodoCanvas {
        id: hardwareStatus
        anchors.right: statusScreen.right
        anchors.top: statusScreen.top
        anchors.topMargin: 10
        width: componentWidth + 2 + (2*componentLeftMargin)
        anchors.rightMargin: cardMargin
        height: systemStorageField.y + systemStorageField.height + componentBottomMargin
        color: cardBackgroundColor

        Connections {
            target: nodoControl
            function onSystemStatusReady() {
                updateHardwareStatus();
            }
        }

        Label {
            id: hardwareStatusTabName
            anchors.left: hardwareStatus.left
            anchors.top: hardwareStatus.top
            anchors.topMargin: componentTopMargin
            anchors.leftMargin: componentLeftMargin
            width: hardwareStatusTabName.paintedWidth
            height: 16
            text: qsTr("System")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: NodoSystem.topMenuButtonFontSize
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }

        NodoInfoField {
            id: cpuField
            anchors.left: hardwareStatusTabName.left
            anchors.top: hardwareStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("CPU")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }

        NodoInfoField {
            id: cpuTemperatureField
            anchors.left: hardwareStatusTabName.left
            anchors.top: cpuField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Temperature")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }

        NodoInfoField {
            id: ramField
            anchors.left: hardwareStatusTabName.left
            anchors.top: cpuTemperatureField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("RAM")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }

        NodoInfoField {
            id: blockchainStorageField
            anchors.left: hardwareStatusTabName.left
            anchors.top: ramField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("Blockchain Storage")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }

        NodoInfoField {
            id: systemStorageField
            anchors.left: hardwareStatusTabName.left
            anchors.top: blockchainStorageField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize
            itemText: qsTr("System Storage")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }
    }
}

