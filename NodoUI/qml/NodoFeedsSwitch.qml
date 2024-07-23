import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Rectangle {
    property int index: 0

    id: feedRect
    height: visible ? 60 : 0
    visible: nodoControl.getVisibleState(index)

    property int labelItemSize: 0
    property int labelRectRoundSize: feedSwitchText.labelRectRoundSize


    NodoLabel{
        id: feedSwitchText
        height: NodoSystem.nodoItemHeight
        itemSize: labelItemSize
        text: nodoControl.getFeederNameState(index)
    }

    NodoSwitch {
        id: feedSwitch
        anchors.left: feedSwitchText.right
        anchors.leftMargin: NodoSystem.padding
        height: NodoSystem.nodoItemHeight
        width: 2*height
        display: AbstractButton.IconOnly
        checked: nodoControl.getSelectedState(index)

        onCheckedChanged: {
            nodoControl.setSelectedState(index, checked)
        }
    }
}
