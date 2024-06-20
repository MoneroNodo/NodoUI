import QtQuick

Item {
    enum Message {
        Close,
        Cancel
    }

    property var messages:[
        qsTr("Close"),
        qsTr("Cancel")

    ]
}



