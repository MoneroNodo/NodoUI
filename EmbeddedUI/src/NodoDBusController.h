#ifndef NODODBUSCONTROLLER_H
#define NODODBUSCONTROLLER_H

#include <QObject>
#include <QTimer>

#include "nodo_embedded_interface.h"


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


protected:
    void timerEvent(QTimerEvent *event);

private slots:
    void updateTextEdit(QString message);
    void updateServiceStatus(QString message);

private:
    com::moneronodo::embeddedInterface *nodo;
    bool m_connectionStatus;

signals:
    void connectionStatusChanged(void);
    void serviceStatusReceived(QString statusMessage);
};

#endif // NODODBUSCONTROLLER_H
