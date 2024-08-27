// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Components

KeyboardLayoutLoader {
    property bool secondPage
    onVisibleChanged: if (!visible) secondPage = false
    sourceComponent: secondPage ? page2 : page1
    Component {
        id: page1
        KeyboardLayout {
            keyWeight: 160
            readonly property real normalKeyWidth: normalKey.width
            readonly property real functionKeyWidth: mapFromItem(normalKey, normalKey.width / 2, 0).x
            KeyboardRow {
                Key {
                    key: Qt.Key_AsciiTilde
                    text: "~"
                }
                Key {
                    id: normalKey
                    key: Qt.Key_Agrave
                    text: "`"
                }
                Key {
                    key: Qt.Key_AsciiCircum
                    text: "^"
                }
                Key {
                    key: Qt.Key_Equal
                    text: "="
                }
                Key {
                    key: Qt.Key_Semicolon
                    text: ";"
                }
                Key {
                    key: Qt.Key_BraceLeft
                    text: "{"
                }
                Key {
                    key: Qt.Key_BraceRight
                    text: "}"
                }
                Key {
                    key: Qt.Key_BracketLeft
                    text: "["
                }
                Key {
                    key: Qt.Key_BracketRight
                    text: "]"
                }
                Key {
                    key: Qt.Key_Backslash
                    text: "\\"
                }
            }
            KeyboardRow {
                Key {
                    key: Qt.Key_At
                    text: "@"
                }
                Key {
                    key: Qt.Key_NumberSign
                    text: "#"
                }
                Key {
                    key:  Qt.Key_Percent
                    text: "%"
                }
                Key {
                    key: Qt.Key_Ampersand
                    text: "&"
                }
                Key {
                    key: Qt.Key_Asterisk
                    text: "*"
                }
                Key {
                    key: Qt.Key_Underscore
                    text: "_"
                }
                Key {
                    key: Qt.Key_Minus
                    text: "-"
                }
                Key {
                    key: Qt.Key_Plus
                    text: "+"
                }
                Key {
                    key: Qt.Key_ParenLeft
                    text: "("
                }
                Key {
                    key: Qt.Key_ParenRight
                    text: ")"
                }
            }
            KeyboardRow {
                Key {
                    key:  Qt.Key_QuoteDbl
                    text: '"'
                }
                Key {
                    key: Qt.Key_Less
                    text: "<"
                }
                Key {
                    key: Qt.Key_Greater
                    text: ">"
                }
                Key {
                    key: Qt.Key_Apostrophe
                    text: "'"
                }
                Key {
                    key: Qt.Key_Colon
                    text: ":"
                }
                Key {
                    key: Qt.Key_Slash
                    text: "/"
                }
                Key {
                    key: Qt.Key_Exclam
                    text: "!"
                }
                Key {
                    key: Qt.Key_Question
                    text: "?"
                }
                BackspaceKey {
                    weight: functionKeyWidth
                    Layout.fillWidth: false
                }
            }
            KeyboardRow {
                SymbolModeKey {
                    weight: functionKeyWidth
                    Layout.fillWidth: false
                    displayText: "ABC"
                }
                Key {
                    key: Qt.Key_Comma
                    weight: normalKeyWidth
                    Layout.fillWidth: false
                    text: ","
                    highlighted: true
                }
                Key {
                    text: " "
                    displayText: "\u2015\u2015" //"\u2423"
                    highlighted: true
                }
                Key {
                    key: Qt.Key_Period
                    weight: normalKeyWidth
                    Layout.fillWidth: false
                    text: "."
                    highlighted: true
                }
                HideKeyboardKey {
                    weight: normalKeyWidth
                    Layout.fillWidth: false
                }
                EnterKey {
                    weight: functionKeyWidth
                    Layout.fillWidth: false
                }
            }
        }
    }
}
