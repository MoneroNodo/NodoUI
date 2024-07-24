#ifndef NODO_FEED_PARSER_H
#define NODO_FEED_PARSER_H
#include <QObject>
#include <QVector>
#include <QFile>
#include <QFileInfo>
#include <QList>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QSslError>
#include <QStringList>
#include <QTimer>
#include <QUrl>
#include <QVector>
#include <QTimer>
#include <QDebug>
#include <QSslError>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

#define MAX_FEED_COUNT 10

typedef enum {
    KEY_NAME,
    KEY_URI,
    KEY_SELECTED,
    KEY_VISIBLE,
    KEY_NUM_OF_FEEDS_TO_SHOW,
    KEY_DESCRIPTION_TAG,
    KEY_IMAGE_TAG,
    KEY_IMAGE_ATTR,
    KEY_PUB_DATE_TAG,
}feed_keys_t;

typedef struct {
    QString nameItem;
    QString uriItem;
    bool selectedItem;
    bool visibleItem;
    int numOfFeedsToShowItem;
    QString description_tag;
    QString image_tag;
    QString image_attr_tag;
    QString pub_date_tag;
}feeds_t;

struct post_t{
    Q_GADGET
public:
    QString channelName;
    QString subtagName;
    QString author;
    QString timeStamp;
    QString title;
    QString description;
    QString imgPath;
};

class QSslError;

class NodoFeedParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoFeedParser(QObject *parent = Q_NULLPTR);

    Q_INVOKABLE int getItemCount(void);
    Q_INVOKABLE QString getItemTitle(const int index);
    Q_INVOKABLE QString getItemDescription(const int index);
    Q_INVOKABLE QString getItemChannel(const int index);
    Q_INVOKABLE QString getItemTag(const int index);
    Q_INVOKABLE QString getItemAuth(const int index);
    Q_INVOKABLE QString getItemTimestamp(const int index);
    Q_INVOKABLE QString getItemImage(const int index);
    Q_INVOKABLE void updateRequested(void);
    Q_INVOKABLE void setTextColor(QString textColor);

    QVector<feeds_t> readFeedKeys(void);
    void writeFeedKeys(feed_keys_t key, int index, bool state);

signals:
    void postListReady(void);
    void feedReceived(void);

private:
    int m_RSSPostCount;
    int m_RSSCount;
    int m_receivedRSSCount;

    QVector< post_t > m_feeds[MAX_FEED_COUNT];
    QVector< post_t > m_all_posts;
    QVector< feeds_t > m_feeds_str;
    QNetworkAccessManager m_manager;
    QList<QNetworkReply *> m_currentDownloads;

    QString m_textColor;
    int m_feedCount = 0;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_feedsObj;
    const QStringList m_feedKeyList = {"name", "uri", "selected", "visible", "num_of_feeds_to_show", "description_tag", "image_tag", "image_attr", "pub_date_tag"};
    const QString feedObjName = "feeds";
    const QString m_feedNames = "feed_";
    const QString m_json_file_name = "/home/nodo/variables/nodoUI.feeds.json";

    void doDownload(const QUrl &url);
    int getIndexFromUri(const QUrl &url);
    bool isFeedValid(int index);
    void writeJson(void);
    int getFeedCount(void);

private slots:
    void downloadFinished(QNetworkReply *reply);
    void sslErrors(const QList<QSslError> &errors);
    void updateFeedList(void);

public slots:
    void request(void);

};

#endif // NODO_FEED_PARSER_H
