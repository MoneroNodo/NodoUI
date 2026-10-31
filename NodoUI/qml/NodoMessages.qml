import QtQuick

Item {
    enum Message {
        Close,
        Cancel,
        AddNewConnection,
        Add,
        Adding,
        Apply,
        ApplyPort,
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
        CableDisconnected,
        Address,
        Port,
        Loading,
        NewPINSet,
        PINCodesDoNotMatch,
        FailedToChangePassword,
        PasswordChangedSuccessfully,
        InputFieldCantBeEmpty,
        RecoveryApprove,
        Accept,
        RecoveryStarted,
        RecoveryCompleted,
        NoStorageFound,
        NewBlockChainStorageFound,
        OldPasswordIsWrong
    }

    property var messages:[
        qsTr("CLOSE"),
        qsTr("CANCEL"),
        qsTr("NEW CONNECTION"),
        qsTr("CONNECT"),
        qsTr("CONNECTING"),
        qsTr("APPLY"),
        qsTr("APPLY PORT"),
        qsTr("FORGET"),
        qsTr("CONNECT"),
        qsTr("CONNECTING"),
        qsTr("DISCONNECT"),
        qsTr("DISCONNECTING"),
        qsTr("Ethernet"),
        qsTr("Wi-Fi"),
        qsTr("Ethernet Name"),
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
        qsTr("Current Network"),
        qsTr("Available Networks"),
        qsTr("ADVANCED"),
        qsTr("No network device found!"),
        qsTr("Ethernet cable disconnected!"),
        qsTr("Address"),
        qsTr("Port"),
        qsTr("Loading"),
        qsTr("New PIN is set"),
        qsTr("PIN codes do not match."),
        qsTr("Failed to change password"),
        qsTr("Password changed successfully"),
        qsTr("Input field can't be empty!"),
        qsTr("This process will reset Nodo to factory defaults. All settings and user info will be lost. Begin factory reset?"),
        qsTr("ACCEPT"),
        qsTr("Restoring Nodo to factory defaults..."),
        qsTr("Completed factory reset, now rebooting..."),
        qsTr("Blockchain storage not found!"),
        qsTr("New blockchain storage found!"),
        qsTr("Old password is incorrect!")
    ]


    enum BackendMessages {
        NoError,
        RestartingTorFailed,
        RestartingMoneroFailed,
        ConnectionToNodoDbusFailed,
        ConnectionToNodoNMDbusFailed,
        GatheringIPFailed,
        NoNetworkDeviceFound,
        CableDisconnected,
        SomethingIsWrong,
        NewPinIsSet,
        PasswordDoesntMeetRequirements,
        PasswordsDontMatch
    }

    property var backendMessages: [
        qsTr("No Error"),
        qsTr("Restarting tor service failed!"),
        qsTr("Restarting monerod service failed!"),
        qsTr("Connection to Network Manager service failed!"),
        qsTr("Connection to Nodonm service failed!"),
        qsTr("IP couldn't be read!"),
        qsTr("No network device found!"),
        qsTr("Ethernet cable disconnected!"),
        qsTr("Something is wrong!"),
        qsTr("New PIN is set."),
        qsTr("Password does not meet requirements."),
        qsTr("Passwords do not match.")
    ]

    enum NetworkStatusMessages {
        Waiting,
        Connected,
        NoInternet,
        Disconnected
    }

    property var networkStatusMessages: [
        qsTr("Waiting"),
        qsTr("Connected"),
        qsTr("No Internet"),
        qsTr("Disconnected")
    ]

    enum ServiceStatusMessages {
        Active,
        Inactive,
        Activating,
        Deactivating
    }

    property var serviceStatusMessages: [
        qsTr("Active"),
        qsTr("Inactive"),
        qsTr("Starting"),
        qsTr("Stopping"),
    ]
}
