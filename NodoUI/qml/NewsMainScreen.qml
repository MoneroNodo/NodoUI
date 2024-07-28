import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: newsMainScreen
    anchors.fill: parent
    property bool isScreenSaver: false
    Rectangle {
        id: app
        height: newsMainScreen.height
        width: newsMainScreen.width
        color: "black"
        property bool is_increment: true

        SwipeView {
            id: viewSwipe
            width: parent.width
            height: parent.height

            currentIndex: 0
            Component.onCompleted: {
                busyIndicator.running = true
                viewSwipe.createPages()
                busyIndicator.running = false
            }

            function createPages() {
                var sourceCount = feedsControl.getNumOfRSSSource()
                for (var i = 0; i < sourceCount; i++)  {
                    if(feedsControl.isRSSSourceSelected(i)) {
                        var itemCount = feedsControl.getDisplayedItemCount(i)
                        for (var j = 0; j < itemCount; j++)  {
                            viewSwipe.addPage(viewSwipe.createPage(feedsControl.getItemTitle(i, j),
                                                                   feedsControl.getItemDescription(i, j),
                                                                   feedsControl.getItemChannel(i, j),
                                                                   feedsControl.getItemTag(i, j),
                                                                   feedsControl.getItemAuth(i, j),
                                                                   feedsControl.getItemTimestamp(i, j),
                                                                   feedsControl.getItemImage(i, j)
                                                                   ))
                        }
                    }
                }
            }

            function addPage(page) {
                addItem(page)
                page.visible = true
            }
            function createPage(title, description, channel, tag, auth, timestamp, img_path){
                var component = Qt.createComponent("NewsContentScreen.qml");
                var page = component.incubateObject(viewSwipe,
                                                    {
                                                        headerTextStr: title,
                                                        dataTextStr: description,
                                                        channelStr: channel,
                                                        dataTagStr: tag,
                                                        headerAuthStr: auth,
                                                        dataTimestampStr: timestamp,
                                                        imagePath: img_path
                                                    }
                                                    );
                return page
            }
        }

        Loader {
            id: loader
            sourceComponent: app.viewSwipe
            active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
            asynchronous: true
        }

        NodoBusyIndicator {
            id: busyIndicator
            x: parent.width/2 - busyIndicator.width/2
            y: parent.height/2 - busyIndicator.height/2
            running: false//true
            indicatorColor: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        }

        Component.onCompleted:{
            feedsControl.setTextColor(nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff)
        }

        function changeFeed()
        {
            if(true == is_increment)
            {
                if(viewSwipe.currentIndex+1 < viewSwipe.count)
                {
                    viewSwipe.incrementCurrentIndex()
                }
                else
                {
                    is_increment = false
                    viewSwipe.decrementCurrentIndex()
                }
            }
            else
            {
                if(0 !== viewSwipe.currentIndex)
                {
                    viewSwipe.decrementCurrentIndex()
                }
                else {
                    is_increment = true
                    viewSwipe.incrementCurrentIndex()
                }
            }
        }

        Timer {
            id: newsMainScreenTimer
            interval: nodoControl.getScreenSaverItemChangeTimeout(); running: isScreenSaver; repeat: true
            onTriggered: changeFeed()
        }
    }
}
