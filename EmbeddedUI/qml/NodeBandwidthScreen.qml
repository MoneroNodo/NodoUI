import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: nodeBandwidthScreen
    property int labelSize: 0
    property int inputFieldWidth: 600

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(incomingPeersLimitField.labelRectRoundSize > labelSize)
            labelSize = incomingPeersLimitField.labelRectRoundSize

        if(outgoingPeersLimitField.labelRectRoundSize > labelSize)
            labelSize = outgoingPeersLimitField.labelRectRoundSize

        if(rateLimitUpField.labelRectRoundSize > labelSize)
            labelSize = rateLimitUpField.labelRectRoundSize

        if(rateLimitDownField.labelRectRoundSize > labelSize)
            labelSize = rateLimitDownField.labelRectRoundSize
    }

    NodoInfoField {
        id: incomingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: nodeBandwidthScreen.top
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Incoming peers limit")
        valueText: "64"
    }

    NodoInfoField {
        id: outgoingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: incomingPeersLimitField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Outgoing peers limit")
        valueText: "64"
    }

    NodoInfoField {
        id: rateLimitUpField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: outgoingPeersLimitField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Bandwidth Up")
        valueText: "-1"
    }

    NodoInfoField {
        id: rateLimitDownField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: rateLimitUpField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Bandwidth Down")
        valueText: "-1"
    }
}

