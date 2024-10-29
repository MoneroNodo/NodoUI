import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: nodeBlockExplorerScreen
    property bool switchCheckable: true

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            nodeBlockExplorerPopup.popupMessageText = systemMessages.backendMessages[errorCode]
            // nodeBlockExplorerPopup.popupMessageText = nodoControl.getErrorMessage()
            nodeBlockExplorerPopup.commandID = -1;
            nodeBlockExplorerPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            nodeBlockExplorerPopup.open();
        }

        function onComponentEnabledStatusChanged() {
            switchCheckable = nodoControl.isComponentEnabled()
        }
    }

    Rectangle {
        id: nodeBlockExplorerSwitchRect
        anchors.left: nodeBlockExplorerScreen.left
        anchors.top: nodeBlockExplorerScreen.top
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: nodeBlockExplorerSwitchText
            height: nodeBlockExplorerSwitchRect.height
            anchors.top: nodeBlockExplorerSwitchRect.top
            anchors.left: nodeBlockExplorerSwitchRect.left
            text: qsTr("Block Explorer")
        }

        NodoSwitch {
            id: nodeBlockExplorerSwitch
            anchors.left: nodeBlockExplorerSwitchText.right
            anchors.top: nodeBlockExplorerSwitchText.top
            anchors.leftMargin: NodoSystem.padding
            width: 2*nodeBlockExplorerSwitchRect.height
            height: nodeBlockExplorerSwitchRect.height
            display: AbstractButton.IconOnly
            checkable: switchCheckable
            checked: nodoControl.getServiceStatus("block-explorer") === "active" ? true : false
            onCheckedChanged: {
                nodoControl.enableBlockExplorerStatus(checked)
                switchCheckable = false
            }
        }

        NodoLabel{
            id: nodeBlockExplorerSwitchDescription
            height: nodeBlockExplorerSwitchRect.height
            anchors.left: nodeBlockExplorerSwitch.right
            anchors.top: nodeBlockExplorerSwitchText.top
            anchors.leftMargin: 8
            text: qsTr("Enables the Onion Monero Block Explorer service, accessible from WebUI")
        }
    }

    NodoPopup {
        id: nodeBlockExplorerPopup
        onApplyClicked: {
            close()
        }
    }
}

