#ifndef NODODBUSCONTROLLER_H
#define NODODBUSCONTROLLER_H

#include <QObject>
#include <QTimer>

#include "nodo_dbus_interface.h"


class NodoDBusController : public QObject
{
    Q_OBJECT
public:
    explicit NodoDBusController(QObject *parent = nullptr);
    bool isConnected(void);
    void startRecovery(int recoverFS, int rsyncBlockchain);
    void serviceManager(QString operation, QString service);
    void update(void);
    void restart(void);
    void shutdown(void);
    void setBacklightLevel(int backlightLevel);
    int getBacklightLevel(void);
    void setPassword(QString pw);
    void changePassword(QString oldPassword, QString newPassword);
    void factoryResetApproved(void);
    int getBlockchainStorageStatus(void);

    void moneroLWSAddAccount(QString address, QString privateKey);
    void moneroLWSDeleteAccount(QString address);
    void moneroLWSReactivateAccount(QString address);
    void moneroLWSDeactivateAccount(QString address);

    void moneroLWSRescan(QString address, QString height);
    void moneroLWSAcceptAllRequests(QString requests);
    void moneroLWSAcceptRequest(QString address);
    void moneroLWSRejectRequest(QString address);

    QString moneroLWSGetAccountList(void);
    QString moneroLWSGetRequestList(void);

    void moneroLWSListAccounts(void);
    void moneroLWSListRequests(void);

    int getNetworkConnectionStatus(void);

protected:
    void timerEvent(QTimerEvent *event);

private:
    com::moneronodo::embeddedInterface *nodo;
    bool m_dbusAdapterConnectionStatus = false;

signals:
    void dbusConnectionStatusChanged(void);
    void serviceStatusReceived(QString statusMessage);
    void serviceManagerNotificationReceived(QString message);
    void hardwareStatusReadyNotification(const QString &message);
    void passwordChangeStatus(int status);

    void factoryResetStarted(void);
    void factoryResetRequested(void);
    void factoryResetCompleted(void);
    void powerButtonPressDetected(void);
    void powerButtonReleaseDetected(void);

    void moneroLWSListAccountsCompleted(void);
    void moneroLWSListRequestsCompleted(void);
    void moneroLWSAccountAdded(void);

    void networkConnectionStatusChanged(void);
};

#endif // NODODBUSCONTROLLER_H
