#ifndef MONEROLWS_H
#define MONEROLWS_H

#include <QObject>
#include <QProcess>
#include "NodoConfigParser.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

typedef struct
{
    QString address;
    int scanHeight;
    int accessTime;
}account_parameters_t;


class MoneroLWS : public QObject
{
    Q_OBJECT

public:
    explicit MoneroLWS(NodoConfigParser *configParser = Q_NULLPTR);
    Q_INVOKABLE void listAccounts(void);
    Q_INVOKABLE bool isListAccountsCompleted(void);
    Q_INVOKABLE int getActiveAccountSize(void);
    Q_INVOKABLE int getInactiveAccountSize(void);
    Q_INVOKABLE QString getActiveAccountAddress(int index);
    Q_INVOKABLE int getActiveAccountScanHeight(int index);
    Q_INVOKABLE int getActiveAccountAccessTime(int index);
    Q_INVOKABLE QString getInactiveAccountAddress(int index);
    Q_INVOKABLE int getInactiveAccountScanHeight(int index);
    Q_INVOKABLE int getInactiveAccountAccessTime(int index);

    Q_INVOKABLE void deactivateAccount(QString address);
    Q_INVOKABLE void rescan(QString address, QString height);

    Q_INVOKABLE void addAccount(QString address, QString privateKey);

    Q_INVOKABLE void reactivateAccount(QString address);
    Q_INVOKABLE void deleteAccount(QString address);

    Q_INVOKABLE void listRequests(void);
    Q_INVOKABLE bool isListRequestsCompleted(void);
    Q_INVOKABLE int getRequestAccountSize(void);
    Q_INVOKABLE QString getRequestAccountAddress(int index);
    Q_INVOKABLE int getRequestAccountScanHeight(int index);

    Q_INVOKABLE void acceptAllRequests(void);
    Q_INVOKABLE void acceptRequest(QString address);
    Q_INVOKABLE void rejectRequest(QString address);



private:
    QString program = "/home/nodo/monero-lws/build/src/monero-lws-admin";
    QString dbPathDirArg;
    NodoConfigParser *m_configParser;
    QVector< account_parameters_t > m_activeAccountList;
    QVector< account_parameters_t > m_inactiveAccountList;
    QVector< account_parameters_t > m_requestAccountList;

    bool m_listAccountsStatus = false;
    bool m_listRequestsStatus = false;

    QString callCommand(QStringList arguments);
    void parseAccounts(QString accountsJSON);
    void parseRequests(QString requestsJSON);

signals:
    void listAccountsCompleted(void);
    void listRequestsCompleted(void);

};

#endif // MONEROLWS_H
