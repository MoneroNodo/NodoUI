#ifndef NODO_FEED_PARSER_H
#define NODO_FEED_PARSER_H
#include <QObject>
#include <QVector>
#include "NodoConfigParser.h"
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
    explicit NodoFeedParser(NodoConfigParser *configParser = Q_NULLPTR);

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

    void doDownload(const QUrl &url);
    int getIndexFromUri(const QUrl &url);
    bool isFeedValid(int index);
    NodoConfigParser *m_configParser;
    QString m_textColor;

private slots:
    void downloadFinished(QNetworkReply *reply);
    void sslErrors(const QList<QSslError> &errors);
    void updateFeedList(void);


public slots:
    void request(void);

};

#endif // NODO_FEED_PARSER_H
