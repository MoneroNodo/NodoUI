#ifndef NODOFEEDSCONTROL_H
#define NODOFEEDSCONTROL_H

#include <QObject>

#include "NodoNetworkManager.h"
#include "NodoSystemControl.h"
#include "NodoFeedParser.h"
#include "pugixml.hpp"

#define DOWNLOAD_PERIOD_IN_SECS 60*60

typedef enum {
    FEED_STATUS_DONT_DOWNLOAD,
    FEED_STATUS_DOWNLOADABLE,
    FEED_STATUS_DOWNLOADING,
    FEED_STATUS_DOWNLOADED,
    FEED_STATUS_DOWNLOAD_FAILED
} feed_download_status_t;

typedef struct{
    QString channelName;
    QString subtagName;
    QString author;
    QString timeStamp;
    QString title;
    QString description;
    QString imgPath;
}feed_fields_t;

typedef struct {
    feed_download_status_t downloadStatus;
    QNetworkReply *reply;
    QVector< feed_fields_t > m_feeds;
} m_rss_source_t;


class NodoFeedsControl : public QObject
{
    Q_OBJECT
public:
    explicit NodoFeedsControl(NodoNetworkManager *networkManager = Q_NULLPTR, NodoSystemControl *systemControl = Q_NULLPTR);

    Q_INVOKABLE bool getVisibleState(int index);

    Q_INVOKABLE void setRSSSelectionState(int index, bool state);
    Q_INVOKABLE QString getRSSName(const int sourceIndex);

    Q_INVOKABLE int getDisplayedItemCount(const int sourceIndex);

    Q_INVOKABLE QString getItemTitle(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE QString getItemDescription(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE QString getItemChannel(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE QString getItemTag(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE QString getItemAuth(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE QString getItemTimestamp(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE QString getItemImage(const int sourceIndex, const int feedIndex);
    Q_INVOKABLE void setTextColor(QString textColor);

    Q_INVOKABLE int getNumOfRSSSource(void);
    Q_INVOKABLE bool isRSSSourceSelected(const int sourceIndex);

private:
    QString m_textColor;

    NodoNetworkManager *m_networkManager;
    NodoFeedParser *m_feedParser;
    NodoSystemControl *m_systemControl;
    QNetworkAccessManager m_downloadManager;

    QVector< feed_tags_t > m_feeds_str;
    QTimer *m_timer;

    QVector< m_rss_source_t > m_rss_sources;

    void prepareDownload(int index);

private slots:
    void checkConnectionStatus(void);
    void downloadRSSContent(void);

    void sslErrors(const QList<QSslError> &errors);
    void downloadFinished(QNetworkReply *reply);
};

#endif // NODOFEEDSCONTROL_H
