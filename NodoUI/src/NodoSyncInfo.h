#ifndef NODOSYNCINFO_H
#define NODOSYNCINFO_H

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>
#include "NodoSystemStatusParser.h"

class NodoSyncInfo : public QObject
{
    Q_OBJECT
public:
    explicit NodoSyncInfo(NodoSystemStatusParser *systemStatusParser = Q_NULLPTR);
    Q_INVOKABLE int getSyncPercentage(void);

private:
    QNetworkAccessManager *m_manager;
    int m_height = 0;
    int m_targetHeight = 0;
    int m_syncPercentage = 0;
    bool m_synced = false;
    NodoSystemStatusParser *m_statusParser;

signals:
    void syncStatusReady(void);
    emit void syncDone(void);

private slots:
    void updateStatus(void);
};
#endif // NODOSYNCINFO_H
