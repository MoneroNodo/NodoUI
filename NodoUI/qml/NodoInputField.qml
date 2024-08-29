import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: root
    x: 0
    y: 0
    property string itemText: ""
    property string valueText: ""
    property int itemFontSize: NodoSystem.inputFieldItemFontSize
    property int valueFontSize: NodoSystem.inputFieldValueFontSize
    property int textFlag: Qt.ImhNoAutoUppercase
    property bool readOnlyFlag: false
    property int textLeftPadding: NodoSystem.textPadding
    property int textRightPadding: NodoSystem.textPadding

    property int labelWidth: namelabel.paintedWidth + textLeftPadding + textRightPadding
    property int itemSize: 0
    property int labelRectRoundSize: labelWidth > NodoSystem.nodoItemWidth ? labelWidth : NodoSystem.nodoItemWidth
    property bool passwordInput: false
    property alias inputMask: valueLabel.inputMask
    property alias validator: valueLabel.validator

    signal textEditFinished()

    NodoCanvas {
        id: labelCanvas
        width: itemSize > 0 ? itemSize : labelRectRoundSize
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff

        Text{
            id: namelabel
            width: namelabel.paintedWidth
            height: root.height
            text: itemText
            leftPadding: textLeftPadding
            rightPadding: textRightPadding
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: itemFontSize
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
        }
    }

    NodoCanvas {
        id: valueCanvas
        anchors.left: labelCanvas.right
        anchors.leftMargin: NodoSystem.padding
        width: root.width - labelCanvas.width
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
        property int defaultEchoMode: passwordInput == true ? TextInput.Password: TextInput.Normal

        TextInput {
            id: valueLabel
            anchors.left: valueCanvas.left
            anchors.leftMargin: textLeftPadding
            anchors.right: passwordButton.visible ? passwordButton.left : valueCanvas.right
            y:0
            height: root.height
            text: valueText
            rightPadding: textRightPadding
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: valueFontSize
            clip: true
            color: (readOnlyFlag === true) ? NodoSystem.buttonDisabledColor : nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
            echoMode: valueCanvas.defaultEchoMode
            activeFocusOnPress: true
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoTextHandles | Qt.ImhNoAutoUppercase | textFlag
            readOnly: readOnlyFlag
            selectionColor: "transparent"

            onFocusChanged:{
                if(focus)
                {
                    selectAll()
                    nodoControl.setEchoMode(valueLabel.echoMode)
                    nodoControl.setPasswordMode(passwordInput)
                }
                else {
                    echoMode: valueCanvas.defaultEchoMode
                }

                nodoControl.setInputFieldText(valueText)
            }
            onTextEdited:
            {
                valueText = valueLabel.text
                nodoControl.setInputFieldText(valueText)
            }

            Connections {
                target: nodoControl
                function onEchoModeChanged()
                {
                    if((valueLabel.focus) && (passwordInput === true))
                    {
                        valueLabel.echoMode = nodoControl.getEchoMode()
                        passwordButton.hidePassword = nodoControl.getEchoMode()
                    }
                }
            }

            Keys.onReturnPressed: {
                Qt.inputMethod.hide();
                root.textEditFinished()
            }

            TapHandler {
                onTapped: {
                    nodoControl.setInputFieldText(valueText)
                }
            }
        }

        NodoPasswordButton {
            id: passwordButton
            visible: passwordInput
            anchors.right: valueCanvas.right
            anchors.top: valueCanvas.top
            anchors.topMargin: 15
            anchors.rightMargin: 11
            width: valueCanvas.height - 30
            height: valueCanvas.height - 30

            onHideStatusChanged: {
                if(passwordButton.hidePassword === true)
                {
                    valueLabel.echoMode = TextInput.Password
                }
                else
                {
                    valueLabel.echoMode = TextInput.Normal
                }
                valueLabel.focus = true
                nodoControl.setEchoMode(valueLabel.echoMode)
            }
        }
    }
}
