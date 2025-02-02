import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect

    property int networkDelegateItemHeight: NodoSystem.nodoItemHeight
    property int labelSize: 200
    property int buttonSize: 320
    property int defaultHeight: NodoSystem.nodoItemHeight + (NodoSystem.cardTopMargin*2)

    property string profileName
    property string profileIP
    property string profileGateway
    property string deviceSpeed
    property string connectionPath

    property int spacing: 1

    height: defaultHeight
    color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn  : NodoSystem.dataFieldTitleBGColorNightModeOff

    Component.onCompleted:
    {
        getParams()
        onCalculateMaximumTextLabelLength()
    }

    Connections {
        target: networkManager

        function onConnectedEthernetParamsUpdated() {
            getParams()
        }
    }

    function getParams() {
        profileName = networkManager.getConnectedEthernetProfileName()
        profileIP = networkManager.getConnectedEthernetIP()
        profileGateway = networkManager.getConnectedEthernetGateway()
        deviceSpeed = networkManager.ethernetConnectionSpeed()
        connectionPath = networkManager.getConnectedEthernetConnectionPath()

        mainRect.state = ""
        connectButton.isActive = true
        connectButton.text = systemMessages.messages[NodoMessages.Message.Disconnect]
        connectButton.update()

        //forgetButton.isActive = true
    }

    function onCalculateMaximumTextLabelLength() {
        if(ipField.labelRectRoundSize > labelSize)
            labelSize = ipField.labelRectRoundSize

        if(gatewayField.labelRectRoundSize > labelSize)
            labelSize = gatewayField.labelRectRoundSize

        if(deviceSpeedField.labelRectRoundSize > labelSize)
            labelSize = deviceSpeedField.labelRectRoundSize

    }

    Label {
        id: profileNameLabel
        anchors.top: mainRect.top
        anchors.left: mainRect.left
        anchors.topMargin: (profileNameLabel.paintedHeight)/2
        anchors.leftMargin: NodoSystem.cardLeftMargin*2
        font.pixelSize: NodoSystem.buttonTextFontSize
        font.family: NodoSystem.fontInter.name
        height: 40
        text: mainRect.profileName
        color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn  : NodoSystem.highlightedColorNightModeOff
    }

    NodoButton {
        id: connectButton
        anchors.top: mainRect.top
        anchors.right: mainRect.right
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.rightMargin: NodoSystem.cardTopMargin
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: systemMessages.messages[NodoMessages.Message.Disconnect]
        visible: true
        isActive: true
        fitMinimal: true
        
        onClicked: {
            connectButton.isActive = false
            connectButton.text = systemMessages.messages[NodoMessages.Message.Disconnecting]
            connectButton.update()
            networkManager.disconnectFromEthernet()
            mainRect.state = "" //Added later
        }
    }

/*    NodoButton {
        id: forgetButton
        anchors.top: mainRect.top
        anchors.right: connectButton.left
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.rightMargin: 25
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        text: systemMessages.messages[NodoMessages.Message.Forget]
        visible: true
        isActive: true
        fitMinimal: true
        onClicked: {
            forgetButton.isActive = false
            forgetButton.update()
            networkManager.forgetWiredNetwork(mainRect.connectionPath)
            mainRect.state = "" //Added later
        }
    }*/

    Rectangle {
        id: showDetailsRect
        anchors.top: connectButton.bottom
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.leftMargin: NodoSystem.cardTopMargin
        anchors.rightMargin: NodoSystem.cardTopMargin
        anchors.topMargin: 5
        height: deviceSpeedField.y + deviceSpeedField.height
        visible:  mainRect.state === "showDetails" ? true : false
        color: "transparent"

        NodoInfoField {
            id: ipField
            anchors.left: showDetailsRect.left
            anchors.top: showDetailsRect.top
            anchors.topMargin: NodoSystem.cardTopMargin
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.IPAddress]
            valueText: mainRect.profileIP
        }

        NodoInfoField{
            id: gatewayField
            anchors.left: showDetailsRect.left
            anchors.top: ipField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height:  networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.Router]
            valueText: mainRect.profileGateway
        }

        NodoInfoField{
            id: deviceSpeedField
            anchors.left: showDetailsRect.left
            anchors.top: gatewayField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height:  networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.DeviceSpeed]
            valueText: mainRect.deviceSpeed
        }
    }

    MouseArea {
        anchors.fill: parent;
        z: -1
        onClicked: {
            if((mainRect.state === ""))
            {
                mainRect.state = "showDetails"
                networkManager.stopEthScan()
                networkmanager.setEthernetDetailsOpened(true);
            }
            else
            {
                mainRect.state = ""
                networkManager.startEthScan()
                networkmanager.setEthernetDetailsOpened(false);
            }
        }
    }

    states: [
        State {
            name: "showDetails";
            PropertyChanges { target: mainRect; height: defaultHeight + showDetailsRect.height + 5 }
        },
        State {
            name: ""
            PropertyChanges { target: mainRect; height: defaultHeight }
        }
    ]

    transitions: Transition {
        NumberAnimation { target: mainRect; properties: "height"; easing.type: Easing.OutExpo; duration: 150 }
    }
}
