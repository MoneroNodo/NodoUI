#ifndef NODOSYNCINFO_H
#define NODOSYNCINFO_H

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

class NodoSyncInfo : public QObject
{
    Q_OBJECT
public:
    explicit NodoSyncInfo(QObject *parent = nullptr);
    Q_INVOKABLE void updateRequested(void);
    Q_INVOKABLE int getSyncPercentage(void);
    Q_INVOKABLE void startSyncStatusUpdate(void);

private:
    QNetworkAccessManager *manager;
    int m_height = 0;
    int m_targetHeight = 0;

    void ReplyFinished(QNetworkReply *reply);

signals:
    void syncStatusReady(void);
};
#endif // NODOSYNCINFO_H
