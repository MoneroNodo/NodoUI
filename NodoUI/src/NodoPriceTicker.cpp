#include "NodoPriceTicker.h"
#include "qdebug.h"

NodoPriceTicker::NodoPriceTicker(NodoConfigParser *configParser, NodoNetworkManager *networkManager) : QObject(configParser)
{
    m_currentCurrencyIndex = 0;
    m_configParser = configParser;
    m_networkManager = networkManager;
    m_currentCurrencyCode = m_configParser->getSelectedCurrencyName();
    m_timer = new QTimer(this);

    connect(m_networkManager, SIGNAL(networkConnStatusReceived(bool)), this, SLOT(checkConnectionStatus(bool)));
    connect(&m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(downloadFinished(QNetworkReply*)));
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updatePriceTicker()));

    // if(m_networkManager->getAvailableConnectionStatus())
    // {
    //     m_timer->start(2000);
    //     // doDownload(m_currentCurrencyCode);
    // }
}

void NodoPriceTicker::checkConnectionStatus(bool netConnStat)
{
    if(netConnStat)
    {
        m_timer->start(2000);
        // doDownload(m_currentCurrencyCode);
    }
    else
    {
         m_timer->stop();
    }
}

int NodoPriceTicker::getCurrentCurrencyIndex(void)
{
    return m_currentCurrencyIndex;
}

void NodoPriceTicker::setCurrentCurrencyIndex(int index)
{
    m_currentCurrencyIndex = index;
    emit currencyIndexChanged();
}

QString NodoPriceTicker::getCurrentCurrencyName(void)
{
    return m_currentCurrencyName;
}

void NodoPriceTicker::setCurrentCurrencyName(QString name)
{
    m_currentCurrencyName = name;
}

QString NodoPriceTicker::getCurrentCurrencyCode(void)
{
    return m_currentCurrencyCode;
}

void NodoPriceTicker::setCurrentCurrencyCode(QString code)
{
    m_currentCurrencyCode = code;
    m_configParser->setCurrencyName(code);
    doDownload(m_currentCurrencyCode);
}

void NodoPriceTicker::downloadFinished(QNetworkReply *reply)
{
    QUrl url = reply->url();

    if (reply->error()) {
        qDebug() << "Download of " << url.toEncoded().constData() << " failed: " << qPrintable(reply->errorString());
    }
    else {
        QJsonDocument m_document = QJsonDocument::fromJson(reply->readAll());
        QJsonObject m_moneroObj = m_document.object();
        QJsonObject m_currencyObj = m_moneroObj["monero"].toObject();
        QJsonValue jsonValue = m_currencyObj.value(m_currentCurrencyCode.toLower());

        m_currency = jsonValue.toDouble();
        emit currencyReceived();
    }
    reply->deleteLater();
}


void NodoPriceTicker::doDownload(const QString currencyCode)
{
    m_timer->stop();

    const QUrl &url = "https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=" +currencyCode + "&precision=2";
    QNetworkRequest request(url);
    QNetworkReply *reply = m_manager.get(request);

#ifndef QT_NO_SSL
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), SLOT(sslErrors(QList<QSslError>)));
#endif

    m_timer->start(10*60*1000);
}

double NodoPriceTicker::getCurrency(void)
{
    return m_currency;
}

void NodoPriceTicker::updatePriceTicker(void)
{
    doDownload(m_currentCurrencyCode);
}

void NodoPriceTicker::sslErrors(const QList<QSslError> &sslErrors)
{
#ifndef QT_NO_SSL
    foreach (const QSslError &error, sslErrors){
        if(error.CertificateNotYetValid)
        {
            qDebug() << "not yet valid error";
            m_timer->start(2000);
        }
        qDebug() << "SSL error: " << qPrintable(error.errorString());
    }
#else
    Q_UNUSED(sslErrors);
#endif
}
