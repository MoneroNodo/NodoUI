import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: deviceNewsFeedsScreen
    anchors.fill: parent
    property int labelSize: 0
    property int nodoTopMargin: 20

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceNewsFeed0Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed0Rect.labelRectRoundSize

        if(deviceNewsFeed0Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed0Rect.labelRectRoundSize

        if(deviceNewsFeed1Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed1Rect.labelRectRoundSize

        if(deviceNewsFeed2Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed2Rect.labelRectRoundSize

        if(deviceNewsFeed3Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed3Rect.labelRectRoundSize

        if(deviceNewsFeed4Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed4Rect.labelRectRoundSize

        if(deviceNewsFeed5Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed5Rect.labelRectRoundSize

        if(deviceNewsFeed6Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed6Rect.labelRectRoundSize

        if(deviceNewsFeed7Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed7Rect.labelRectRoundSize

        if(deviceNewsFeed8Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed8Rect.labelRectRoundSize

        if(deviceNewsFeed9Rect.labelRectRoundSize > labelSize)
            labelSize = deviceNewsFeed9Rect.labelRectRoundSize
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed0Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeedsScreen.top
        anchors.topMargin: 0
        index: 0
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed1Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed0Rect.bottom
        anchors.topMargin: deviceNewsFeed0Rect.visible ? nodoTopMargin : 0
        index: 1
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed2Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed1Rect.bottom
        anchors.topMargin: deviceNewsFeed1Rect.visible ? nodoTopMargin : 0
        index: 2
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed3Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed2Rect.bottom
        anchors.topMargin: deviceNewsFeed2Rect.visible ? nodoTopMargin : 0
        index: 3
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed4Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed3Rect.bottom
        anchors.topMargin: deviceNewsFeed3Rect.visible ? nodoTopMargin : 0
        index: 4
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed5Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed4Rect.bottom
        anchors.topMargin: deviceNewsFeed4Rect.visible ? nodoTopMargin : 0
        index: 5
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed6Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed5Rect.bottom
        anchors.topMargin: deviceNewsFeed5Rect.visible ? nodoTopMargin : 0
        index: 6
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed7Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed6Rect.bottom
        anchors.topMargin: deviceNewsFeed6Rect.visible ? nodoTopMargin : 0
        index: 7
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed8Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed7Rect.bottom
        anchors.topMargin: deviceNewsFeed7Rect.visible ? nodoTopMargin : 0
        index: 8
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed9Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeed8Rect.bottom
        anchors.topMargin: deviceNewsFeed8Rect.visible ? nodoTopMargin : 0
        index: 9
    }
}
