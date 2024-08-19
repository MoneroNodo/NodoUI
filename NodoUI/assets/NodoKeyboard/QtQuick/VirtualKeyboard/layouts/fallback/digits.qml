// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Components
import QtQuick.VirtualKeyboard.Plugins

KeyboardLayout {
    inputMethod: PlainInputMethod {}
    inputMode: InputEngine.InputMode.Numeric

    KeyboardColumn {
        Layout.fillWidth: false
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: height
        KeyboardRow {
            Key {
                key: Qt.Key_7
                text: "7"
            }
            Key {
                key: Qt.Key_8
                text: "8"
            }
            Key {
                key: Qt.Key_9
                text: "9"
            }
            FillerKey {}
        }
        KeyboardRow {
            Key {
                key: Qt.Key_4
                text: "4"
            }
            Key {
                key: Qt.Key_5
                text: "5"
            }
            Key {
                key: Qt.Key_6
                text: "6"
            }
            FillerKey {}
            // Key {
            //     text: " "
            //     displayText: "\u2015\u2015" //"\u2423"
            //     repeat: true
            //     showPreview: false
            //     key: Qt.Key_Space
            //     highlighted: true
            // }
        }
        KeyboardRow {
            Key {
                key: Qt.Key_1
                text: "1"
            }
            Key {
                key: Qt.Key_2
                text: "2"
            }
            Key {
                key: Qt.Key_3
                text: "3"
            }
            HideKeyboardKey {
                visible: true
            }
        }
        KeyboardRow {
            Key {
                // The decimal key, if it is not "," then we fallback to
                // "." in case it is an unhandled different result
                key: Qt.locale().decimalPoint === "," ? Qt.Key_Comma : Qt.Key_Period
                text: Qt.locale().decimalPoint === "," ? "," : "."
            }
            Key {
                key: Qt.Key_0
                text: "0"
            }

            BackspaceKey {}

            EnterKey {}
        }
    }
}
