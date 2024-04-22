import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

ComboBox {
    id: control
    font.family: NodoSystem.fontUrbanist.name
    font.pixelSize: NodoSystem.comboboxFontSize

    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            text: modelData
            color: NodoSystem.comboBoxTextColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {color: highlighted ? (nodoControl.appTheme ? NodoSystem.comboBoxHighligtedItemBGColorNightModeOn : NodoSystem.comboBoxHighligtedItemBGColorNightModeOff) :
                                                    (nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff)}

        highlighted: control.highlightedIndex === index
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() {
                canvas.requestPaint()
            }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = "white"
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 10
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: NodoCanvas {
        implicitWidth: 120
        implicitHeight: 40
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
        bottomPadding: 12
        topPadding: 12
        leftPadding: 2
        rightPadding: 2

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight > 400 ? 400 : contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: NodoCanvas {
            color: nodoControl.appTheme ? NodoSystem.dataFieldTitleBGColorNightModeOn : NodoSystem.dataFieldTitleBGColorNightModeOff
        }
    }
}
