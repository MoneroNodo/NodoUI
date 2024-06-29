import QtQuick

Item {
    enum Message {
        Close,
        Cancel,
        AddNewConnection,
        Add,
        Adding,
        Forget,
        Connect,
        Connecting,
        Disconnect,
        Disconnecting,
        Ethernet,
        WiFi,
        ConnectionName,
        SSID,
        DHCP,
        IPAddress,
        SubnetMask,
        Router,
        DNS,
        DeviceSpeed,
        SignalStrength,
        SecurityType,
        Frequency,
        Password,
        CurrentNetwork,
        AvailableNetworks,
        Advanced,
        NoNetworkDevice,
        CableDisconnected
    }

    property var messages:[
        qsTr("Close"),
        qsTr("Cancel"),
        qsTr("Add new connection"),
        qsTr("Add"),
        qsTr("Adding"),
        qsTr("Forget"),
        qsTr("Connect"),
        qsTr("Connecting"),
        qsTr("Disconnect"),
        qsTr("Disconnecting"),
        qsTr("Ethernet"),
        qsTr("Wi-Fi"),
        qsTr("Connection name"),
        qsTr("SSID"),
        qsTr("DHCP"),
        qsTr("Address"),
        qsTr("Subnet Mask"),
        qsTr("Router"),
        qsTr("DNS"),
        qsTr("Device Speed"),
        qsTr("Signal Strength"),
        qsTr("Security Type"),
        qsTr("Frequency"),
        qsTr("Password"),
        qsTr("Current network"),
        qsTr("Available networks"),
        qsTr("Advanced"),
        qsTr("No network device found!"),
        qsTr("Cable disconnected!")
    ]
}



