#ifndef NODOWIRELESSCONTROLLER_H
#define NODOWIRELESSCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QtDBus>
#include <QMutex>
#include <QThread>
#include <QStringList>
#include <QtNetwork/QHostAddress>

#include "NetworkManagerCommon.h"

class NodoWirelessController : public QObject
{
    Q_OBJECT
public:
    explicit NodoWirelessController(QObject *parent = nullptr);
    void forgetConnection(QString path);
    void addConnection(QString profileName, QString password, bool isDHCP, QString IP, QString netmask, QString gateway, QString DNS, QString security);
    void activateConnection(QString connectionPath);
    void deactivateConnection(void);
    unsigned getDeviceConnectionStatus(void);
    void scanAccessPoints(void);
    void enableWireless(bool enable);
    QString getIP(void);
    bool getAPScanStatus(void);
    void stopScan(void);
    void startScan(void);


signals:
    void deviceStatusChangedNotification(unsigned devStatus);
    void scanCompletedNotification(QString networkList);
    void apScanStatus(void);

private:
    NetworkManagerCommon *m_nmCommon;
    QDBusInterface *m_interface;
    QDBusInterface *m_settingsInterface;
    m_device_config m_device;
    QTimer *m_scanTimer;
    bool m_APScanStarted = false;
    QTimer *m_timer;

    void getActiveConnection(void);
    void getDeviceSpeed(m_device_config *dev);
    void requestScan(void);


private slots:
    void updateNetworkConfig(unsigned int new_state, unsigned int old_state, unsigned int reason);
    void scanConnectionThread(void);
    void tmpThread(void);
    void newConnectionCreated(QDBusObjectPath path);
    void initiate(void);
};


#endif // NODOWIRELESSCONTROLLER_H
