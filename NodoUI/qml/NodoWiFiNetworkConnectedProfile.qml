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
    property int buttonSize: 300 
    property int defaultHeight: 100

    property string ssidName
    property string ssidIP
    property string ssidGateway
    property string ssidEncryption
    property int ssidSignalStrength
    property double ssidFrequency
    property string ssidConnectionPath
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

        function onConnectedSSIDParamsUpdated() {
            getParams()
        }
    }

    function getParams() {
        ssidName = networkManager.getConnectedSSIDName()
        ssidIP = networkManager.getConnectedSSIDIP()
        ssidGateway = networkManager.getConnectedSSIDGateway()
        ssidEncryption = networkManager.getConnectedSSIDEncryptionType()
        ssidSignalStrength = networkManager.getConnectedSSIDSignalStrength()
        ssidFrequency = networkManager.getConnectedSSIDFrequency()/1000
        ssidConnectionPath = networkManager.getConnectedSSIDConnectionPath()

        mainRect.state = ""
        connectButton.isActive = true
        connectButton.text = systemMessages.messages[NodoMessages.Message.Disconnect]
        connectButton.update()
        forgetButton.isActive = true
    }

    function onCalculateMaximumTextLabelLength() {
        if(ipField.labelRectRoundSize > labelSize)
            labelSize = ipField.labelRectRoundSize

        if(gatewayField.labelRectRoundSize > labelSize)
            labelSize = gatewayField.labelRectRoundSize

        if(sSIDField.labelRectRoundSize > labelSize)
            labelSize = sSIDField.labelRectRoundSize

        if(signalStrengthField.labelRectRoundSize > labelSize)
            labelSize = signalStrengthField.labelRectRoundSize

        if(securityField.labelRectRoundSize > labelSize)
            labelSize = securityField.labelRectRoundSize

        if(frequencyField.labelRectRoundSize > labelSize)
            labelSize = frequencyField.labelRectRoundSize
    }

    Label {
        id: ssidNameLabel
        anchors.top: mainRect.top
        anchors.left: mainRect.left
        anchors.topMargin: connectButton.y + (ssidNameLabel.paintedHeight)/2
        anchors.leftMargin: 20
        font.pixelSize: NodoSystem.infoFieldItemFontSize + 2
        font.family: NodoSystem.fontUrbanist.name
        height: 40
        text: mainRect.ssidName
        color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn  : NodoSystem.highlightedColorNightModeOff
    }

    NodoButton {
        id: connectButton
        anchors.top: mainRect.top
        anchors.right: mainRect.right
        anchors.topMargin: 14
        anchors.rightMargin: 14
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: systemMessages.messages[NodoMessages.Message.Disconnect]
        visible: true
        isActive: true
        fitMinimal: true
        onClicked: {
            connectButton.isActive = false
            connectButton.text = systemMessages.messages[NodoMessages.Message.Disconnecting] //qsTr("Disconnecting")
            connectButton.update()
            networkManager.disconnectFromWiFi()
            mainRect.state = "" //Added later
        }
    }

    NodoButton {
        id: forgetButton
        anchors.top: mainRect.top
        anchors.right: connectButton.left
        anchors.topMargin: 14
        anchors.rightMargin: 20
        width: mainRect.buttonSize
        height: networkDelegateItemHeight
        font.pixelSize: NodoSystem.infoFieldItemFontSize
        text: systemMessages.messages[NodoMessages.Message.Forget]
        visible: true
        isActive: true
        fitMinimal: true
        onClicked: {
            forgetButton.isActive = false
            networkManager.forgetWirelessNetwork(mainRect.ssidConnectionPath)
        }
    }

    Rectangle {
        id: ssidSignalStrengthRect
        anchors.top: forgetButton.top
        anchors.right: forgetButton.left
        anchors.rightMargin: 20
        anchors.topMargin: (connectButton.height - height)/2
        width: 84
        height: 84
        color: "transparent"

        Image {
            id: ssidSignalStrengthImage
            anchors.fill: parent
            mipmap: true
            source:
            {
                if(ssidSignalStrength < 20)
                {
                    "qrc:/Images/WifiSignal_0.png"
                }
                else if(ssidSignalStrength < 40)
                {
                    "qrc:/Images/WifiSignal_1.png"
                }
                else if(ssidSignalStrength < 60)
                {
                    "qrc:/Images/WifiSignal_2.png"
                }
                else if(ssidSignalStrength < 80)
                {
                    "qrc:/Images/WifiSignal_3.png"
                }
                else
                {
                    "qrc:/Images/WifiSignal_4.png"
                }
            }
        }

        Image {
            id: ssidEncryptionImage
            anchors.top: ssidSignalStrengthRect.top
            anchors.right: ssidSignalStrengthImage.left
            anchors.rightMargin: 20
            //anchors.topMargin: 10
            width: 60
            height: 60
            visible:
            {
                var ency = ssidEncryption
                if((ency === "WPA2") || (ency === "WPA3"))
                {
                    true
                }
                else
                {
                    false
                }
            }
            source:
            {
                "qrc:/Images/wifi_secure.png"
            }
        }
    }

    Rectangle {
        id: showDetailsRect
        anchors.top: ssidSignalStrengthRect.bottom
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        anchors.topMargin: 10
        height: frequencyField.y + frequencyField.height
        visible:  mainRect.state === "showDetails" ? true : false
        color: "transparent"

        NodoInfoField {
            id: ipField
            anchors.left: showDetailsRect.left
            anchors.top: showDetailsRect.top
            anchors.topMargin: 10//mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.IPAddress] //qsTr("Address")
            valueText: mainRect.ssidIP
        }

        NodoInfoField{
            id: gatewayField
            anchors.left: showDetailsRect.left
            anchors.top: ipField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height:  networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.Router] //qsTr("Router")
            valueText: mainRect.ssidGateway
        }

        NodoInfoField{
            id: signalStrengthField
            anchors.left: showDetailsRect.left
            anchors.top: gatewayField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.SignalStrength] //qsTr("Signal Strength")
            valueText: mainRect.ssidSignalStrength + "%"
        }

        NodoInfoField{
            id: securityField
            anchors.left: showDetailsRect.left
            anchors.top: signalStrengthField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.SecurityType] //qsTr("Security Type")
            valueText: mainRect.ssidEncryption
        }

        NodoInfoField{
            id: frequencyField
            anchors.left: showDetailsRect.left
            anchors.top: securityField.bottom
            anchors.topMargin: mainRect.spacing
            width: showDetailsRect.width
            itemSize: labelSize
            height: networkDelegateItemHeight
            itemText: systemMessages.messages[NodoMessages.Message.Frequency] //qsTr("Frequency")
            valueText: {
                var freq = mainRect.ssidFrequency
                freq.toFixed(1) + " GHz"
            }
        }
    }

    MouseArea {
        anchors.fill: parent;
        z: -1
        onClicked: {
            if((mainRect.state === ""))
            {
                mainRect.state = "showDetails"
                networkManager.stopWifiScan()
            }
            else
            {
                mainRect.state = ""
                networkManager.startWifiScan()
            }
        }
    }

    states: [
        State {
            name: "showDetails";
            PropertyChanges { target: mainRect; height: defaultHeight + showDetailsRect.height }
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
