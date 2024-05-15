#include "MoneroLWS.h"

#define ENABLE_TEST_CODE

MoneroLWS::MoneroLWS(NodoConfigParser *configParser)
{
    m_configParser = configParser;
    dbPathDirArg.append("--db-path=").append(m_configParser->getDBPathDir()).append("/light_wallet_server");

#ifdef ENABLE_TEST_CODE
    // some test values
    QString accountResult = "{\"active\":[{\"address\":\"address_1\",\"scan_height\":10001,\"access_time\":10002},{\"address\":\"address_2\",\"scan_height\":20001,\"access_time\":20002},{\"address\":\"address_3\",\"scan_height\":30001,\"access_time\":30002},{\"address\":\"address_9\",\"scan_height\":90001,\"access_time\":90002}],\"inactive\":[{\"address\":\"address_4\",\"scan_height\":40001,\"access_time\":40002},{\"address\":\"address_5\",\"scan_height\":50001,\"access_time\":50002},{\"address\":\"address_6\",\"scan_height\":60001,\"access_time\":60002}]}";
    QString requestResult = "{\"active\":[{\"address\":\"address_51\",\"scan_height\":510001},{\"address\":\"address_52\",\"scan_height\":520001},{\"address\":\"address_53\",\"scan_height\":530001}]}";

    parseAccounts(accountResult);
    parseRequests(requestResult);
#endif
}

QString MoneroLWS::callCommand(QStringList arguments)
{
    QProcess process;
    process.start(program, arguments);
    process.waitForFinished(10000);
    return QString(process.readAll());
}

void MoneroLWS::addAccount(QString address, QString privateKey)
{
#ifndef ENABLE_TEST_CODE
    QStringList arguments;
    arguments << dbPathDirArg << "add_account" << address << privateKey;
    callCommand(arguments);
    listAccounts();
#endif
}

void MoneroLWS::listAccounts(void)
{
#ifndef ENABLE_TEST_CODE
    QStringList arguments;
    arguments << dbPathDirArg << "list_accounts";
    QString result = callCommand(arguments);
    parseAccounts(result);
#endif
}

void MoneroLWS::listRequests(void)
{
#ifndef ENABLE_TEST_CODE
    QStringList arguments;
    arguments << dbPathDirArg << "list_requests";
    QString result = callCommand(arguments);
    parseRequests(result);
#endif
}

void MoneroLWS::deactivateAccount(QString address)
{
    QStringList arguments;
    arguments << dbPathDirArg << "modify_account_status" << "inactive" << address;
    callCommand(arguments);
    listAccounts();
}

void MoneroLWS::rescan(QString address, QString height)
{
    QStringList arguments;
    arguments << dbPathDirArg << "rescan" << height << address;
    callCommand(arguments);
    listAccounts();
}

void MoneroLWS::reactivateAccount(QString address)
{
    QStringList arguments;
    arguments << dbPathDirArg << "modify_account_status" << "active" << address;
    callCommand(arguments);
    listAccounts();
}

void MoneroLWS::deleteAccount(QString address)
{
    QStringList arguments;
    arguments << dbPathDirArg << "modify_account_status" << "hidden" << address;
    callCommand(arguments);
    listAccounts();
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
    QStringList arguments;
    arguments << dbPathDirArg << "accept_requests" << "create";

    for(int i = 0; m_requestAccountList.size(); i++)
    {
        arguments << m_requestAccountList.at(i).address;
    }
    callCommand(arguments);
}

void MoneroLWS::acceptRequest(QString address)
{
    QStringList arguments;
    arguments << dbPathDirArg << "accept_requests" << "create" << address;
    callCommand(arguments);
    listRequests();
}

void MoneroLWS::rejectRequest(QString address)
{
    QStringList arguments;
    arguments << dbPathDirArg << "reject_requests" << "create" << address;
    callCommand(arguments);
    listRequests();
}

void MoneroLWS::parseAccounts(QString accountsJSON)
{
    m_activeAccountList.clear();
    m_inactiveAccountList.clear();
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonArray m_activeArray;
    QJsonArray m_inactiveArray;

    m_document = QJsonDocument::fromJson(accountsJSON.toUtf8());
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

void MoneroLWS::parseRequests(QString requestsJSON)
{
    m_requestAccountList.clear();

    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonArray m_activeArray;

    m_document = QJsonDocument::fromJson(requestsJSON.toUtf8());
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
