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
    anchors.topMargin: NodoSystem.subMenuTopMargin + 60

    property int labelSize: 0
    property int fieldTopMargin: NodoSystem.nodoTopMargin//5

    property int componentWidth: 600
    property int componentLeftMargin: 8
    property int componentBottomMargin: 15
    property int componentTopMargin: 34
    property int cardMargin: 15

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
        //moneroPayField.valueText = getServiceStatusText(nodoControl.getServiceStatus("moneropay"))
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
        currentBlockHeightField.valueText = nodoSystemStatus.getIntValueFromKey("height")
        moneroVersionField.valueText = nodoSystemStatus.getStringValueFromKey("version")
        outgoingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("outgoing_connections_count")
        incomingConnectionsField.valueText = nodoSystemStatus.getIntValueFromKey("incoming_connections_count")
        //whitePeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("white_peerlist_size")
        //greyPeerlistSizeField.valueText = nodoSystemStatus.getIntValueFromKey("grey_peerlist_size")
        updateAvailableField.valueText = (true === nodoSystemStatus.getBoolValueFromKey("update_available")) ? qsTr("Update available") : qsTr("Up to date")
    }

    function updateSyncPercentage() {
        var syncPercentage = syncInfo.getSyncPercentage()
        if (networkManager.getNetworkConnectionStatusCode() !== 1 /*not connected*/)
        {
            syncStatusField.itemText = qsTr("Disconnected")
            return
        }
        if(syncPercentage === 100)
        {
            syncStatusField.itemText = qsTr("Synchronized (100%)")
        }
        else if(syncPercentage >= 0)
        {
            syncStatusField.itemText = qsTr("Synchronizing (") + syncPercentage + "%)"
        }
        else if(syncPercentage === -1)
        {
            syncStatusField.itemText = qsTr("Not Synchronizing")
        }
        else
        {
            syncStatusField.itemText = qsTr("Waiting")
        }
    }

    function onCalculateMaximumTextLabelLength() {
        if(syncStatusField.labelRectRoundSize > labelSize)
            labelSize = syncStatusField.labelRectRoundSize

        if(currentBlockHeightField.labelRectRoundSize > labelSize)
            labelSize = currentBlockHeightField.labelRectRoundSize

        if(moneroVersionField.labelRectRoundSize > labelSize)
            labelSize = moneroVersionField.labelRectRoundSize

        if(outgoingConnectionsField.labelRectRoundSize > labelSize)
            labelSize = outgoingConnectionsField.labelRectRoundSize

        if(incomingConnectionsField.labelRectRoundSize > labelSize)
            labelSize = incomingConnectionsField.labelRectRoundSize
/*
        if(whitePeerlistSizeField.labelRectRoundSize > labelSize)
            labelSize = whitePeerlistSizeField.labelRectRoundSize

        if(greyPeerlistSizeField.labelRectRoundSize > labelSize)
            labelSize = greyPeerlistSizeField.labelRectRoundSize
*/
        if(updateAvailableField.labelRectRoundSize > labelSize)
            labelSize = updateAvailableField.labelRectRoundSize

        if(networkConnectionField.labelRectRoundSize > labelSize)
            labelSize = networkConnectionField.labelRectRoundSize
/*
        if(moneroNodeField.labelRectRoundSize > labelSize)
            labelSize = moneroNodeField.labelRectRoundSize

        if(torServiceField.labelRectRoundSize > labelSize)
            labelSize = torServiceField.labelRectRoundSize

        if(i2pServiceField.labelRectRoundSize > labelSize)
            labelSize = i2pServiceField.labelRectRoundSize

        if(moneroLWSField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSField.labelRectRoundSize

        //if(moneroPayField.labelRectRoundSize > labelSize)
        //    labelSize = moneroPayField.labelRectRoundSize

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
*/
    }

    NodoCanvas {
        id: syncStatus
        anchors.left: statusScreen.left
        anchors.top: statusScreen.top
        anchors.topMargin: 10
        anchors.leftMargin: 10//cardMargin
        width: 700
        height: networkConnectionField.y + networkConnectionField.height + componentBottomMargin//683
        color: NodoSystem.cardBackgroundColor

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
            font.pixelSize: NodoSystem.topMenuButtonFontSize +2
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontInter.name
        }

        NodoInfoField {
            id: syncStatusField
            anchors.left: syncStatusTabName.left
            anchors.top: syncStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatus.paintedWidth - componentLeftMargin
            height: statusScreenInfoFieldHeight
            itemSize: componentWidth
            //itemText: qsTr("Sync Status")
            itemText: (true === nodoSystemStatus.getBoolValueFromKey("synchronized")) ? qsTr("Synchronized") : qsTr("Synchronizing")
        }

        NodoInfoField {
            id: currentBlockHeightField
            anchors.left: syncStatusField.left
            anchors.top: syncStatusField.bottom
            anchors.topMargin: fieldTopMargin
            width: syncStatusTabName.paintedWidth
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
/*
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
*/
        NodoInfoField {
            id: updateAvailableField
            anchors.left: syncStatusField.left
            anchors.top: incomingConnectionsField.bottom
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
        //anchors.horizontalCenter: statusScreen.horizontalCenter
        
        anchors.top: statusScreen.top
        anchors.topMargin: 10
        anchors.leftMargin: cardMargin
        width: 480
        height: moneroLWSField.y + moneroLWSField.height + componentBottomMargin
        color: NodoSystem.cardBackgroundColor

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
            font.pixelSize: NodoSystem.topMenuButtonFontSize +2
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontInter.name
        }

        NodoInfoField {
            id: moneroNodeField
            anchors.left: systemStatusTabName.left
            anchors.top: systemStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: systemStatusTabName.paintedWidth - componentLeftMargin
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 60
            itemText: qsTr("Daemon")
            valueText: ""
        }

        NodoInfoField {
            id: torServiceField
            anchors.left: moneroNodeField.left
            anchors.top: moneroNodeField.bottom
            anchors.topMargin: fieldTopMargin
            width: labelSize
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 60
            itemText: qsTr("Tor Service")
            valueText: ""
        }

        NodoInfoField {
            id: i2pServiceField
            anchors.left: moneroNodeField.left
            anchors.top: torServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: labelSize
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 60
            itemText: qsTr("I2P Service")
            valueText: ""
        }

        NodoInfoField {
            id: moneroLWSField
            anchors.left: moneroNodeField.left
            anchors.top: i2pServiceField.bottom
            anchors.topMargin: fieldTopMargin
            width: labelSize
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 60
            itemText: qsTr("LWS")
            valueText: ""
        }
/*
        NodoInfoField {
            id: moneroPayField
            anchors.left: moneroNodeField.left
            anchors.top: moneroLWSField.bottom
            anchors.topMargin: fieldTopMargin
            width: labelSize
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 40
            itemText: qsTr("MoneroPay")
            valueText: ""
        }
*/
    }

    NodoCanvas {
        id: hardwareStatus
        anchors.right: statusScreen.right
        anchors.top: statusScreen.top
        anchors.topMargin: 10
        width: 700
        anchors.rightMargin: 2//cardMargin
        height: systemStorageField.y + systemStorageField.height + componentBottomMargin
        color: NodoSystem.cardBackgroundColor

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
            height: 22
            text: qsTr("System")
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: NodoSystem.topMenuButtonFontSize +2
            color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
            font.family: NodoSystem.fontInter.name
        }

        NodoInfoField {
            id: cpuField
            anchors.left: hardwareStatusTabName.left
            anchors.top: hardwareStatusTabName.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 50
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
            itemSize: labelSize - 50
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
            itemSize: labelSize - 50
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
            itemSize: labelSize - 50
            itemText: qsTr("Blockchain")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }

        NodoInfoField {
            id: systemStorageField
            anchors.left: hardwareStatusTabName.left
            anchors.top: blockchainStorageField.bottom
            anchors.topMargin: fieldTopMargin
            width: componentWidth
            height: statusScreenInfoFieldHeight
            itemSize: labelSize - 50
            itemText: qsTr("Storage")
            valueText: systemMessages.messages[NodoMessages.Message.Loading]
        }
    }
}
