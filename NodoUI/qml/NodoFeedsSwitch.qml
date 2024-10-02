import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Rectangle {
    property int index: 0

    id: feedRect
    height: visible ? NodoSystem.nodoItemHeight : 0
    visible: feedsControl.getVisibleState(index)

    property int labelItemSize: 0
    property int labelRectRoundSize: feedSwitchText.labelRectRoundSize

    Component.onCompleted: {
        feedSwitch.checked = feedsControl.isRSSSourceSelected(index)
    }


    NodoLabel{
        id: feedSwitchText
        height: NodoSystem.nodoItemHeight
        itemSize: labelItemSize
        text: feedsControl.getRSSName(index)
    }

    NodoSwitch {
        id: feedSwitch
        anchors.left: feedSwitchText.right
        anchors.leftMargin: NodoSystem.padding
        height: NodoSystem.nodoItemHeight
        width: 2*height
        display: AbstractButton.IconOnly

        onCheckedChanged: {
            feedsControl.setRSSSelectionState(index, checked)
        }
    }
}
