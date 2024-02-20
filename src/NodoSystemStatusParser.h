#ifndef NODO_SYSTEM_STATUS_PARSER_H
#define NODO_SYSTEM_STATUS_PARSER_H

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>

class NodoSystemStatusParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoSystemStatusParser(QObject *parent = Q_NULLPTR);
    Q_INVOKABLE QString getStringValueFromKey(QString key);
    Q_INVOKABLE int getIntValueFromKey(QString key);
    Q_INVOKABLE bool getBoolValueFromKey(QString key);
    Q_INVOKABLE void updateRequested(void);

signals:
    void systemStatusReady(void);

private:
    QNetworkAccessManager *m_manager;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QString m_system_url = "http://127.0.0.1:18080/get_info";
    QTimer *m_timer;

private slots:
   void replyFinished(QNetworkReply *reply);
    void updateStatus(void);
};

#endif /* NODO_SYSTEM_STATUS_PARSER_H */
