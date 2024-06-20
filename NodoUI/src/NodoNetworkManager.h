#ifndef NODONETWORKMANAGER_H
#define NODONETWORKMANAGER_H

#include <QObject>
#include <QTimer>

#include "nodo_nm_interface.h"
typedef struct
{
    QString connectionName;
    QString IP;
    QString netmask;
    QString gateway;
    bool connected;
    bool connectedBefore;
    bool statusChanged;
    int signalStrength;
    QString encryption;
    QString frequency;
}network_parameters_t;

typedef struct
{
    QString ip;
    QString netmask;
    QString broadcast;
    bool connected;
    bool statusChanged;
}network_config_t;

class NodoNetworkManager : public QObject
{
    Q_OBJECT

public:
    explicit NodoNetworkManager(QObject *parent = Q_NULLPTR);
    Q_INVOKABLE void requestNetworkIP(void);
    Q_INVOKABLE QString getNetworkIP(void);
    Q_INVOKABLE void forgetNetwork(QString connectionName);

    Q_INVOKABLE bool getWifiDeviceStatus(void);
    Q_INVOKABLE void setWifiDeviceStatus(bool wifiDeviceStatus);
    Q_INVOKABLE int getSSIDListSize(void);
    Q_INVOKABLE int getSSIDSignalStrength(int index);
    Q_INVOKABLE QString getSSIDName(int index);
    Q_INVOKABLE double getSSIDFrequency(int index);
    Q_INVOKABLE QString getSSIDEncryptionType(int index);
    Q_INVOKABLE void disconnectFromWiFi(void);
    Q_INVOKABLE bool isWiFiConnectedBefore(int index);
    Q_INVOKABLE void activateWiFi(QString ssidName);
    Q_INVOKABLE void connectToWiFi(QString ssidName, QString password, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS);
    Q_INVOKABLE void startWifiScan(void);
    Q_INVOKABLE void stopWifiScan(void);
    Q_INVOKABLE QString getConnectedSSIDName(void);
    Q_INVOKABLE QString getConnectedSSIDIP(void);
    Q_INVOKABLE QString getConnectedSSIDGateway(void);
    Q_INVOKABLE QString getConnectedSSIDEncryptionType(void);
    Q_INVOKABLE int getConnectedSSIDSignalStrength(void);
    Q_INVOKABLE double getConnectedSSIDFrequency(void);
    Q_INVOKABLE bool isConnectedSSIDAvailable(void);


    Q_INVOKABLE bool getEthernetDeviceStatus(void);
    Q_INVOKABLE void setEthernetDeviceStatus(bool ethDeviceStatus);
    Q_INVOKABLE int getEthernetConnectionListSize(void);
    Q_INVOKABLE QString getEthernetConnectionName(int index);
    Q_INVOKABLE void disconnectFromEthernet(void);
    Q_INVOKABLE bool isEthernetConnectedBefore(int index);
    Q_INVOKABLE void activateEthernetConnection(QString connectionName);
    Q_INVOKABLE void connectToEthernet(QString connectionName, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS);
    Q_INVOKABLE void startEthScan(void);
    Q_INVOKABLE void stopEthScan(void);
    Q_INVOKABLE QString getConnectedEthernetProfileName(void);
    Q_INVOKABLE QString getConnectedEthernetIP(void);
    Q_INVOKABLE QString getConnectedEthernetGateway(void);
    Q_INVOKABLE bool isConnectedEthernetProfileAvailable(void);

signals:
    void networkConnStatusReady(void);

    void wifiScanCopleted(void);
    void wifiDeviceStatusChanged();
    void connectedSSIDParamsUpdated();

    void ethernetScanCopleted(void);
    void ethernetDeviceStatusChanged();
    void connectedEthernetParamsUpdated();

private:
    com::moneronodo::embeddedNetworkInterface *nm;
    QString m_networkIP;

    bool m_wifiDeviceStatus = false;
    QVector< network_parameters_t > m_wifiScanList;
    network_parameters_t m_connectedWifiParams;
    bool m_stopWifiScanRequested = false;

    bool m_ethernetDeviceStatus = false;
    QVector< network_parameters_t > m_ethernetScanList;
    network_parameters_t m_connectedEthernetParams;
    bool m_stopEthScanRequested = false;

private slots:
    void updateNetworkConfig(void);

    void processWifiDeviceStatus(bool wifiDeviceStatus);
    void parseWifiNetworkList(QString networkList);

    void processEthernetDeviceStatus(bool ethDeviceStatus);
    void parseEthernetNetworkList(QString networkList);
};

#endif // NODONETWORKMANAGER_H
