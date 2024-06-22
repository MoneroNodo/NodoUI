#include <QNetworkAccessManager>
#include "NodoSystemStatusParser.h"


/*
 * original source code can be found here:
 * https://stackoverflow.com/questions/46943134/how-do-i-write-a-qt-http-get-request
*/

NodoSystemStatusParser::NodoSystemStatusParser(NodoConfigParser *configParser) : QObject(configParser) {
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &NodoSystemStatusParser::replyFinished);
    m_manager->get(QNetworkRequest(QUrl(m_system_url)));

    m_configParser = configParser;

    m_timer = new QTimer(this);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updateStatus()));

    connect(m_configParser, SIGNAL(configParserReady()), this, SLOT(updateConfigParameters()));
}

void NodoSystemStatusParser::replyFinished(QNetworkReply *reply) {
    QString answer = reply->readAll();
    if(!answer.isEmpty())
    {
        m_document = QJsonDocument::fromJson(answer.toUtf8());
        m_rootObj = m_document.object();
    }
    else
    {
        m_document = QJsonDocument();
        m_rootObj = QJsonObject();
    }
    emit systemStatusReady();
}

QString NodoSystemStatusParser::getStringValueFromKey(QString key)
{
    if(m_rootObj.isEmpty())
    {
        return "na";
    }
    QJsonValue jsonValue = m_rootObj.value(key);
    return jsonValue.toString();
}

int NodoSystemStatusParser::getIntValueFromKey(QString key)
{
    if(m_rootObj.isEmpty())
    {
        return -1;
    }
    QJsonValue jsonValue = m_rootObj.value(key);
    return jsonValue.toInt();
}

bool NodoSystemStatusParser::getBoolValueFromKey(QString key)
{
    if(m_rootObj.isEmpty())
    {
        return false;
    }
    QJsonValue jsonValue = m_rootObj.value(key);
    return jsonValue.toBool();
}

void NodoSystemStatusParser::updateStatus(void)
{
    m_manager->get(QNetworkRequest(QUrl(m_system_url)));
}

void NodoSystemStatusParser::updateRequested(void)
{
    m_timer->stop();
    updateStatus();
    m_timer->start(5000);
}

void NodoSystemStatusParser::updateConfigParameters(void)
{
    int port = m_configParser->getIntValueFromKey("config", "monero_public_port");
    m_system_url.clear();
    m_system_url = "http://127.0.0.1:" + QString::number(port) + "/get_info";
}
