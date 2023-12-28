import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4

import NodoSystem 1.1

Item {
    id: newsMainScreen
    anchors.fill: parent
    anchors.leftMargin: NodoSystem.subMenuLeftMargin

    property int curIndexWitouthZero: 0
    property bool isScreenSaver: false
    signal reloadPage()
    property Component refreshIndicatorDelegate: RefreshIndicator {}
    Component{
        id: newsPage
        Rectangle {
            id: app
            height: newsMainScreen.height
            width: newsMainScreen.width
            color: "black"
            signal reloadComponent()
            property bool refreshFlik: false
            property int threshold: 100
            property real m_progress: (flick.verticalOvershoot * -100) / threshold
            property bool is_pulldown: false
            property bool is_increment: true
            Flickable {
                id: flick
                anchors.fill: parent
                contentHeight : rect.height

                Rectangle{
                    id: rect
                    height: newsMainScreen.height - 10
                    width: newsMainScreen.width
                    color: "black"

                    Connections {
                        target: feedParser
                        /*
                          If you are here because of the "QML Connections: Implicitly defined onFoo properties in Connections are deprecated." warning,
                          see comment in NodoComboBox.qml
                        */
                        onPostListReady: {
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
                        sourceComponent: rect.viewSwipe
                        active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                        asynchronous: true
                    }

                    BusyIndicator {
                        id: busyIndicator
                        x: parent.width/2 - busyIndicator.width/2
                        y: parent.height/2 - busyIndicator.height/2
                        running: true
                        palette.dark: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
                    }
                }

                Connections
                {
                    target: flick
                    /*
                      If you are here because of the "QML Connections: Implicitly defined onFoo properties in Connections are deprecated." warning,
                      see comment in NodoComboBox.qml
                    */
                    onVerticalOvershootChanged: {
                        if (!target.verticalOvershoot)
                        {
                            if(is_pulldown)
                            {
                                for (var i = 0; i < viewSwipe.count; i++)  {
                                    viewSwipe.removeItem(i)
                                }
                                reloadComponent()
                            }
                        }

                        if (target.verticalOvershoot < 0)
                        {
                            if (Math.abs(flick.verticalOvershoot) > threshold)
                            {
                                is_pulldown = true
                            }
                        }
                    }
                }
            }

            Component.onCompleted:{
                feedParser.setTextColor(nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff)
            }

            Loader
            {
                id: refresh_indicator_loader
                property real dragProgress: m_progress
                property var handler: newsMainScreen
                sourceComponent: m_progress > 0 ? newsMainScreen.refreshIndicatorDelegate : undefined
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
                /*
                  If you are here because of the "QML Connections: Implicitly defined onFoo properties in Connections are deprecated." warning,
                  see comment in NodoComboBox.qml
                */
                onTriggered: changeFeed()
            }
        }
    }

    Loader{
        id:ldr
        sourceComponent: newsPage
        Connections{
            target:ldr.item
            onReloadComponent: {
                ldr.sourceComponent = undefined
                ldr.sourceComponent = newsPage
            }
        }
    }
}
