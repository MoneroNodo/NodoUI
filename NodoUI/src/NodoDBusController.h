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
    void restart(void);
    void shutdown(void);
    void setBacklightLevel(int backlightLevel);
    int getBacklightLevel(void);
    void setPassword(QString pw);
    void factoryResetApproved(void);
    int getBlockchainStorageStatus(void);


protected:
    void timerEvent(QTimerEvent *event);

private:
    com::moneronodo::embeddedInterface *nodo;
    bool m_dbusAdapterConnectionStatus;

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
};

#endif // NODODBUSCONTROLLER_H
