import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: lockScreen
    property int pinLeftRightPadding: NodoSystem.lockPinDiameter*1.5
    property int pinMiddlePaddings: NodoSystem.lockPinDiameter/2

    property int leftAndRightSpaces: NodoSystem.lockButtonWidth/3
    property int topAndBottomSpaces: NodoSystem.lockButtonHeight/3
    property int horizontalSpaceBetweenButtons: NodoSystem.lockButtonWidth/2
    property int verticalSpaceBetweenButtons: NodoSystem.lockButtonHeight/2

    property int buttonPadHeight: (NodoSystem.lockButtonHeight*4) + (topAndBottomSpaces*2) + (verticalSpaceBetweenButtons*3)
    property int buttonPadWidth: (NodoSystem.lockButtonWidth*3) + (leftAndRightSpaces*2) + (horizontalSpaceBetweenButtons*2)

    property int buttonImageMargins: NodoSystem.lockButtonHeight/4

    property int pinIndex: 0
    property string pinCode: ""

    property bool buttonsActive: true
    property int parentID


    signal deleteMe(int screenID)

    function setPINValue(buttonID)
    {
        if(buttonID === -1)
        {
            if(pinIndex > 0)
            {
                pinIndex--;
                pinCode = pinCode.slice(0, -1)
            }
        }
        else
        {
            if(pinIndex < 6)
            {
                pinIndex++;
                pinCode = pinCode + buttonID
            }
        }

        if(pinIndex === 6)
        {
            buttonsActive = false

            var retval

            if(0 === parentID)
            {
                retval = nodoControl.verifyLockPinCode(pinCode)
            }
            else if(1 === parentID)
            {
                retval = nodoControl.verifyAddressPinCode(pinCode)
            }

            if(false === retval)
            {
                pinCode = ""
                buttonsActive = true
                pinIndex = 0;
                enterPINText.text = qsTr("Incorrect PIN")
            }
            else
            {
                lockScreen.deleteMe(-1)
            }
        }
    }

    Component.onCompleted: {
        lockScreenMainRect.height = buttonPadHeight + buttonPadRect.y
    }

    Rectangle {
        id: lockScreenMainRect
        anchors.top: lockScreen.top
        anchors.left: lockScreen.left
        anchors.topMargin: (lockScreen.height - height)/2
        width: lockScreen.width
        color: "black"

    Rectangle {
        id: enterPINTextRect
        anchors.top: lockScreenMainRect.top
        anchors.left: lockScreenMainRect.left
        anchors.topMargin: 8
        anchors.leftMargin: (lockScreenMainRect.width - enterPINTextRect.width)/2
        width: enterPINText.paintedWidth
        height:enterPINText.paintedHeight
        color: "#000000"

        Text {
            id: enterPINText
            text: qsTr("Enter PIN")
            font.pixelSize: 32
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#FCFCFC"
            font.family: NodoSystem.fontInter.name
        }
    }

    Rectangle {
        id: pinIndicatorFieldRect
        width: (pinLeftRightPadding*2) + (pinMiddlePaddings*5) + (NodoSystem.lockPinDiameter*6)
        height: NodoSystem.lockPinDiameter*2
        anchors.top: enterPINTextRect.bottom
        anchors.left: lockScreenMainRect.left
        anchors.topMargin: 8
        anchors.leftMargin: (lockScreenMainRect.width - width)/2
        color: "#000000"

        NodoCanvas {
            id: pinIndicatorField
            width: pinIndicatorFieldRect.width
            height: pinIndicatorFieldRect.height
            color: "#000000"

            Rectangle{
                id: pin0
                width: NodoSystem.lockPinDiameter
                height: NodoSystem.lockPinDiameter
                radius: NodoSystem.lockPinDiameter/2
                anchors.right: pinIndicatorField.right
                anchors.top: pinIndicatorField.top
                anchors.topMargin: NodoSystem.lockPinDiameter/2
                anchors.rightMargin: pinLeftRightPadding
                border.color: NodoSystem.lockIndicatorBorderColor
                color: pinIndex > 5 ? NodoSystem.lockIndicatorFilledColor : NodoSystem.lockIndicatorEmptyColor
            }

            Rectangle{
                id: pin1
                width: NodoSystem.lockPinDiameter
                height: NodoSystem.lockPinDiameter
                radius: NodoSystem.lockPinDiameter/2
                anchors.right: pin0.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: NodoSystem.lockPinDiameter/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: NodoSystem.lockIndicatorBorderColor
                color: pinIndex > 4 ? NodoSystem.lockIndicatorFilledColor : NodoSystem.lockIndicatorEmptyColor
            }

            Rectangle{
                id: pin2
                width: NodoSystem.lockPinDiameter
                height: NodoSystem.lockPinDiameter
                radius: NodoSystem.lockPinDiameter/2
                anchors.right: pin1.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: NodoSystem.lockPinDiameter/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: NodoSystem.lockIndicatorBorderColor
                color: pinIndex > 3 ? NodoSystem.lockIndicatorFilledColor : NodoSystem.lockIndicatorEmptyColor
            }

            Rectangle{
                id: pin3
                width: NodoSystem.lockPinDiameter
                height: NodoSystem.lockPinDiameter
                radius: NodoSystem.lockPinDiameter/2
                anchors.right: pin2.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: NodoSystem.lockPinDiameter/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: NodoSystem.lockIndicatorBorderColor
                color: pinIndex > 2 ? NodoSystem.lockIndicatorFilledColor : NodoSystem.lockIndicatorEmptyColor
            }

            Rectangle{
                id: pin4
                width: NodoSystem.lockPinDiameter
                height: NodoSystem.lockPinDiameter
                radius: NodoSystem.lockPinDiameter/2
                anchors.right: pin3.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: NodoSystem.lockPinDiameter/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: NodoSystem.lockIndicatorBorderColor
                color: pinIndex > 1 ? NodoSystem.lockIndicatorFilledColor : NodoSystem.lockIndicatorEmptyColor
            }

            Rectangle{
                id: pin5
                width: NodoSystem.lockPinDiameter
                height: NodoSystem.lockPinDiameter
                radius: NodoSystem.lockPinDiameter/2
                anchors.right: pin4.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: NodoSystem.lockPinDiameter/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: NodoSystem.lockIndicatorBorderColor
                color: pinIndex > 0 ? NodoSystem.lockIndicatorFilledColor : NodoSystem.lockIndicatorEmptyColor
            }
        }
    }

    NodoCanvas {
        id: buttonPadRect
        anchors.top: pinIndicatorFieldRect.bottom
        anchors.left: lockScreenMainRect.left
        anchors.topMargin: 24
        anchors.leftMargin: (lockScreenMainRect.width - width)/2
        width: lockScreen.buttonPadWidth
        height: lockScreen.buttonPadHeight
        color: "#000000"

        NodoButton {
            id: button1
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: buttonPadRect.top
            anchors.left: buttonPadRect.left
            anchors.topMargin: topAndBottomSpaces
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "1"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(1)
            }
        }

        NodoButton {
            id: button2
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button1.top
            anchors.left: button1.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "2"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(2)
            }
        }

        NodoButton {
            id: button3
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button1.top
            anchors.left: button2.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "3"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(3)
            }
        }

        NodoButton {
            id: button4
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button1.bottom
            anchors.left: buttonPadRect.left
            anchors.topMargin: verticalSpaceBetweenButtons
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "4"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(4)
            }
        }

        NodoButton {
            id: button5
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button4.top
            anchors.left: button4.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "5"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(5)
            }
        }

        NodoButton {
            id: button6
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button4.top
            anchors.left: button5.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "6"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(6)
            }
        }

        NodoButton {
            id: button7
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button4.bottom
            anchors.left: buttonPadRect.left
            anchors.topMargin: verticalSpaceBetweenButtons
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "7"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(7)
            }
        }

        NodoButton {
            id: button8
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button7.top
            anchors.left: button7.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "8"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(8)
            }
        }

        NodoButton {
            id: button9
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button7.top
            anchors.left: button8.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "9"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(9)
            }
        }

        NodoButton {
            id: button0
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: buttonDelete.top
            anchors.left: button8.left
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Text {
                anchors.fill: parent
                text: "0"
                font.pixelSize: NodoSystem.lockButtonTextSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: NodoSystem.lockButtonTextColor
                font.family: NodoSystem.fontInter.name
            }

            onClicked: {
                setPINValue(0)
            }
        }

        NodoButton {
            id: buttonDelete
            buttonWidth: NodoSystem.lockButtonWidth
            fitMinimal: true
            height: NodoSystem.lockButtonHeight
            anchors.top: button9.bottom
            anchors.left: button0.right
            anchors.topMargin: verticalSpaceBetweenButtons
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive
            backgroundColor: NodoSystem.lockButtonColor

            Image {

                anchors.fill: parent
                anchors.topMargin: buttonImageMargins
                anchors.leftMargin: buttonImageMargins
                anchors.bottomMargin: buttonImageMargins
                anchors.rightMargin: buttonImageMargins
                source: "qrc:/Images/delete.png"
            }

            onClicked: {
                setPINValue(-1)
            }
        }
    }
    }
}
