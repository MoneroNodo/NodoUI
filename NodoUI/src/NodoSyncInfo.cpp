#include "NodoSyncInfo.h"

NodoSyncInfo::NodoSyncInfo(QObject *parent) : QObject{parent} {
    manager = new QNetworkAccessManager();
    connect(manager, &QNetworkAccessManager::finished, this, &NodoSyncInfo::ReplyFinished);
}

void NodoSyncInfo::updateRequested()
{
    if(isUpdateRequested)
    {
        return;
    }

    const QUrl url(QStringLiteral("http://127.0.0.1:18081/json_rpc"));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject obj;
    obj["jsonrpc"] = "2.0";
    obj["id"] = "0";
    obj["method"] = "sync_info";
    QJsonDocument doc(obj);
    QByteArray data = doc.toJson();
    manager->post(request, data);

    isUpdateRequested = true;
}

void NodoSyncInfo::ReplyFinished(QNetworkReply *reply) {
    QJsonDocument document;
    QJsonObject rootObj;
    QJsonObject resultObj;

    QString answer = reply->readAll();

    document = QJsonDocument::fromJson(answer.toUtf8());
    rootObj = document.object();
    resultObj = rootObj["result"].toObject();
    m_height = resultObj.value("height").toInt();
    m_targetHeight = resultObj.value("target_height").toInt();

    isUpdateRequested = false;
    if(m_targetHeight > 0)
    {
        m_syncPercentage = (int)(((double)m_height/(double)m_targetHeight)*100);
    }
    else
    {
        m_syncPercentage = -1;
    }

    if(100 == m_syncPercentage)
    {
        emit syncDone();
    }

    emit syncStatusReady();
}

int NodoSyncInfo::getSyncPercentage(void)
{
    if(m_targetHeight == 0)
    {
        return -1;
    }

    return m_syncPercentage;
}


void NodoSyncInfo::startSyncStatusUpdate(void)
{
    updateRequested();
}

