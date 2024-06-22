#ifndef NODO_SYSTEM_STATUS_PARSER_H
#define NODO_SYSTEM_STATUS_PARSER_H

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>

#include "NodoConfigParser.h"

class NodoSystemStatusParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoSystemStatusParser(NodoConfigParser *configParser = Q_NULLPTR);
    Q_INVOKABLE QString getStringValueFromKey(QString key);
    Q_INVOKABLE int getIntValueFromKey(QString key);
    Q_INVOKABLE bool getBoolValueFromKey(QString key);
    // Q_INVOKABLE void updateSystemStatus(void);
    Q_INVOKABLE void updateRequested(void);


signals:
    void systemStatusReady(void);

private:
    QNetworkAccessManager *m_manager;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QString m_system_url;
    QTimer *m_timer;

    NodoConfigParser *m_configParser;

private slots:
   void replyFinished(QNetworkReply *reply);
    void updateStatus(void);
   void updateConfigParameters(void);
};

#endif /* NODO_SYSTEM_STATUS_PARSER_H */
