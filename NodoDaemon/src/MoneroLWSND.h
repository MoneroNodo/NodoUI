#ifndef MONEROLWSND_H
#define MONEROLWSND_H

#include <QObject>
#include <QProcess>

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
    explicit MoneroLWS(QObject *parent = nullptr);
    void listAccounts(void);
    void listRequests(void);
    void addAccount(QString address, QString privateKey);
    void deactivateAccount(QString address);
    void rescan(QString address, QString height);
    void reactivateAccount(QString address);
    void deleteAccount(QString address);
    void acceptAllRequests(QString requests);
    void acceptRequest(QString address);
    void rejectRequest(QString address);
    QString getAccountList(void);
    QString getRequestList(void);


private:
    QString program = "/home/nodo/bin/monero-lws-admin";
    QString dbPathDirArg = "--db-path=/media/monero/bitmonero/light_wallet_server";

    QString m_accountList;
    QString m_requestList;

    QString callCommand(QStringList arguments);

signals:
    void listAccountsCompleted();
    void listRequestsCompleted();
    void accountAdded();

};

#endif // MONEROLWSND_H
