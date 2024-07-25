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

        Connections {
            target: feedParser
            function onPostListReady() {
                for (var i = 0; i < feedParser.getItemCount(); i++)  {
                    viewSwipe.addPage(viewSwipe.createPage(feedParser.getItemTitle(i),
                                                           feedParser.getItemDescription(i),
                                                           feedParser.getItemChannel(i),
                                                           feedParser.getItemTag(i),
                                                           feedParser.getItemAuth(i),
                                                           feedParser.getItemTimestamp(i),
                                                           feedParser.getItemImage(i)
                                                           ))

                }
                busyIndicator.running = false
            }
        }

        SwipeView {
            id: viewSwipe
            width: parent.width
            height: parent.height

            currentIndex: 0
            Component.onCompleted: {
                feedParser.updateRequested()
                busyIndicator.running = true
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
            running: true
            indicatorColor: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        }

        Component.onCompleted:{
            feedParser.setTextColor(nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff)
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
