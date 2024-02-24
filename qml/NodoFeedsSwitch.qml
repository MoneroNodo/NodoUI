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

    NodoSwitch {
        id: feedSwitch
        x: 0
        y: 0
        width: 128
        height: 64
        text: qsTr("")
        display: AbstractButton.IconOnly
        checked: nodoControl.getSelectedState(index)

        onCheckedChanged: {
            nodoControl.setSelectedState(index, checked)
        }
    }

    Text{
        id: feedSwitchText
        x: feedSwitch.width + 10
        y: (feedSwitch.height - feedSwitchText.height)/2
        width: feedSwitchText.paintedWidth
        height: feedSwitchText.paintedHeight
        text: nodoControl.getFeederNameState(index)
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.textFontSize
    }
}
