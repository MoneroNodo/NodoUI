#ifndef DAEMON_H
#define DAEMON_H


#include <QTimer>
#include <QObject>
#include <QProcess>
#include <QHostAddress>
#include <QNetworkInterface>
#include <QtDBus/QDBusConnection>
#include <arpa/inet.h>

#include <QDebug>

#include "nodo_nm_adaptor.h"

#if 1
#define WIFI_DEVICE_NAME "wlan0"
#define ETHERNET_DEVICE_NAME "eth0"
#else
#define WIFI_DEVICE_NAME "wlo1"
#define ETHERNET_DEVICE_NAME "enxf8e43bdcaba0"
#endif

typedef struct
{
    QString SSID;
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


class NodoNetworkManager : public QObject
{
    Q_OBJECT
public:
    NodoNetworkManager();

public slots:
    /***************general controls**********************/
    QString getConnectedDeviceConfig(void);
    void forgetNetwork(QString connectionName);
    bool isAvtiveConnectionAvailable(void);

    /***************wifi controls*************************/
    void enableWiFi(bool enable);
    bool GetWiFiStatus(void);
    void connectToWiFi(QString ssid, QString password, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS);
    void activateWiFi(QString ssid);
    void disconnectFromWiFi(QString ssid);


    /***************ethernet controls**********************/
    void enableEthernet(bool enable);
    bool GetEthernetStatus(void);
    void connectToEthernet(QString connectionName, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS);
    void activateEthernetConnection(QString connectionName);
    void disconnectFromEthernet(QString connectionName);


signals:
    /***************general controls**********************/
    void networkConfigurationChangedNotification(bool netConnStat);

    /***************wifi controls*************************/
    void wifiDeviceStatusChangedNotification(bool devStatus);
    void wifiScanCompletedNotification(const QString &message);

    /***************ethernet controls**********************/
    void ethDeviceStatusChangedNotification(bool devStatus);
    void ethScanCompletedNotification(const QString &message);

private:
    /***************general controls**********************/
    QTimer *m_networkTimer;
    QProcess *m_networkProcess;
    QMutex m_readNetworkConfigurationsMutex;

    /***************wifi controls*************************/
    bool m_isWifiEnabled = false;
    network_parameters_t wifi_config;
    QString m_ssidList;

    /***************ethernet controls**********************/
    network_parameters_t ethernet_config;
    bool m_isEthernetEnabled = false;
    QString m_ethernetList;

    /***************general controls**********************/
    QString callnmcli(QStringList arguments);
    QString callip(QStringList arguments);
    int calculatePrefix(QString netmask);
    QString calculateNetmask(int prefix);
    void readNetworkConfig(QString device, network_parameters_t *nmp);
    void readNetworkConfigurations(void);

    /***************wifi controls*************************/
    QString listSavedWifiNetworks(void);
    QString createWifiNetworkList(QString wifiList);
    void scanWifiNetworks(void);

    /***************ethernet controls**********************/
    QString createEthernetNetworkList(void);
    void scanEthernetNetworks(void);

private slots:
    /***************general controls**********************/
    void runScanNetworks(void);

};

#endif // DAEMON_H
