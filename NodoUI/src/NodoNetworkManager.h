#ifndef NODONETWORKMANAGER_H
#define NODONETWORKMANAGER_H

#include <QObject>
#include <QTimer>
#include "NodoNotificationMessages.h"
#include "NodoWiredController.h"
#include "NodoWirelessController.h"
#include "NodoDBusController.h"

#define PING_PERIOD 7*1000

typedef enum {
    NM_STATUS_WAITING,
    NM_STATUS_CONNECTED,
    NM_STATUS_NO_INTERNET,
    NM_STATUS_DISCONNECTED,
} network_status_t;

class NodoNetworkManager : public QObject
{
    Q_OBJECT

public:
    explicit NodoNetworkManager(NodoDBusController *dbusController = Q_NULLPTR);
    Q_INVOKABLE void checkNetworkStatusAndIP(void);
    Q_INVOKABLE QString getNetworkIP(void);
    Q_INVOKABLE bool isConnected(void);

    Q_INVOKABLE void forgetWirelessNetwork(QString connectionPath);
    Q_INVOKABLE int getWifiDeviceStatus(void);
    Q_INVOKABLE void setWifiDeviceStatus(bool wifiDeviceStatus);
    Q_INVOKABLE int getSSIDListSize(void);
    Q_INVOKABLE int getSSIDSignalStrength(int index);
    Q_INVOKABLE QString getSSIDName(int index);
    Q_INVOKABLE double getSSIDFrequency(int index);
    Q_INVOKABLE QString getSSIDEncryptionType(int index);
    Q_INVOKABLE void disconnectFromWiFi(void);
    Q_INVOKABLE bool isWiFiConnectedBefore(int index);
    Q_INVOKABLE void activateWiFi(QString path);
    Q_INVOKABLE void connectToWiFi(QString ssidName, QString password, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS, QString security);
    Q_INVOKABLE void startWifiScan(void);
    Q_INVOKABLE void stopWifiScan(void);
    Q_INVOKABLE QString getConnectedSSIDName(void);
    Q_INVOKABLE QString getConnectedSSIDIP(void);
    Q_INVOKABLE QString getConnectedSSIDGateway(void);
    Q_INVOKABLE QString getConnectedSSIDEncryptionType(void);
    Q_INVOKABLE int getConnectedSSIDSignalStrength(void);
    Q_INVOKABLE double getConnectedSSIDFrequency(void);
    Q_INVOKABLE bool isConnectedSSIDAvailable(void);
    Q_INVOKABLE QString getConnectedSSIDConnectionPath(void);
    Q_INVOKABLE QString getSSIDConnectionPath(int index);
    Q_INVOKABLE bool getAPScanStatus(void);


    Q_INVOKABLE void forgetWiredNetwork(QString connectionPath);
    Q_INVOKABLE int getEthernetDeviceStatus(void);
    Q_INVOKABLE void setEthernetDeviceStatus(bool ethDeviceStatus);
    Q_INVOKABLE int getEthernetConnectionListSize(void);
    Q_INVOKABLE QString getEthernetConnectionName(int index);
    Q_INVOKABLE void disconnectFromEthernet(void);
    Q_INVOKABLE bool isEthernetConnectedBefore(int index);
    Q_INVOKABLE void activateEthernetConnection(int index);
    Q_INVOKABLE void connectToEthernet(QString connectionName, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS);
    Q_INVOKABLE void startEthScan(void);
    Q_INVOKABLE void stopEthScan(void);
    Q_INVOKABLE QString getConnectedEthernetProfileName(void);
    Q_INVOKABLE QString getConnectedEthernetIP(void);
    Q_INVOKABLE QString getConnectedEthernetGateway(void);
    Q_INVOKABLE bool isConnectedEthernetProfileAvailable(void);
    Q_INVOKABLE QString ethernetConnectionSpeed(void);
    Q_INVOKABLE QString getConnectedEthernetConnectionPath(void);

    Q_INVOKABLE int getErrorCode(void);
    Q_INVOKABLE QString getErrorMessage(void);

    Q_INVOKABLE QString getEthernetConnectionPath(int index);

    Q_INVOKABLE QString getNetworkConnectionStatus(void);

signals:
    void iPReady(void);
    void networkStatusChanged(void);
    void networkConnStatusReceived(bool netConnStat);

    void wifiScanCopleted(void);
    void wifiDeviceStatusChanged(void);
    void connectedSSIDParamsUpdated(void);
    void aPScanStatusReceived(void);

    void ethernetScanCopleted(void);
    void ethernetDeviceStatusChanged(void);
    void connectedEthernetParamsUpdated(void);
    void errorDetected(void);
    void wiredConnectionProfileCreated(void);
    void connectionStatusChanged(void);


private:
    QString m_networkIP;
    bool isConnectedNetworkAvailable = false;

    int m_errorCode;
    NodoNotifier m_notifier;

    NodoWirelessController *m_wireless;
    unsigned m_wirelessDeviceConnectionStatus = 0;
    network_parameters_t m_wirelessActiveConnection;
    QVector< network_parameters_t > m_wirelessScanList;

    NodoWiredController *m_wired;
    unsigned m_wiredDeviceConnectionStatus = 0;
    network_parameters_t m_wiredActiveConnection;
    QVector< network_parameters_t > m_wiredScanList;

    network_status_t m_nmstat = NM_STATUS_DISCONNECTED;
    NodoDBusController *m_dbusController;

    network_status_t m_connStat;
    QStringList statusMessageList = { tr("Waiting"), tr("Connected"), tr("No Internet"), tr("Disconnected")};

private slots:

    void parseWirelessNetworkList(QString networkList);
    void processWirelessDeviceStatus(unsigned wifiDeviceStatus);

    void parseWiredNetworkList(QString networkList);
    void processWiredDeviceStatus(unsigned ethDeviceStatus);
    void updateNetworkConnectionStatus(void);
};

#endif // NODONETWORKMANAGER_H
