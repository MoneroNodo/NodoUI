import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: deviceNewsFeedsScreen
    anchors.fill: parent
    property int labelSize: 0

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(deviceNewsFeedsIncludeFeedsLabel.labelRectRoundSize > labelSize)
        labelSize = deviceNewsFeedsIncludeFeedsLabel.labelRectRoundSize

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

    NodoLabel{
        id: deviceNewsFeedsIncludeFeedsLabel
        anchors.left: deviceNewsFeedsScreen.left
        anchors.top: deviceNewsFeedsScreen.top
        height: NodoSystem.nodoItemHeight
        text: qsTr("Include these feeds:")
        itemSize: labelSize
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed0Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeedsIncludeFeedsLabel.bottom
        index: 0
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed1Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed0Rect.bottom
        index: 1
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed2Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed1Rect.bottom
        index: 2
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed3Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed2Rect.bottom
        index: 3
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed4Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed3Rect.bottom
        index: 4
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed5Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed4Rect.bottom
        index: 5
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed6Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed5Rect.bottom
        index: 6
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed7Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed6Rect.bottom
        index: 7
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed8Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed7Rect.bottom
        index: 8
    }

    NodoFeedsSwitch {
        id: deviceNewsFeed9Rect
        labelItemSize: labelSize
        anchors.left: deviceNewsFeedsIncludeFeedsLabel.left
        anchors.top: deviceNewsFeed8Rect.bottom
        index: 9
    }
}
