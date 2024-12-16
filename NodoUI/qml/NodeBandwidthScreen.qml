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
    property bool switchCheckable: true
    property int incomingPeersLimit
    property int outgoingPeersLimit
    property int rateLimitUp
    property int rateLimitDown
    property string bwUnit: qsTr("kB/s")
    property string unlimitedbw: "∞"
    property int defaultBW: 4096
    property bool configReceived: false
    property bool processConfig: true
    property string rateLimitUpStr
    property string rateLimitDownStr

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            if(false === processConfig)
            {
                return
            }

            incomingPeersLimit = nodoConfig.getIntValueFromKey("config", "in_peers")
            outgoingPeersLimit = nodoConfig.getIntValueFromKey("config", "out_peers")
            rateLimitUp = nodoConfig.getIntValueFromKey("config", "limit_rate_up")
            rateLimitDown = nodoConfig.getIntValueFromKey("config", "limit_rate_down")

            rateLimitUpStr = rateLimitUp
            rateLimitDownStr = rateLimitDown

            if(-1 === rateLimitUp)
            {
                rateLimitUpField.valueText = unlimitedbw
                rateLimitUpField.readOnlyFlag = true
                rateLimitUpUnlimitedSwitch.checked = true
            }
            else
            {
                rateLimitUpField.valueText = rateLimitUp
                rateLimitUpField.readOnlyFlag = false
                rateLimitUpUnlimitedSwitch.checked = false
            }

            if(-1 === rateLimitDown)
            {
                rateLimitDownField.valueText = unlimitedbw
                rateLimitDownField.readOnlyFlag = true
                rateLimitDownUnlimitedSwitch.checked = true
            }
            else
            {
                rateLimitDownField.valueText = rateLimitUp
                rateLimitDownField.readOnlyFlag = false
                rateLimitDownUnlimitedSwitch.checked = false
            }

            if(false == configReceived)
            {
                configReceived = true
            }
        }
    }

    Connections {
        target: nodoControl
        function onServiceManagerNotificationReceived(str) {
            if (str.startsWith("monerod:restart"))
            {
                nodeBandwidthApplyButton.isActive = true
            }
        }
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            nodeBandwithPopup.popupMessageText = systemMessages.backendMessages[errorCode]
            // nodeBandwithPopup.popupMessageText = nodoControl.getErrorMessage()
            nodeBandwithPopup.commandID = -1;
            nodeBandwithPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            nodeBandwithPopup.open();
        }

        function onComponentEnabledStatusChanged() {
            var status = nodoControl.isComponentEnabled()
            inputFieldReadOnly = !status
            switchCheckable = status

            if(false === status)
            {
                rateLimitUpField.readOnlyFlag = !status
                rateLimitDownField.readOnlyFlag = !status
            }
            else
            {
                if(unlimitedbw === rateLimitUpField.valueText)
                {
                    rateLimitUpField.readOnlyFlag = true
                }
                else
                {
                    rateLimitUpField.readOnlyFlag = false
                }

                if(unlimitedbw === rateLimitDownField.valueText)
                {
                    rateLimitDownField.readOnlyFlag = true
                }
                else
                {
                    rateLimitDownField.readOnlyFlag = false
                }
            }
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
        id: outgoingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: nodeBandwidthScreen.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Outgoing Peers")
        valueText: outgoingPeersLimit
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: inputFieldReadOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if("" === outgoingPeersLimitField.valueText)
            {
                outgoingPeersLimitField.valueText = outgoingPeersLimit.toString()
            }

            if(outgoingPeersLimitField.valueText !== outgoingPeersLimit.toString())
            {
                processConfig = false
                nodeBandwidthApplyButton.isActive = true
            }
        }
    }

    NodoInputField {
        id: incomingPeersLimitField
        anchors.left: nodeBandwidthScreen.left
        anchors.top: incomingPeersLimitField.bottom
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Incoming Peers")
        valueText: incomingPeersLimit
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: inputFieldReadOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if("" === incomingPeersLimitField.valueText)
            {
                incomingPeersLimitField.valueText = incomingPeersLimit.toString()
            }

            if(incomingPeersLimitField.valueText !== incomingPeersLimit.toString())
            {
                processConfig = false
                nodeBandwidthApplyButton.isActive = true
            }
        }
    }

    Rectangle {
        id: rateLimitUpFieldRect
        anchors.left: nodeBandwidthScreen.left
        anchors.top: incomingPeersLimitField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoInputField {
            id: rateLimitUpField
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Upload Speed")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{bottom: 0}
            onTextEditFinished: {
                if("" === rateLimitUpField.valueText)
                {
                    rateLimitUpField.valueText = defaultBW.toString()
                    rateLimitUpStr = "-1"
                }
                else
                {
                    rateLimitUpStr = rateLimitUpField.valueText
                }
                nodeBandwidthApplyButton.isActive = true
            }
        }

        Text {
            id: rateLimitUpUnit
            text: bwUnit
            anchors.left: rateLimitUpField.right
            anchors.top: rateLimitUpFieldRect.top
            anchors.leftMargin: 8

            height: NodoSystem.nodoItemHeight
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.inputFieldValueFontSize
            color: (nodeBandwidthScreen.inputFieldReadOnly === true) ? NodoSystem.buttonDisabledColor : nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        }

        Rectangle {
            id: rateLimitUpUnlimitedSwitchRect
            anchors.left: rateLimitUpUnit.right
            anchors.top: rateLimitUpFieldRect.top
            height: NodoSystem.nodoItemHeight
            anchors.leftMargin: 10

            NodoLabel{
                id: rateLimitUpUnlimitedSwitchText
                height: rateLimitUpUnlimitedSwitchRect.height
                anchors.left: rateLimitUpUnlimitedSwitchRect.left
                anchors.top: rateLimitUpUnlimitedSwitchRect.top
                text: qsTr("Unlimited")
            }

            NodoSwitch {
                id: rateLimitUpUnlimitedSwitch
                anchors.left: rateLimitUpUnlimitedSwitchText.right
                anchors.leftMargin: NodoSystem.padding
                height: rateLimitUpUnlimitedSwitchRect.height
                width: 2*rateLimitUpUnlimitedSwitchRect.height
                display: AbstractButton.IconOnly
                checkable: switchCheckable
                onCheckedChanged: {
                    if(checked)
                    {
                        rateLimitUpField.valueText = unlimitedbw
                        rateLimitUpField.readOnlyFlag = true
                        rateLimitUpStr = "-1"
                    }
                    else
                    {
                        rateLimitUpField.valueText = defaultBW
                        rateLimitUpField.readOnlyFlag = false
                        rateLimitUpStr = defaultBW
                    }

                    if(true === configReceived)
                    {
                        processConfig = false
                        nodeBandwidthApplyButton.isActive = true
                    }
                }
            }
        }
    }

    Rectangle {
        id: rateLimitDownFieldRect
        anchors.left: nodeBandwidthScreen.left
        anchors.top: rateLimitUpFieldRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight

        NodoInputField {
            id: rateLimitDownField
            anchors.left: rateLimitDownFieldRect.left
            anchors.top: rateLimitDownFieldRect.top
            width: inputFieldWidth
            height: NodoSystem.nodoItemHeight
            itemSize: labelSize
            itemText: qsTr("Download Speed")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{bottom: 0}
            onTextEditFinished: {
                if("" === rateLimitDownField.valueText)
                {
                    rateLimitDownField.valueText = defaultBW.toString()
                    rateLimitDownStr = "-1"
                }
                else
                {
                    rateLimitDownStr = rateLimitDownField.valueText
                }
                nodeBandwidthApplyButton.isActive = true
            }
        }

        Text {
            id: rateLimitDownUnit
            text: bwUnit
            anchors.left: rateLimitDownField.right
            anchors.top: rateLimitDownField.top
            anchors.leftMargin: 8

            height: NodoSystem.nodoItemHeight
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.inputFieldValueFontSize
            color: (inputFieldReadOnly === true) ? NodoSystem.buttonDisabledColor : nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        }

        Rectangle {
            id: rateLimitDownUnlimitedSwitchRect
            anchors.left: rateLimitDownUnit.right
            anchors.top: rateLimitDownFieldRect.top
            height: NodoSystem.nodoItemHeight
            anchors.leftMargin: 10

            NodoLabel{
                id: rateLimitDownUnlimitedSwitchText
                height: rateLimitDownUnlimitedSwitchRect.height
                anchors.left: rateLimitDownUnlimitedSwitchRect.left
                anchors.top: rateLimitDownUnlimitedSwitchRect.top
                text: qsTr("Unlimited")
            }

            NodoSwitch {
                id: rateLimitDownUnlimitedSwitch
                anchors.left: rateLimitDownUnlimitedSwitchText.right
                anchors.leftMargin: NodoSystem.padding
                height: rateLimitDownUnlimitedSwitchRect.height
                width: 2*rateLimitDownUnlimitedSwitchRect.height
                display: AbstractButton.IconOnly
                checkable: switchCheckable
                onCheckedChanged: {
                    if(checked)
                    {
                        rateLimitDownField.valueText = unlimitedbw
                        rateLimitDownField.readOnlyFlag = true
                        rateLimitDownStr = "-1"
                    }
                    else
                    {
                        rateLimitDownField.valueText = defaultBW
                        rateLimitDownField.readOnlyFlag = false
                        rateLimitDownStr = defaultBW
                    }

                    if(true === configReceived)
                    {
                        processConfig = false
                        nodeBandwidthApplyButton.isActive = true
                    }
                }
            }
        }
    }


    NodoButton {
        id: nodeBandwidthApplyButton
        anchors.left: nodeBandwidthScreen.left
        anchors.top: rateLimitDownFieldRect.bottom
        anchors.topMargin: 20
        text: systemMessages.messages[NodoMessages.Message.Apply]
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setNodeBandwidthParameters(incomingPeersLimitField.valueText, outgoingPeersLimitField.valueText, rateLimitUpStr, rateLimitDownStr)
        }
    }

    NodoPopup {
        id: nodeBandwithPopup
        onApplyClicked: {
            close()
        }
    }
}

