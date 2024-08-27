// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Components
import QtQuick.Layouts


KeyboardLayout {
    inputMode: InputEngine.InputMode.Latin
    keyWeight: 160
    readonly property real normalKeyWidth: normalKey.width
    readonly property real functionKeyWidth: mapFromItem(normalKey, normalKey.width / 2, 0).x
    KeyboardColumn {
        Layout.preferredHeight: normalKeyWidth*0.6
        Layout.fillHeight: false
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
            Key {
                key: Qt.Key_0
                text: "0"
            }
        }
    }

    KeyboardRow {
        Key {
            key: Qt.Key_Q
            text: "q"
        }
        Key {
            id: normalKey
            key: Qt.Key_W
            text: "w"
        }
        Key {
            key: Qt.Key_E
            text: "e"
        }
        Key {
            key: Qt.Key_R
            text: "r"
        }
        Key {
            key: Qt.Key_T
            text: "t"
        }
        Key {
            key: Qt.Key_Y
            text: "y"
        }
        Key {
            key: Qt.Key_U
            text: "u"
        }
        Key {
            key: Qt.Key_I
            text: "i"
        }
        Key {
            key: Qt.Key_O
            text: "o"
        }
        Key {
            key: Qt.Key_P
            text: "p"
        }
    }
    KeyboardRow {
        KeyboardRow {
            Layout.preferredWidth: functionKeyWidth
            Layout.fillWidth: false
            FillerKey {
            }
            Key {
                key: Qt.Key_A
                text: "a"
                weight: normalKeyWidth
                Layout.fillWidth: false
            }
        }
        Key {
            key: Qt.Key_S
            text: "s"
        }
        Key {
            key: Qt.Key_D
            text: "d"
        }
        Key {
            key: Qt.Key_F
            text: "f"
        }
        Key {
            key: Qt.Key_G
            text: "g"
        }
        Key {
            key: Qt.Key_H
            text: "h"
        }
        Key {
            key: Qt.Key_J
            text: "j"
        }
        Key {
            key: Qt.Key_K
            text: "k"
        }
        KeyboardRow {
            Layout.preferredWidth: functionKeyWidth
            Layout.fillWidth: false
            Key {
                key: Qt.Key_L
                text: "l"
                weight: normalKeyWidth
                Layout.fillWidth: false
            }
            FillerKey {
            }
        }
    }
    KeyboardRow {
        ShiftKey {
            weight: functionKeyWidth
            Layout.fillWidth: false
        }
        Key {
            key: Qt.Key_Z
            text: "z"
        }
        Key {
            key: Qt.Key_X
            text: "x"
        }
        Key {
            key: Qt.Key_C
            text: "c"
        }
        Key {
            key: Qt.Key_V
            text: "v"
        }
        Key {
            key: Qt.Key_B
            text: "b"
        }
        Key {
            key: Qt.Key_N
            text: "n"
        }
        Key {
            key: Qt.Key_M
            text: "m"
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
            displayText: "#+="
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
