import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Rectangle {
    property int index: 0

    id: feedRect
    height: visible ? 60 : 0
    visible: nodoControl.getVisibleState(index)
    anchors.topMargin: visible ? 16 : 0

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
