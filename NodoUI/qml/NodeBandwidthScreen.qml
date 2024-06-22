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
    property bool inputFieldReadOnly: false
    property int incomingPeersLimit
    property int outgoingPeersLimit
    property int rateLimitUp
    property int rateLimitDown
    property string bwUnit: qsTr("kB/s")

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        nodeBandwidthScreen.inputFieldReadOnly = !nodoControl.isComponentEnabled();
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            nodeBandwidthScreen.incomingPeersLimit = nodoConfig.getIntValueFromKey("config", "in_peers")
            nodeBandwidthScreen.outgoingPeersLimit = nodoConfig.getIntValueFromKey("config", "out_peers")
            nodeBandwidthScreen.rateLimitUp = nodoConfig.getIntValueFromKey("config", "limit_rate_up")
            nodeBandwidthScreen.rateLimitDown = nodoConfig.getIntValueFromKey("config", "limit_rate_down")
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            systemPopup.popupMessageText = nodoControl.getErrorMessage()
            systemPopup.commandID = -1;
            systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            systemPopup.open();
        }

        function onComponentEnabledStatusChanged() {
            nodeBandwidthScreen.inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }
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

    NodoInputField {
        id: incomingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: nodeBandwidthScreen.top
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Incoming peers limit")
        valueText: nodeBandwidthScreen.incomingPeersLimit
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: nodeBandwidthScreen.inputFieldReadOnly
        validator: IntValidator{bottom: 0;}
        onTextEditFinished: {
            if(incomingPeersLimitField.valueText !== nodeBandwidthScreen.incomingPeersLimit.toString())
            {
                nodeBandwidthApplyButton.isActive = true
            }
        }
    }

    NodoInputField {
        id: outgoingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: incomingPeersLimitField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Outgoing peers limit")
        valueText: nodeBandwidthScreen.outgoingPeersLimit
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: nodeBandwidthScreen.inputFieldReadOnly
        validator: IntValidator{bottom: 0;}
        onTextEditFinished: {
            if(outgoingPeersLimitField.valueText !== nodeBandwidthScreen.outgoingPeersLimit.toString())
            {
                nodeBandwidthApplyButton.isActive = true
            }
        }
    }

    NodoInputField {
        id: rateLimitUpField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: outgoingPeersLimitField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Bandwidth Up")
        valueText: nodeBandwidthScreen.rateLimitUp !== -1 ? nodeBandwidthScreen.rateLimitUp : ""
        textFlag: Qt.ImhPreferNumbers
        readOnlyFlag: nodeBandwidthScreen.inputFieldReadOnly
        validator: IntValidator{bottom: -1;}
        onTextEditFinished: {
            if(rateLimitUpField.valueText !== nodeBandwidthScreen.rateLimitUp.toString())
            {
                nodeBandwidthApplyButton.isActive = true
            }
        }
    }

    Rectangle {
        id: rateLimitUpUnitRect
        anchors.left: rateLimitUpField.right
        anchors.top: rateLimitUpField.top
        anchors.leftMargin: 8
        color: "transparent"

        Text {
            id: rateLimitUpUnit
            text: bwUnit
            anchors.left: rateLimitUpUnitRect.right
            height: NodoSystem.infoFieldLabelHeight
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.inputFieldValueFontSize
            color: (nodeBandwidthScreen.inputFieldReadOnly === true) ? NodoSystem.buttonDisabledColor : nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        }
    }

    NodoInputField {
        id: rateLimitDownField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: rateLimitUpField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Bandwidth Down")
        valueText: nodeBandwidthScreen.rateLimitDown !== -1 ? nodeBandwidthScreen.rateLimitDown : ""
        textFlag: Qt.ImhPreferNumbers
        readOnlyFlag: nodeBandwidthScreen.inputFieldReadOnly
        validator: IntValidator{bottom: -1;}
        onTextEditFinished: {
            if(rateLimitDownField.valueText !== nodeBandwidthScreen.rateLimitDown.toString())
            {
                nodeBandwidthApplyButton.isActive = true
            }
        }
    }


    Rectangle {
        id: rateLimitDownUnitRect
        anchors.left: rateLimitDownField.right
        anchors.top: rateLimitDownField.top
        anchors.leftMargin: 8
        color: "transparent"

        Text {
            id: rateLimitDownUnit
            text: bwUnit
            anchors.left: rateLimitDownUnitRect.right
            height: NodoSystem.infoFieldLabelHeight
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.inputFieldValueFontSize
            color: (nodeBandwidthScreen.inputFieldReadOnly === true) ? NodoSystem.buttonDisabledColor : nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        }
    }

    NodoButton {
        id: nodeBandwidthApplyButton
        anchors.left: nodeBandwidthScreen.left
        anchors.top: rateLimitDownField.bottom
        anchors.topMargin: 20
        text: qsTr("Apply")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setNodeBandwidthParameters(incomingPeersLimitField.valueText, outgoingPeersLimitField.valueText, rateLimitUpField.valueText, rateLimitDownField.valueText)
        }
    }
}

