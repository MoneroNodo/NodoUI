#include "MoneroPayConnection.h"
#include <algorithm>

#define RECEIVE_URL "http://localhost:34512/receive"
#define HEALTH_URL "http://localhost:34512/health"

typedef struct {
    QString transactionID;
    QDateTime dateTime;
}tx_hash_t;


MoneroPayConnection::MoneroPayConnection(T_payment payment)
{
    m_payment = payment;
    initialise();
}

MoneroPayConnection::MoneroPayConnection(QObject *parent)
{
    initialise();
}

void MoneroPayConnection::initialise(void)
{
    m_requestTimer = new QTimer(this);
    m_networkAccessManager = new QNetworkAccessManager();
    connect(m_networkAccessManager, &QNetworkAccessManager::finished, this, &MoneroPayConnection::replyFinished);
    connect(m_requestTimer, SIGNAL(timeout()), this, SLOT(sendRequest()));
}

MoneroPayConnection::~MoneroPayConnection()
{
    m_requestTimer->stop();
}

response_msg_t MoneroPayConnection::parseReceivePost(QByteArray reply)
{
    response_msg_t tmp;
    QJsonDocument document = QJsonDocument::fromJson(reply);
    QJsonObject rootObj = document.object();

    QJsonValue tmpValue = rootObj.value("address");
    tmp.address = tmpValue.toString();

    tmpValue = rootObj.value("amount");
    tmp.amount = (long int)tmpValue.toInteger();

    tmpValue = rootObj.value("description");
    tmp.description = tmpValue.toString();

    tmpValue = rootObj.value("created_at");
    QString s = rootObj["created_at"].toString();
    s = s.left(19);
    tmp.created_at = QDateTime::fromString(s,"yyyy-MM-ddThh:mm:ss");

    return tmp;
}

bool compareByDate(tx_hash_t left, tx_hash_t right)
{
    return right.dateTime < left.dateTime;
}

void MoneroPayConnection::parseReceiveAddress(QByteArray replyMessage)
{
    QJsonDocument document;
    QJsonObject rootObj;
    QJsonObject amountObj;
    QJsonObject amountCoveredObj;
    QJsonArray transactionsArray;

    document = QJsonDocument::fromJson(replyMessage);

    if(document.isEmpty())
    {
        return;
    }

    rootObj = document.object();
    amountObj = rootObj["amount"].toObject();
    amountCoveredObj = amountObj["covered"].toObject();
    transactionsArray = rootObj["transactions"].toArray();

    QJsonValue tmp = amountObj.value("expected");
    long int amountExpected = (long int)tmp.toInteger();

    tmp = amountCoveredObj.value("total");
    long int amountCoveredTotal = (long int)tmp.toInteger();

    tmp = amountCoveredObj.value("unlocked");
    long int amountCoveredUnlocked = (long int)tmp.toInteger();

    if(m_payment.blockConfirmation == 0)
    {
        if(amountExpected == amountCoveredTotal)
        {
            m_payment.paymentStatus = PAYMENT_SATUS_RECEIVED;
        }
        else
        {
            m_payment.paymentStatus = PAYMENT_SATUS_PENDING;
        }
    }
    else if(m_payment.blockConfirmation == 10)
    {
        if(amountExpected == amountCoveredUnlocked)
        {
            m_payment.paymentStatus = PAYMENT_SATUS_RECEIVED;
        }
        else
        {
            m_payment.paymentStatus = PAYMENT_SATUS_PENDING;
            m_requestTimer->start(SCAN_TIMEOUT_IN_MS);
        }
    }
    else
    {
        long int totalAmount = 0;
        int confirmations = 0;
        bool doubleSpendSeen = false;
        for(int i = 0; i < transactionsArray.size(); i++)
        {
            QJsonObject trObj = transactionsArray.at(i).toObject();
            QJsonValue tmpVal = trObj.value("double_spend_seen");
            doubleSpendSeen = tmpVal.toBool();

            tmpVal = trObj.value("confirmations");
            confirmations = tmpVal.toInt();

            if((confirmations >= m_payment.blockConfirmation) && (false == doubleSpendSeen))
            {
                tmpVal = trObj.value("amount");
                totalAmount = totalAmount + (long int)tmpVal.toInteger();
            }
        }

        qint64 expectedAmountInPico = (qint64)(m_payment.xmrAmountInPico*0.99);

        if(totalAmount >= expectedAmountInPico)
        {
            m_payment.paymentStatus = PAYMENT_SATUS_RECEIVED;
        }
        else
        {
            m_payment.paymentStatus = PAYMENT_SATUS_PENDING;
            m_requestTimer->start(SCAN_TIMEOUT_IN_MS);
        }
    }

    if(PAYMENT_SATUS_RECEIVED == m_payment.paymentStatus)
    {
        m_payment.xmrAmountInPico  = amountExpected;
        QString createdAt = rootObj["created_at"].toString();
        createdAt = createdAt.left(19);
        m_payment.dateTime = QDateTime::fromString(createdAt,"yyyy-MM-ddThh:mm:ss");
        m_payment.description = rootObj["description"].toString();

        QList <tx_hash_t> txList;

        for(int i = 0; i < transactionsArray.size(); i++)
        {
            tx_hash_t tmp_tr;
            QJsonObject trObj = transactionsArray.at(i).toObject();
            QString timestampStr = trObj.value("timestamp").toString();
            timestampStr = timestampStr.left(19);

            tmp_tr.transactionID = trObj.value("tx_hash").toString();
            tmp_tr.dateTime = QDateTime::fromString(timestampStr,"yyyy-MM-ddThh:mm:ss");

            txList.append(tmp_tr);
        }

        std::sort(txList.begin(), txList.end(), compareByDate);

        for(int i = 0; i < transactionsArray.size(); i++)
        {
            m_payment.transactionIDList.push_back(txList.at(i).transactionID);
        }
    }

    emit paymentStatusChanged(m_payment.id);
}

void MoneroPayConnection::requestPaymentStatus(QString address)
{
    const QUrl url(QString(RECEIVE_URL) + "/" + address);
    QNetworkRequest request(url);
    m_networkAccessManager->get(request);
}

int MoneroPayConnection::getID(void)
{
    return m_payment.id;
}

void MoneroPayConnection::requestPayment(void)
{
    const QUrl url(QStringLiteral(RECEIVE_URL));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    qint64 tmp = m_payment.xmrAmountInPico;
    QJsonObject obj;
    obj["amount"] = tmp;
    obj["description"] = m_payment.description;
    QJsonDocument doc(obj);
    QByteArray data = doc.toJson();

    m_networkAccessManager->post(request, data);
}

void MoneroPayConnection::replyFinished(QNetworkReply *reply) {
    QByteArray answer = reply->readAll();

    if(reply->url().toString().contains(RECEIVE_URL))
    {
        if(reply->operation() == QNetworkAccessManager::PostOperation)
        {
            response_msg_t r = parseReceivePost(answer);
            if(r.address.isEmpty())
            {
                // something is wrong
                qDebug() << "parseReceivePost returned error! " << answer;
                reply->deleteLater();
                return;
            }
            m_payment.depositAddress = r.address;
            m_payment.dateTime = r.created_at;
            m_payment.description = r.description;
            m_payment.xmrAmountInPico = r.amount;
            m_payment.paymentStatus = PAYMENT_SATUS_PENDING;
            emit depositAddressReceived(m_payment.id);
            m_requestTimer->start(SCAN_TIMEOUT_IN_MS);
        }
        else if(reply->operation() == QNetworkAccessManager::GetOperation)
        {
            // QString url = reply->url().toString();
            // QString addr = url.right(url.size() - sizeof(RECEIVE_URL));

            parseReceiveAddress(answer);
        }
    }
    else if(reply->url().toString().contains(HEALTH_URL))
    {
        QJsonDocument document;
        QJsonObject rootObj;

        document = QJsonDocument::fromJson(answer);
        rootObj = document.object();
        QJsonValue tmp = rootObj.value("status");
        if(200 == tmp.toInt())
        {
            emit healthResultReady(true);
        }
        else
        {
            emit healthResultReady(false);
        }
    }

    reply->deleteLater();
}

void MoneroPayConnection::requestPreviousPayment(void)
{
     m_requestTimer->start();
}

void MoneroPayConnection::sendRequest(void)
{
    m_requestTimer->stop();
    requestPaymentStatus(m_payment.depositAddress);
}

T_payment MoneroPayConnection::getPayment(void)
{
    return m_payment;
}

void MoneroPayConnection::setSignalDisabled(bool newStat)
{
    m_payment.signalDisabled = newStat;
}

void MoneroPayConnection::checkHealth(void)
{
    const QUrl url(QString(HEALTH_URL));
    QNetworkRequest request(url);
    m_networkAccessManager->get(request);
}
