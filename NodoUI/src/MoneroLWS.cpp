#include "MoneroLWS.h"

MoneroLWS::MoneroLWS(NodoDBusController *dbusController)
{
    m_dbusController = dbusController;

    connect(m_dbusController, SIGNAL(dbusConnectionStatusChanged()), this, SLOT(updateDbusConnectionStatus()));
    connect(m_dbusController, SIGNAL(moneroLWSListAccountsCompleted()), this, SLOT(parseAccounts()));
    connect(m_dbusController, SIGNAL(moneroLWSListRequestsCompleted()), this, SLOT(parseRequests()));
    connect(m_dbusController, SIGNAL(moneroLWSAccountAdded()), this, SIGNAL(accountAdded()));
}

void MoneroLWS::updateDbusConnectionStatus(void)
{
    bool isConnected = m_dbusController->isConnected();
    if(m_dbusConnectionStatus == isConnected)
    {
        return;
    }

    m_dbusConnectionStatus = isConnected;

    emit dbusConnectionStatusChanged(m_dbusConnectionStatus);
}

bool MoneroLWS::getDbusConnectionStatus(void)
{
    return m_dbusConnectionStatus;
}

void MoneroLWS::addAccount(QString address, QString privateKey)
{
    m_dbusController->moneroLWSAddAccount(address, privateKey);
}

void MoneroLWS::listAccounts(void)
{
    m_dbusController->moneroLWSListAccounts();
}

void MoneroLWS::listRequests(void)
{
    m_dbusController->moneroLWSListRequests();
}

void MoneroLWS::deactivateAccount(QString address)
{
    m_dbusController->moneroLWSDeactivateAccount(address);
}

void MoneroLWS::rescan(QString address, QString height)
{
    m_dbusController->moneroLWSRescan(address, height);
}

void MoneroLWS::reactivateAccount(QString address)
{
    m_dbusController->moneroLWSReactivateAccount(address);
}

void MoneroLWS::deleteAccount(QString address)
{
    m_dbusController->moneroLWSDeleteAccount(address);
}

bool MoneroLWS::isListAccountsCompleted(void)
{
    return m_listAccountsStatus;
}

bool MoneroLWS::isListRequestsCompleted(void)
{
    return m_listRequestsStatus;
}

int MoneroLWS::getRequestAccountSize(void)
{
    return m_requestAccountList.size();
}

QString MoneroLWS::getRequestAccountAddress(int index)
{
    return m_requestAccountList.at(index).address;
}

int MoneroLWS::getRequestAccountScanHeight(int index)
{
    return m_requestAccountList.at(index).scanHeight;
}

void MoneroLWS::acceptAllRequests(void)
{
    QString requests;
    for(int i = 0; m_requestAccountList.size(); i++)
    {
        requests.append(m_requestAccountList.at(i).address).append(" ");
    }

    m_dbusController->moneroLWSAcceptAllRequests(requests);
}

void MoneroLWS::acceptRequest(QString address)
{
    m_dbusController->moneroLWSAcceptRequest(address);
}

void MoneroLWS::rejectRequest(QString address)
{
    m_dbusController->moneroLWSRejectRequest(address);
}

void MoneroLWS::parseAccounts(void)
{
    QString accounts = m_dbusController->moneroLWSGetAccountList();

    if(accounts.isEmpty())
    {
        return;
    }

    m_activeAccountList.clear();
    m_inactiveAccountList.clear();
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonArray m_activeArray;
    QJsonArray m_inactiveArray;

    m_document = QJsonDocument::fromJson(accounts.toUtf8());
    m_rootObj = m_document.object();
    m_activeArray = m_rootObj["active"].toArray();
    m_inactiveArray = m_rootObj["inactive"].toArray();

    for(int i = 0; i < m_activeArray.size(); i++)
    {
        account_parameters_t param;
        QJsonObject obj = m_activeArray.at(i).toObject();
        param.address = obj.value("address").toString();
        param.accessTime = obj.value("access_time").toInt();
        param.scanHeight = obj.value("scan_height").toInt();
        m_activeAccountList.push_back(param);
    }

    for(int i = 0; i < m_inactiveArray.size(); i++)
    {
        account_parameters_t param;
        QJsonObject obj = m_inactiveArray.at(i).toObject();
        param.address = obj.value("address").toString();
        param.accessTime = obj.value("access_time").toInt();
        param.scanHeight = obj.value("scan_height").toInt();
        m_inactiveAccountList.push_back(param);
    }

    m_listAccountsStatus = true;
    emit listAccountsCompleted();
}

void MoneroLWS::parseRequests(void)
{
    QString requests = m_dbusController->moneroLWSGetAccountList();

    if(requests.isEmpty())
    {
        return;
    }

    m_requestAccountList.clear();

    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonArray m_activeArray;

    m_document = QJsonDocument::fromJson(requests.toUtf8());
    m_rootObj = m_document.object();
    m_activeArray = m_rootObj["active"].toArray();

    for(int i = 0; i < m_activeArray.size(); i++)
    {
        account_parameters_t param;
        QJsonObject obj = m_activeArray.at(i).toObject();
        param.address = obj.value("address").toString();
        param.scanHeight = obj.value("scan_height").toInt();
        m_requestAccountList.push_back(param);
    }

    m_listRequestsStatus = true;
    emit listRequestsCompleted();
}

int MoneroLWS::getActiveAccountSize(void)
{
    return m_activeAccountList.size();
}

int MoneroLWS::getInactiveAccountSize(void)
{
    return m_inactiveAccountList.size();
}

QString MoneroLWS::getActiveAccountAddress(int index)
{
    return m_activeAccountList.at(index).address;
}

int MoneroLWS::getActiveAccountScanHeight(int index)
{
    return m_activeAccountList.at(index).scanHeight;
}

int MoneroLWS::getActiveAccountAccessTime(int index)
{
    return m_activeAccountList.at(index).accessTime;
}

QString MoneroLWS::getInactiveAccountAddress(int index)
{
    return m_inactiveAccountList.at(index).address;
}

int MoneroLWS::getInactiveAccountScanHeight(int index)
{
    return m_inactiveAccountList.at(index).scanHeight;
}
int MoneroLWS::getInactiveAccountAccessTime(int index)
{
    return m_inactiveAccountList.at(index).accessTime;
}
