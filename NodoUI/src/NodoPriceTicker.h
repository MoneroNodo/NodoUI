#ifndef NODOPRICETICKER_H
#define NODOPRICETICKER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QSslError>
#include <QUrl>
#include <QTimer>

#include "NodoConfigParser.h"
#include "NodoNetworkManager.h"

#define FETCH_PERIOD 60*1000

class NodoPriceTicker : public QObject
{
    Q_OBJECT
public:
    explicit NodoPriceTicker(NodoConfigParser *configParser = Q_NULLPTR, NodoNetworkManager *networkManager = Q_NULLPTR);

    Q_INVOKABLE int getCurrentCurrencyIndex(void);
    Q_INVOKABLE void setCurrentCurrencyIndex(int index);
    Q_INVOKABLE QString getCurrentCurrencyName(void);
    Q_INVOKABLE void setCurrentCurrencyName(QString name);
    Q_INVOKABLE QString getCurrentCurrencyCode(void);
    Q_INVOKABLE void setCurrentCurrencyCode(QString code);
    Q_INVOKABLE double getCurrency(void);
    Q_INVOKABLE QString getCurrencyString(void);
    Q_INVOKABLE void updateRequest(void);
    Q_INVOKABLE bool isCurrencyReceived(void);


signals:
    void currencyIndexChanged();
    void currencyReceived(void);

private:
    int m_currentCurrencyIndex = 0;
    QString m_currentCurrencyName = "";
    QString m_currentCurrencyCode = "";
    QString m_newCurrencyCode = "";
    NodoConfigParser *m_configParser;
    NodoNetworkManager *m_networkManager;

    QNetworkAccessManager m_manager;
    QTimer *m_timer;

    bool currencyReceivedStatus = false;


    void doDownload(const QString currencyCode);
    double m_currency = 0;

private slots:
    void downloadFinished(QNetworkReply *reply);
    void updatePriceTicker(void);
    void sslErrors(const QList<QSslError> &errors);
    void checkConnectionStatus(void);

};

#endif // NODOPRICETICKER_H
