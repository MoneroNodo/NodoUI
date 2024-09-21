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

#define MAX_FEED_SOURCE_COUNT 10

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
}feed_tags_t;

class QSslError;

class NodoFeedParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoFeedParser(QObject *parent = Q_NULLPTR);
    QVector<feed_tags_t> readFeedKeys(void);
    void writeFeedKeys(feed_keys_t key, int index, bool state);
    int getFeedCount(void);
    int getIndexFromUri(const QUrl &url);

private:
    QVector< feed_tags_t > m_allFeedParams;

    int m_feedCount = 0;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_feedsObj;
    const QStringList m_feedKeyList = {"name", "uri", "selected", "visible", "num_of_feeds_to_show", "description_tag", "image_tag", "image_attr", "pub_date_tag"};
    const QString feedObjName = "feeds";
    const QString m_feedNames = "feed_";
    const QString m_json_file_name = "/home/nodo/variables/nodoUI.feeds.json";

    bool isFeedValid(int index);
    void writeJson(void);

};

#endif // NODO_FEED_PARSER_H
