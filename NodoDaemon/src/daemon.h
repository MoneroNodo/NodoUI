#ifndef DAEMON_H
#define DAEMON_H

#include <QObject>
#include <QtDBus/QDBusConnection>
#include <QTimer>
#include "nodo_dbus_adaptor.h"

class Daemon : public QObject
{
    Q_OBJECT
public:
    Daemon();

public slots:
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

signals:
    void startRecoveryNotification(const QString &message);
    void serviceManagerNotification(const QString &message);
    void restartNotification(const QString &message);
    void shutdownNotification(const QString &message);
    void serviceStatusReadyNotification(const QString &message);


private:
    int m_prevIdleTime = 0;
    int m_prevTotalTime = 0;
    double m_CPUUsage = 0;
    double m_AverageCPUFreq = 0;
    double m_RAMUsage = 0;
    double m_TotalRAM = 0;
    double m_CPUTemperature = 0;
    double m_blockChainStorageUsed = 0;
    double m_blockChainStorageTotal = 0;
    double m_systemStorageUsed = 0;
    double m_systemStorageTotal = 0;

    QTimer *m_timer;

    void readCPUUsage(void);
    void readAverageCPUFreq(void);
    void readRAMUsage(void);
    void readCPUTemperature(void);
    void readBlockchainStorageUsage(void);
    void readSystemStorageUsage(void);

private slots:
    void updateParams(void);

};

#endif // DAEMON_H
