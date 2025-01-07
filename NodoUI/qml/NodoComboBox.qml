import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

ComboBox {
    id: control
    font.family: NodoSystem.fontInter.name
    font.pixelSize: NodoSystem.infoFieldItemFontSize

    delegate: ItemDelegate {
        width: control.width
        height: control.height
        contentItem: Text {
            text: modelData
            color: NodoSystem.comboBoxTextColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {color: highlighted ? (nodoControl.appTheme ? NodoSystem.comboBoxHighlightedItemBGColorNightModeOn : NodoSystem.comboBoxHighlightedItemBGColorNightModeOff) :
                                                    (nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff)}

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
            context.fillStyle = "#F5F5F5"
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 10
        rightPadding: control.indicator.width + control.spacing
        height: control.height

        text: control.displayText
        font: control.font
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: NodoCanvas {
        implicitWidth: 120
        // implicitHeight: control.height
        height: control.height
        width: control.width
        color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
    }

    popup: Popup {
        id: comboboxPopup
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
            width: control.width
            height: comboboxPopup.implicitHeight
            color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn : NodoSystem.dataFieldTextBGColorNightModeOff
        }
    }
}
