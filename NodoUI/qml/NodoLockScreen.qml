import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: lockScreen
    property int pinWidth: 32
    property int pinLeftRightPadding: pinWidth*1.5
    property int pinMiddlePaddings: pinWidth/2
    property color borderColor: "white"
    property color pinFilledColor: "orange"
    property color pinEmptyColor: "grey"
    property int buttonWidth: 116
    property int buttonHeight: 116

    property int leftAndRightSpaces: buttonWidth/3
    property int topAndBottomSpaces: buttonHeight/3
    property int horizontalSpaceBetweenButtons: buttonWidth/2
    property int verticalSpaceBetweenButtons: buttonHeight/2

    property int buttonPadHeight: (buttonHeight*4) + (topAndBottomSpaces*2) +  (verticalSpaceBetweenButtons*3)
    property int buttonPadWidth: (buttonWidth*3) + (leftAndRightSpaces*2) +  (horizontalSpaceBetweenButtons*2)

    property double buttonImageMargins: 0.25

    property int pinIndex: 0
    property string pinCode: ""

    property bool buttonsActive: true

    signal pinCodeCorrect()

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

            if(false === nodoControl.verifyPinCode(pinCode))
            {
                pinCode = ""
                buttonsActive = true
                pinIndex = 0;
                enterPINText.text = qsTr("Wrong PIN")
            }
            else
            {
                lockScreen.pinCodeCorrect()
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
        color: "blue"

        Text {
            id: enterPINText
            text: qsTr("Enter PIN")
            font.pixelSize: 32
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
        }
    }

    Rectangle {
        id: pinIndicatorFieldRect
        width: (pinLeftRightPadding*2) + (pinMiddlePaddings*5) + (pinWidth*6)
        height: pinWidth*2
        anchors.top: enterPINTextRect.bottom
        anchors.left: lockScreenMainRect.left
        anchors.topMargin: 8
        anchors.leftMargin: (lockScreenMainRect.width - width)/2
        color: "black"

        NodoCanvas {
            id: pinIndicatorField
            width: pinIndicatorFieldRect.width
            height: pinIndicatorFieldRect.height
            color: "green"

            Rectangle{
                id: pin0
                width: pinWidth
                height: pinWidth
                radius: pinWidth/2
                anchors.right: pinIndicatorField.right
                anchors.top: pinIndicatorField.top
                anchors.topMargin: pinWidth/2
                anchors.rightMargin: pinLeftRightPadding
                border.color: borderColor
                color: pinIndex > 0 ? pinFilledColor : pinEmptyColor
            }

            Rectangle{
                id: pin1
                width: pinWidth
                height: pinWidth
                radius: pinWidth/2
                anchors.right: pin0.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: pinWidth/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: borderColor
                color: pinIndex > 1 ? pinFilledColor : pinEmptyColor
            }

            Rectangle{
                id: pin2
                width: pinWidth
                height: pinWidth
                radius: pinWidth/2
                anchors.right: pin1.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: pinWidth/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: borderColor
                color: pinIndex > 2 ? pinFilledColor : pinEmptyColor
            }

            Rectangle{
                id: pin3
                width: pinWidth
                height: pinWidth
                radius: pinWidth/2
                anchors.right: pin2.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: pinWidth/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: borderColor
                color: pinIndex > 3 ? pinFilledColor : pinEmptyColor
            }

            Rectangle{
                id: pin4
                width: pinWidth
                height: pinWidth
                radius: pinWidth/2
                anchors.right: pin3.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: pinWidth/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: borderColor
                color: pinIndex > 4 ? pinFilledColor : pinEmptyColor
            }

            Rectangle{
                id: pin5
                width: pinWidth
                height: pinWidth
                radius: pinWidth/2
                anchors.right: pin4.left
                anchors.top: pinIndicatorField.top
                anchors.topMargin: pinWidth/2
                anchors.rightMargin: pinMiddlePaddings
                border.color: borderColor
                color: pinIndex > 5 ? pinFilledColor : pinEmptyColor
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

        color: "lightblue"

        NodoButton {
            id: button1
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: buttonPadRect.top
            anchors.left: buttonPadRect.left
            anchors.topMargin: topAndBottomSpaces
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "1"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(1)
            }
        }

        NodoButton {
            id: button2
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button1.top
            anchors.left: button1.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "2"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(2)
            }
        }

        NodoButton {
            id: button3
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button1.top
            anchors.left: button2.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "3"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(3)
            }
        }

        NodoButton {
            id: button4
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button1.bottom
            anchors.left: buttonPadRect.left
            anchors.topMargin: verticalSpaceBetweenButtons
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "4"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(4)
            }
        }

        NodoButton {
            id: button5
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button4.top
            anchors.left: button4.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "5"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(5)
            }
        }

        NodoButton {
            id: button6
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button4.top
            anchors.left: button5.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "6"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(6)
            }
        }

        NodoButton {
            id: button7
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button4.bottom
            anchors.left: buttonPadRect.left
            anchors.topMargin: verticalSpaceBetweenButtons
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "7"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(7)
            }
        }

        NodoButton {
            id: button8
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button7.top
            anchors.left: button7.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "8"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(8)
            }
        }

        NodoButton {
            id: button9
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button7.top
            anchors.left: button8.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "9"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(9)
            }
        }

        NodoButton {
            id: buttonDelete
            buttonWidth: lockScreen.buttonHeight
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: button7.bottom
            anchors.left: buttonPadRect.left
            anchors.topMargin: verticalSpaceBetweenButtons
            anchors.leftMargin: leftAndRightSpaces
            isActive: buttonsActive

            Image {

                anchors.fill: parent
                anchors.topMargin: lockScreen.buttonHeight*buttonImageMargins
                anchors.leftMargin: lockScreen.buttonHeight*buttonImageMargins
                anchors.bottomMargin: lockScreen.buttonHeight*buttonImageMargins
                anchors.rightMargin: lockScreen.buttonHeight*buttonImageMargins
                source: "qrc:/Images/DeleteButton.png"
            }

            onClicked: {
                setPINValue(-1)
            }
        }

        NodoButton {
            id: button0
            buttonWidth: lockScreen.buttonWidth
            fitMinimal: true
            height: lockScreen.buttonHeight
            anchors.top: buttonDelete.top
            anchors.left: buttonDelete.right
            anchors.leftMargin: horizontalSpaceBetweenButtons
            isActive: buttonsActive

            Text {
                anchors.fill: parent
                text: "0"
                font.pixelSize: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                font.family: NodoSystem.fontUrbanist.name
            }

            onClicked: {
                setPINValue(0)
            }
        }
    }
    }
}
