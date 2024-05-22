import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

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

