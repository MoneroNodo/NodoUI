import QtQuick

Item {
    enum Message {
        Are_you_sure,
        Restarting_monerod_service_failed,
        Connection_with_nodo_dbus_service_failed,
        Close,
        Cancel
    }

    property var messages:[
        qsTr("Are you sure?"),
        qsTr("Restarting monerod service failed!"),
        qsTr("Connection with nodo-dbus service failed!"),
        qsTr("Close"),
        qsTr("Cancel")

    ]
}



