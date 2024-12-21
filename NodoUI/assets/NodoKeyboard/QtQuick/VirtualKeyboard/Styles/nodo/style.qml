// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Styles
import NodoSystem 1.1
import NodoCanvas 1.0

KeyboardStyle {
    id: currentStyle
    readonly property string fontFamily: NodoSystem.fontInter.name
    readonly property real keyBackgroundMargin: Math.round(8 * scaleHint)
    readonly property real keyContentMargin: Math.round(40 * scaleHint)
    readonly property real keyIconScale: scaleHint * 0.8
    readonly property string resourcePrefix: ""

    property color keyboardBackgroundColor: NodoSystem.keyboardBackgroundColor
    property color normalKeyBackgroundColor: NodoSystem.keyboardButtonUnpressed
    property color highlightedKeyBackgroundColor: NodoSystem.keyboardButtonUnpressed
    property color capsLockKeyAccentColor: NodoSystem.capsLockOnColor
    property color keyTextColor: NodoSystem.textColorOnUnpressedButton
    property color keySmallTextColor: NodoSystem.textColorOnUnpressedButton

    keyboardDesignWidth: 2560
    keyboardDesignHeight: 900
    keyboardRelativeLeftMargin: 6 / keyboardDesignWidth
    keyboardRelativeRightMargin: 6 / keyboardDesignWidth
    keyboardRelativeTopMargin: 6 / keyboardDesignHeight
    keyboardRelativeBottomMargin: 6 / keyboardDesignHeight

    keyboardBackground: NodoCanvas {
        color: keyboardBackgroundColor
    }

    keyPanel: KeyPanel {
        id: keyPanel
        NodoCanvas {
            id: keyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: keyPanel
            anchors.margins: keyBackgroundMargin
            Text {
                id: keyText
                text: control.displayText
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: control.displayText.length > 0 ? Text.AlignVCenter : Text.AlignBottom
                anchors.fill: parent
                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 70 * scaleHint
                    capitalization: control.uppercased ? Font.AllUppercase : Font.MixedCase
                }
            }
        }
        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: keyBackground
					color: NodoSystem.keyboardButtonPressed
//                    opacity: 0.75
                }
                PropertyChanges {
                    target: keyText
//                    opacity: 0.5
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: keyBackground
//                    opacity: 0.75
                }
                PropertyChanges {
                    target: keyText
//                    opacity: 0.05
                }
            }
        ]
    }

    backspaceKeyPanel: KeyPanel {
        id: backspaceKeyPanel
        NodoCanvas {
            id: backspaceKeyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: backspaceKeyPanel
            anchors.margins: keyBackgroundMargin
            Image {
                id: backspaceKeyIcon
                anchors.centerIn: parent
                sourceSize.height: 88 * keyIconScale
                smooth: false
                source: resourcePrefix + "images/backspace-fcfcfc.svg"
            }
        }
        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: backspaceKeyBackground
                    color: NodoSystem.keyboardButtonPressed
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: backspaceKeyBackground
                    color: NodoSystem.keyboardButtonUnpressed
                }
            }
        ]
    }

    enterKeyPanel: KeyPanel {
        id: enterKeyPanel
        NodoCanvas {
            id: enterKeyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: enterKeyPanel
            anchors.margins: keyBackgroundMargin
            Image {
                id: enterKeyIcon
                visible: enterKeyText.text.length === 0
                anchors.centerIn: parent
                readonly property size enterKeyIconSize: {
                    return Qt.size(211, 80)
                }
                sourceSize.height: enterKeyIconSize.height * 0.4
                smooth: false
                source: {
                    return resourcePrefix + "images/enter-fcfcfc.svg"
                }
            }
            Text {
                id: enterKeyText
                visible: text.length !== 0
                text: control.actionId !== EnterKeyAction.None ? control.displayText : ""
                clip: true
                fontSizeMode: Text.HorizontalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: keyTextColor
                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 70 * scaleHint
                    capitalization: Font.AllUppercase
                }
                anchors.fill: parent
                anchors.margins: Math.round(42 * scaleHint)
            }
        }
        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: enterKeyBackground
                    color: NodoSystem.keyboardButtonPressed
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: enterKeyBackground
                    color: NodoSystem.keyboardButtonUnpressed
                }
            }
        ]
    }

    hideKeyPanel: KeyPanel {
        id: hideKeyPanel
        NodoCanvas {
            id: hideKeyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: hideKeyPanel
            anchors.margins: keyBackgroundMargin
            Image {
                id: hideKeyIcon
                anchors.centerIn: parent
                sourceSize.height: 127 * keyIconScale
                smooth: false
                source: resourcePrefix + "images/hidekeyboard-fcfcfc.svg"
            }
        }

        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: hideKeyBackground
                    color: NodoSystem.keyboardButtonPressed
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: hideKeyBackground
                    color: NodoSystem.keyboardButtonUnpressed
                }

            }
        ]
    }

    shiftKeyPanel: KeyPanel {
        id: shiftKeyPanel
        NodoCanvas {
            id: shiftKeyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: shiftKeyPanel
            anchors.margins: keyBackgroundMargin
            Image {
                id: shiftKeyIcon
                anchors.centerIn: parent
                sourceSize.height: 134 * keyIconScale
                smooth: false
                source: resourcePrefix + "images/shift-fcfcfc.svg"
            }
            states: [
                State {
                    name: "capsLockActive"
                    when: InputContext.capsLockActive
                    PropertyChanges {
                        target: shiftKeyBackground
                        color: capsLockKeyAccentColor
                    }
                },
                State {
                    name: "shiftActive"
                    when: InputContext.shiftActive
                    PropertyChanges {
                        target: shiftKeyIcon
                        source: resourcePrefix + (nodoControl.appTheme ? "images/shift-f50000.svg" : "images/shift-fa5501.svg")
                    }
                }
            ]
        }
        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: shiftKeyBackground
//                    opacity: 0.80
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: shiftKeyBackground
//                    opacity: 0.8
                }
            }
        ]
    }

    spaceKeyPanel: KeyPanel {
        id: spaceKeyPanel
        NodoCanvas {
            id: spaceKeyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: spaceKeyPanel
            anchors.margins: keyBackgroundMargin
            Text {
                id: spaceKeyText
                text: Qt.locale(InputContext.locale).nativeLanguageName
                color: keyTextColor
                // opacity: inputLocaleIndicatorOpacity
                //Behavior on opacity { PropertyAnimation { duration: 250 } }
                anchors.centerIn: parent
                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 70 * scaleHint
                }
            }
        }
        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
                    target: spaceKeyBackground
					color: NodoSystem.keyboardButtonPressed
//                    opacity: 0.80
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: spaceKeyBackground
//                    opacity: 0.8
                }
            }
        ]
    }

    symbolKeyPanel: KeyPanel {
        id: symbolKeyPanel
        NodoCanvas {
            id: symbolKeyBackground
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: symbolKeyPanel
            anchors.margins: keyBackgroundMargin
            Text {
                id: symbolKeyText
                text: control.displayText
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                anchors.margins: keyContentMargin
                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 70 * scaleHint
                    capitalization: Font.AllUppercase
                }
            }
        }
        states: [
            State {
                name: "pressed"
                when: control.pressed
                PropertyChanges {
					target: symbolKeyBackground
					color: NodoSystem.keyboardButtonPressed
//              	opacity: 0.80
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
					target: symbolKeyBackground
//              	opacity: 0.8
                }
            }
        ]
    }

    traceInputKeyPanelDelegate: TraceInputKeyPanel {
        id: traceInputKeyPanel
        traceMargins: keyBackgroundMargin
        NodoCanvas {
            id: traceInputKeyPanelBackground
            color: normalKeyBackgroundColor
            anchors.fill: traceInputKeyPanel
            anchors.margins: keyBackgroundMargin
            Text {
                id: hwrInputModeIndicator
                visible: control.patternRecognitionMode === InputEngine.PatternRecognitionMode.Handwriting
                text: {
                    switch (InputContext.inputEngine.inputMode) {
                    case InputEngine.InputMode.Numeric:
                        if (["ar", "fa"].indexOf(InputContext.locale.substring(0, 2)) !== -1)
                            return "\u0660\u0661\u0662"
                        // Fallthrough
                    case InputEngine.InputMode.Dialable:
                        return "123"
                    case InputEngine.InputMode.Greek:
                        return "ΑΒΓ"
                    case InputEngine.InputMode.Cyrillic:
                        return "АБВ"
                    case InputEngine.InputMode.Arabic:
                        if (InputContext.locale.substring(0, 2) === "fa")
                            return "\u0627\u200C\u0628\u200C\u067E"
                        return "\u0623\u200C\u0628\u200C\u062C"
                    case InputEngine.InputMode.Hebrew:
                        return "\u05D0\u05D1\u05D2"
                    case InputEngine.InputMode.ChineseHandwriting:
                        return "中文"
                    case InputEngine.InputMode.JapaneseHandwriting:
                        return "日本語"
                    case InputEngine.InputMode.KoreanHandwriting:
                        return "한국어"
                    case InputEngine.InputMode.Thai:
                        return "กขค"
                    default:
                        return "Abc"
                    }
                }
                color: keyTextColor
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: keyContentMargin
                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 70 * scaleHint
                    capitalization: {
                        if (InputContext.capsLockActive)
                            return Font.AllUppercase
                        if (InputContext.shiftActive)
                            return Font.MixedCase
                        return Font.AllLowercase
                    }
                }
            }
        }
        Canvas {
            id: traceInputKeyGuideLines
            anchors.fill: traceInputKeyPanelBackground
            opacity: 0.1
            onPaint: {
                var ctx = getContext("2d")
                ctx.lineWidth = 1
                ctx.strokeStyle = Qt.rgba(0xFF, 0xFF, 0xFF)
                ctx.clearRect(0, 0, width, height)
                var i
                var margin = Math.round(30 * scaleHint)
                if (control.horizontalRulers) {
                    for (i = 0; i < control.horizontalRulers.length; i++) {
                        ctx.beginPath()
                        var y = Math.round(control.horizontalRulers[i])
                        var rightMargin = Math.round(width - margin)
                        if (i + 1 === control.horizontalRulers.length) {
                            ctx.moveTo(margin, y)
                            ctx.lineTo(rightMargin, y)
                        } else {
                            var dashLen = Math.round(20 * scaleHint)
                            for (var dash = margin, dashCount = 0;
                                 dash < rightMargin; dash += dashLen, dashCount++) {
                                if ((dashCount & 1) === 0) {
                                    ctx.moveTo(dash, y)
                                    ctx.lineTo(Math.min(dash + dashLen, rightMargin), y)
                                }
                            }
                        }
                        ctx.stroke()
                    }
                }
                if (control.verticalRulers) {
                    for (i = 0; i < control.verticalRulers.length; i++) {
                        ctx.beginPath()
                        ctx.moveTo(control.verticalRulers[i], margin)
                        ctx.lineTo(control.verticalRulers[i], Math.round(height - margin))
                        ctx.stroke()
                    }
                }
            }
            Connections {
                target: control
                function onHorizontalRulersChanged() { traceInputKeyGuideLines.requestPaint() }
                function onVerticalRulersChanged() { traceInputKeyGuideLines.requestPaint() }
            }
        }
    }

    traceCanvasDelegate: TraceCanvas {
        id: traceCanvas
        onAvailableChanged: {
            if (!available)
                return
            var ctx = getContext("2d")
            if (parent.canvasType === "fullscreen") {
                ctx.lineWidth = 10
                ctx.strokeStyle = Qt.rgba(0, 0, 0)
            } else {
                ctx.lineWidth = 10 * scaleHint
                ctx.strokeStyle = Qt.rgba(0xFF, 0xFF, 0xFF)
            }
            ctx.lineCap = "round"
            ctx.fillStyle = ctx.strokeStyle
        }
        autoDestroyDelay: 800
        onTraceChanged: if (trace === null) opacity = 0
        Behavior on opacity { PropertyAnimation { easing.type: Easing.OutCubic; duration: 50 } }
    }

    fullScreenInputContainerBackground: Rectangle {
        color: "#FFF"
    }

    fullScreenInputBackground: Rectangle {
        color: "#FFF"
    }

    fullScreenInputMargins: Math.round(15 * scaleHint)

    fullScreenInputPadding: Math.round(30 * scaleHint)

    fullScreenInputCursor: NodoCanvas {
        width: 1
        color: "#000"
        visible: parent.blinkStatus
    }

    fullScreenInputFont.pixelSize: 70 * scaleHint
}

