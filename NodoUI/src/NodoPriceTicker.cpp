#include "NodoPriceTicker.h"
#include "qdebug.h"

NodoPriceTicker::NodoPriceTicker(NodoConfigParser *configParser, NodoNetworkManager *networkManager, NodoSystemControl *systemControl) : QObject(configParser)
{
    m_currency = -1;
    m_currentCurrencyIndex = 0;
    m_configParser = configParser;
    m_networkManager = networkManager;
    m_systemControl = systemControl;
    m_currentCurrencyCode = m_configParser->getSelectedCurrencyName();
    m_newCurrencyCode = m_currentCurrencyCode;

    m_timer = new QTimer(this);

    connect(m_networkManager, SIGNAL(networkStatusChanged()), this, SLOT(checkConnectionStatus()));
    connect(&m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(downloadFinished(QNetworkReply*)));
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updatePriceTicker()));

    if(m_networkManager->isConnected())
    {
        m_timer->start(500);
    }
}

void NodoPriceTicker::checkConnectionStatus(void)
{
    if(m_networkManager->isConnected())
    {
        m_timer->start(2000);
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
    m_newCurrencyCode = code;
    doDownload(code);
}

void NodoPriceTicker::downloadFinished(QNetworkReply *reply)
{
    int status = 0;
    QJsonObject m_currencyObj;

    QUrl url = reply->url();

    if (reply->error()) {
        status = 1;
        qDebug() << "Download of " << url.toEncoded().constData() << " failed: " << qPrintable(reply->errorString());
    }
    else {
        QJsonDocument m_document = QJsonDocument::fromJson(reply->readAll());
        QJsonObject m_moneroObj = m_document.object();
        m_currencyObj = m_moneroObj["monero"].toObject();
        if(!m_currencyObj.isEmpty())
        {
            status = 2;
        }
        else
        {
            status = 3;
        }
    }

    if(2 == status) // we have a valid response from the server
    {
        QJsonValue jsonValue;
        if(m_newCurrencyCode == m_currentCurrencyCode)
        {
            jsonValue = m_currencyObj.value(m_currentCurrencyCode.toLower());
        }
        else
        {
            jsonValue = m_currencyObj.value(m_newCurrencyCode.toLower());
            m_configParser->setCurrencyName(m_newCurrencyCode);
            m_currentCurrencyCode = m_newCurrencyCode;
        }

        double tmp = jsonValue.toDouble();
        if(tmp != m_currency)
        {
            m_configParser->setExchangeRate(tmp);
        }

        m_currency = tmp;
    }
    else //no valid response
    {
        if(m_newCurrencyCode == m_currentCurrencyCode)
        {
            m_currency = m_configParser->getExchangeRate();
        }
        else // as the currency has changed and the response from the server isn't valid, we don't know it's value
        {
            m_currency = -1;
            m_configParser->setCurrencyName(m_newCurrencyCode);
            m_configParser->setExchangeRate(m_currency);
            m_currentCurrencyCode = m_newCurrencyCode;
        }
    }

    currencyReceivedStatus = true;
    emit currencyReceived();

    reply->deleteLater();

    m_timer->start(FETCH_PERIOD);
}

bool NodoPriceTicker::isCurrencyReceived(void)
{
    return currencyReceivedStatus;
}

void NodoPriceTicker::doDownload(const QString currencyCode)
{
    m_timer->stop();
    if (!m_systemControl->isTickerEnabled())
        return;

    if (m_systemControl->istorProxyEnabled())
    {
        QNetworkProxy torProxy;
        torProxy.setType(QNetworkProxy::Socks5Proxy);
        torProxy.setHostName("127.0.0.1");
        torProxy.setPort(9050);
        m_manager.setProxy(torProxy);
    }
    else
    {
        QNetworkProxy noProxy;
        noProxy.setType(QNetworkProxy::NoProxy);
        m_manager.setProxy(noProxy);
    }

    const QUrl &url = "https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=" +currencyCode + "&precision=2";
    QNetworkRequest request(url);

    QNetworkReply *reply = m_manager.get(request);

#ifndef QT_NO_SSL
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), SLOT(sslErrors(QList<QSslError>)));
#endif 
}

QString NodoPriceTicker::getCurrencyString(void)
{
    return QString::number(m_currency, 'f', 2);
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

void NodoPriceTicker::updateRequest(void)
{
    updatePriceTicker();
}
