import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Page {
    id: newsMainScreen
    anchors.fill: parent
    property bool isScreenSaver: false
    property bool is_increment: true

    Component.onCompleted: {
        busyIndicator.running = true
        getNewsPageList()
        busyIndicator.running = false
    }

    function getNewsPageList() {
        newsListModel.clear()
        var sourceCount = feedsControl.getNumOfRSSSource()
        var tmpcnt = 0;

        for (var i = 0; i < sourceCount; i++)  {
            if(feedsControl.isRSSSourceSelected(i)) {
                var itemCount = feedsControl.getDisplayedItemCount(i)
                if(itemCount === 0)
                {
                    tmpcnt++;
                }

                for (var j = 0; j < itemCount; j++)  {
                    var newsPage = {"headerTextStr": feedsControl.getItemTitle(i, j),
                        "dataTextStr": feedsControl.getItemDescription(i, j),
                        "channelStr": feedsControl.getItemChannel(i, j),
                        "dataTagStr": feedsControl.getItemTag(i, j),
                        "headerAuthStr": feedsControl.getItemAuth(i, j),
                        "dataTimestampStr": feedsControl.getItemTimestamp(i, j),
                        "imagePath": feedsControl.getItemImage(i, j)}
                    newsListModel.append(newsPage)
                }
            }
        }

        if(tmpcnt === 0)
        {
            var emptyNewsPage = {"headerTextStr": qsTr("No feeds available"),
                "dataTextStr": "",
                "channelStr": "",
                "dataTagStr": "",
                "headerAuthStr": "",
                "dataTimestampStr": "",
                "imagePath": ""}
            newsListModel.append(emptyNewsPage)
        }
    }

    SwipeView {
        id: newsView
        currentIndex: 0
        anchors.fill: parent
        anchors.top: parent.top

        Repeater {
            model: newsListModel
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                sourceComponent: NewsContentScreen {
                    headerTextStr: model.headerTextStr
                    dataTextStr: model.dataTextStr
                    channelStr: model.channelStr
                    dataTagStr: model.dataTagStr
                    headerAuthStr: model.headerAuthStr
                    dataTimestampStr: model.dataTimestampStr
                    imagePath: model.imagePath
                }
            }
        }
    }

    NodoBusyIndicator {
        id: busyIndicator
        x: parent.width/2 - busyIndicator.width/2
        y: parent.height/2 - busyIndicator.height/2
        running: false
        indicatorColor: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
    }

    function changeFeed()
    {
        if(true == is_increment)
        {
            if(newsView.currentIndex+1 < newsView.count)
            {
                newsView.incrementCurrentIndex()
            }
            else
            {
                is_increment = false
                newsView.decrementCurrentIndex()
            }
        }
        else
        {
            if(0 !== newsView.currentIndex)
            {
                newsView.decrementCurrentIndex()
            }
            else {
                is_increment = true
                newsView.incrementCurrentIndex()
            }
        }
    }

    Timer {
        id: newsMainScreenTimer
        interval: nodoControl.getScreenSaverItemChangeTimeout(); running: isScreenSaver; repeat: true
        onTriggered: changeFeed()
    }

    ListModel {
        id: newsListModel
    }
}


