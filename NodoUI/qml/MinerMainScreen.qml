import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: minerMainScreen
    anchors.fill: parent
    property int labelSize: 0
    property int inputFieldWidth: 600
    property int defaultHeight: 64
    property bool pinFieldReadOnly: false
    property bool isLockPinEnabled: false

    Component.onCompleted: {
        minerMainStackView.push("NodoLockScreen.qml", {parentID: 1})
    }

    Connections{
        target: minerMainStackView.currentItem
        function onDeleteMe(screenID) {
            minerMainStackView.pop()
            minerMainStackView.push("MinerConfigScreen.qml")
        }
    }

    Connections{
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(errorCode === 9)
            {
                devicePinScreenStackView.pop()
                devicePinScreenStackView.push("NodoLockScreen.qml")
            }
        }
    }
    StackView {
        id: minerMainStackView
        anchors.fill: minerMainScreen

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 0
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 0
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 0
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 0
            }
        }
    }

    /*
    property int labelSize: 0
    property int inputFieldWidth: 600
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    Rectangle {
        id: minerSwitchRect
		anchors.top: minerMainScreen.top
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.subMenuButtonHeight + 40
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: minerSwitchRectSwitchText
            height: minerSwitchRect.height
            anchors.top: minerSwitchRect.top
            anchors.left: minerSwitchRect.left
            text: qsTr("Miner")
        }

        NodoSwitch {
            id: minerSwitch
            anchors.left: minerSwitchRectSwitchText.right
            anchors.top: minerSwitchRectSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*minerSwitchRectSwitchText.height
            height: minerSwitchRectSwitchText.height
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("mining", "enabled") === "TRUE" ? true : false
            onCheckedChanged:
            {
                nodoConfig.setMinerServiceStatus(minerSwitch.checked)
                if(checked)
                {
                    nodoControl.serviceManager("start", "xmrig");
                }
                else
                {
                    nodoControl.serviceManager("stop", "xmrig");
                }
            }
        }
    }

    Text {
        id: minerLabel
		anchors.top: minerSwitchRect.bottom
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 100
        height: 38
        text: qsTr("Mining is done with P2Pool and XMRig")
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    NodoInputField {
        id: minerDepositAddressField
        anchors.top: minerLabel.bottom
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 1840
        height: NodoSystem.infoFieldLabelHeight
        itemSize: 300
        itemText: qsTr("Deposit Address")
        valueText: nodoConfig.getStringValueFromKey("mining", "address")
        onTextEditFinished: {
        }
    }

    Text {
        id: warningLabel
		anchors.top: minerDepositAddressField.bottom
		anchors.left: minerMainScreen.left
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: 1800
        height: 100
        wrapMode: Text.WordWrap
        text: qsTr("Warning: Your deposit address must be a primary address beginning with 4!\r\nWarning: The deposit address will be publicly viewable. For privacy, use a different wallet!")
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }
    */
}


