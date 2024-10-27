#ifndef NODOWIREDCONTROLLER_H
#define NODOWIREDCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QtDBus>
#include <QThread>
#include <QStringList>
#include <QtNetwork/QHostAddress>

#include "NetworkManagerCommon.h"

class NodoWiredController : public QObject
{
    Q_OBJECT
public:
    explicit NodoWiredController(QObject *parent = nullptr);

    void forgetConnection(QString path);
    void addConnection(QString profileName, bool isDHCP, QString IP, QString netmask, QString gateway, QString DNS);
    void activateConnection(int connectionIndex);
    void deactivateConnection(void);
    unsigned getDeviceConnectionStatus(void);
    void scanConnections(void);
    int getDeviceSpeed(void);
    QString getIP(void);
    void requestConnectionStateUpdate(void);


signals:
    void deviceStatusChangedNotification(unsigned devStatus);
    void scanCompletedNotification(QString networkList);
    void connectionProfileCreated(void);

private:
    NetworkManagerCommon *m_nmCommon;
    QDBusInterface *m_interface;
    m_device_config m_device;

    void getActiveConnection(void);
    QString packageConnections(void);
    void getDeviceSpeed(m_device_config *dev);



private slots:
    void updateNetworkConfig(unsigned int new_state, unsigned int old_state, unsigned int reason);
    void scanConnectionsThread(void);
    void updateThread(void);
};

#endif // NODOWIREDCONTROLLER_H
