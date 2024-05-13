import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
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

    signal textEdited()

    NodoCanvas {
        id: labelCanvas
        width: itemSize > 0 ? itemSize : labelRectRoundSize
        height: root.height
        color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff

        Text{
            id: namelabel
            width: namelabel.paintedWidth
            height: root.height
            text: qsTr(itemText)
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
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn  : NodoSystem.dataFieldTextColorNightModeOff
            echoMode: valueCanvas.defaultEchoMode
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

                nodoControl.setInputFieldText("")
            }
            onTextEdited:
            {
                valueText = valueLabel.text
                root.textEdited()
                nodoControl.setInputFieldText(valueText)
            }

            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoTextHandles | Qt.ImhNoAutoUppercase | textFlag
            readOnly: readOnlyFlag

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
