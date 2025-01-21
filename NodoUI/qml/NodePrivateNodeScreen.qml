import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodePrivateNodeScreen
    property int labelSize: 0
    property int inputFieldWidth: 900
    property bool isRPCEnabled
    property int rpcPort

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
        nodePrivateNodeScreen.isRPCEnabled = nodoControl.getrpcEnabledStatus()
        nodePrivateNodeScreen.rpcPort = nodoControl.getrpcPort()
        //privateNodePortField.readOnlyFlag = !nodePrivateNodeScreen.isRPCEnabled
    }

    function onCalculateMaximumTextLabelLength() {
        if(privateNodePortField.labelRectRoundSize > labelSize)
        labelSize = privateNodePortField.labelRectRoundSize

        if(privateNodeUserNameField.labelRectRoundSize > labelSize)
        labelSize = privateNodeUserNameField.labelRectRoundSize

        if(privateNodePasswordField.labelRectRoundSize > labelSize)
        labelSize = privateNodePasswordField.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            nodePrivateNodeScreen.isRPCEnabled = nodoControl.getrpcEnabledStatus()
            nodePrivateNodeScreen.rpcPort = nodoControl.getrpcPort()
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(0 !== errorCode)
            {
                nodePrivateNodePopup.popupMessageText = systemMessages.backendMessages[errorCode]
                // nodePrivateNodePopup.popupMessageText = nodoControl.getErrorMessage()
                nodePrivateNodePopup.commandID = -1;
                nodePrivateNodePopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                nodePrivateNodePopup.open();
            }
        }

        function onComponentEnabledStatusChanged() {
            var enabled = nodoControl.isComponentEnabled();
            privateNodeSwitch.enabled = enabled
            //privateNodePortField.readOnlyFlag = enabled === true ? !privateNodeSwitch.checked : true
        }
    }

    Rectangle {
        id: privateNodeSwitchRect
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: nodePrivateNodeScreen.top
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: privateNodeSwitchText
            height: privateNodeSwitchRect.height
            anchors.top: privateNodeSwitchRect.top
            anchors.left: privateNodeSwitchRect.left
            text: qsTr("Private Node")
        }

        NodoSwitch {
            id: privateNodeSwitch
            anchors.left: privateNodeSwitchText.right
            anchors.top: privateNodeSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*privateNodeSwitchRect.height
            height: privateNodeSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodePrivateNodeScreen.isRPCEnabled
            onCheckedChanged: privateNodeApplyButton.enabled = true
        }
    }

    Text {
        id: privateNodeSwitchRectDescription
        height: NodoSystem.nodoItemHeight
        width: parent.width - privateNodeSwitchRect.width
        anchors.left: privateNodeSwitchRect.right
        anchors.leftMargin: 25
        anchors.top: nodePrivateNodeScreen.top
        //anchors.topMargin: NodoSystem.nodoTopMargin
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("Require wallets to enter the username and password to use this node")
    }

    NodoInfoField {
        id: privateNodePortField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        height: NodoSystem.nodoItemHeight
        width: labelSize + privateNodeSwitch.width//labelSize + 150//inputFieldWidth
        //itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Port]
        valueText: nodePrivateNodeScreen.rpcPort
        /*textFlag: Qt.ImhDigitsOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if("" === privateNodePortField.valueText)
            {
                privateNodePortField.valueText = nodePrivateNodeScreen.rpcPort.toString()
            }

            if(privateNodePortField.valueText !== nodePrivateNodeScreen.rpcPort.toString())
            {
                hiddenInputField.focus = true
                nodoControl.setrpcPort(privateNodePortField.valueText)
            }
        }*/
    }

    NodoInputField {
        id: privateNodeUserNameField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodePortField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Username")
        valueText: nodoControl.getrpcUser();
    }

    NodoInputField {
        id: privateNodePasswordField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeUserNameField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: inputFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Password")
        valueText: nodoControl.getrpcPassword();
        passwordInput: true
    }

    NodoButton {
        id: privateNodeApplyButton
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodePasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: systemMessages.messages[NodoMessages.Message.Apply]
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        enabled: false
        onPressed:
        {
            if (privateNodeSwitch.checked)
            {
                nodoControl.setrpcUser(privateNodeUserNameField.valueText);
                if (privateNodeUserNameField.valueText != "")
                    nodoControl.setrpcPassword(privateNodePasswordField.valueText);
            }
            nodePrivateNodeScreen.isRPCEnabled = privateNodeSwitch.checked;
            nodoControl.setrpcEnabledStatus(privateNodeSwitch.checked);
            privateNodeApplyButton.enabled = false;
        }
    }

    Text {
        id: privateNodeApplyButtonText
        height: NodoSystem.nodoItemHeight
        width: parent.width - privateNodeApplyButton.width
        anchors.left: privateNodeApplyButton.right
        anchors.leftMargin: 25
        anchors.top: privateNodePasswordField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        verticalAlignment: Text.AlignVCenter
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("Monero Daemon will restart to apply changes")
    } 

/*
    When enter pressed, privateNodePortField doesn't lose its focus and keyboard is displayed again.
    The only purpose of this input field is to take over focus from the privateNodePortField
*/
    NodoInputField {
        id: hiddenInputField
        anchors.left: nodePrivateNodeScreen.left
        anchors.top: privateNodeApplyButton.bottom
        visible: false
        readOnlyFlag: true
    }

    NodoPopup {
        id: nodePrivateNodePopup
        onApplyClicked: {
            close()
        }
    }
}

