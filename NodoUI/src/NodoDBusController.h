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
    void getServiceStatus(void);


    double getCPUUsage(void);
    double getAverageCPUFreq(void);
    double getRAMUsage(void);
    double getTotalRAM(void);
    double getCPUTemperature(void);
    double getBlockchainStorageUsage(void);
    double getTotalBlockchainStorage(void);
    double getSystemStorageUsage(void);
    double getTotalSystemStorage(void);
    void setPassword(QString pw);
    double getGPUUsage(void);
    double getMaxGPUSpeed(void);
    double getCurrentGPUSpeed(void);


protected:
    void timerEvent(QTimerEvent *event);

private slots:
    void updateTextEdit(QString message);
    void updateServiceStatus(QString message);

private:
    com::moneronodo::embeddedInterface *nodo;
    bool m_dbusAdapterConnectionStatus;

signals:
    void dbusConnectionStatusChanged(void);
    void serviceStatusReceived(QString statusMessage);
    void serviceManagerNotificationReceived(QString message);
    void passwordChangeStatus(int status);
};

#endif // NODODBUSCONTROLLER_H
