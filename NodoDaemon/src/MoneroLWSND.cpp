#include "MoneroLWSND.h"
#include <QDebug>

MoneroLWS::MoneroLWS(QObject *parent) : QObject(parent)
{

}

QString MoneroLWS::callCommand(QStringList arguments)
{
    QProcess process;
    process.start(program, arguments);
    process.waitForFinished(10000);
    return QString(process.readAll());
}

void MoneroLWS::listAccounts(void)
{
    QStringList arguments;
    arguments << dbPathDirArg << "list_accounts";
    m_accountList.clear();
    m_accountList = callCommand(arguments);

    emit listAccountsCompleted();
}

void MoneroLWS::listRequests(void)
{
    QStringList arguments;
    arguments << dbPathDirArg << "list_requests";
    m_requestList.clear();
    m_requestList = callCommand(arguments);

    emit listRequestsCompleted();
}

void MoneroLWS::addAccount(QString address, QString privateKey)
{
    QStringList arguments;
    arguments << dbPathDirArg << "add_account" << address << privateKey;
    callCommand(arguments);
    listAccounts();
    emit accountAdded();
}

void MoneroLWS::deleteAccount(QString address)
{
    QStringList arguments;
    arguments << dbPathDirArg << "modify_account_status" << "hidden" << address;
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

void MoneroLWS::acceptAllRequests(QString requests)
{
    QStringList arguments;
    arguments << dbPathDirArg << "accept_requests" << "create";
    arguments <<requests;
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

QString MoneroLWS::getAccountList(void)
{
    return m_accountList;
}

QString MoneroLWS::getRequestList(void)
{
    return m_requestList;
}
