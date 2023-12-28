import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4

Item {
    id: nodeBandwidthScreen
    property int labelSize: 180

    NodoInfoField {
        id: incomingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: nodeBandwidthScreen.top
        width: 300
        height: 38
        itemSize: labelSize
        itemText: "Incoming peers limit"
        valueText: "64"
    }

    NodoInfoField {
        id: outgoingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: incomingPeersLimitField.bottom
        anchors.topMargin: 10
        width: 300
        height: 38
        itemSize: labelSize
        itemText: "Outgoing peers limit"
        valueText: "64"
    }

    NodoInfoField {
        id: rateLimitUpField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: outgoingPeersLimitField.bottom
        anchors.topMargin: 10
        width: 300
        height: 38
        itemSize: labelSize
        itemText: "Rate-limit up"
        valueText: "-1"
    }

    NodoInfoField {
        id: rateLimitDownField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: rateLimitUpField.bottom
        anchors.topMargin: 10
        width: 300
        height: 38
        itemSize: labelSize
        itemText: "Rate-limit down"
        valueText: "-1"
    }
}

