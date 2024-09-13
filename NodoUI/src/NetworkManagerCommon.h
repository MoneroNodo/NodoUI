#ifndef NETWORKMANAGERCOMMON_H
#define NETWORKMANAGERCOMMON_H

#include <QObject>
#include <QTimer>
#include <QtDBus>
#include <QThread>
#include <QStringList>
#include <QtNetwork/QHostAddress>

#include <arpa/inet.h>

#define NM_DBUS_SERVICE                        "org.freedesktop.NetworkManager"
#define NM_DBUS_INTERFACE_SETTINGS             "org.freedesktop.NetworkManager.Settings"
#define NM_DBUS_INTERFACE_SETTINGS_CONNECTION  "org.freedesktop.NetworkManager.Settings.Connection"
#define NM_DBUS_PATH_SETTINGS                  "/org/freedesktop/NetworkManager/Settings"
#define NM_DBUS_PROPERTIES                     "org.freedesktop.DBus.Properties"

#define NM_DBUS_INTERFACE                      "org.freedesktop.NetworkManager"
#define NM_DBUS_INTERFACE_ACCESS_POINT         NM_DBUS_INTERFACE ".AccessPoint"
#define NM_DBUS_INTERFACE_ACTIVE_CONNECTION    NM_DBUS_INTERFACE ".Connection.Active"
#define NM_DBUS_INTERFACE_CHECKPOINT           NM_DBUS_INTERFACE ".Checkpoint"
#define NM_DBUS_INTERFACE_DEVICE               NM_DBUS_INTERFACE ".Device"
#define NM_DBUS_INTERFACE_DEVICE_BLUETOOTH     NM_DBUS_INTERFACE_DEVICE ".Bluetooth"
#define NM_DBUS_INTERFACE_DEVICE_WIRED         NM_DBUS_INTERFACE_DEVICE ".Wired"
#define NM_DBUS_INTERFACE_DEVICE_WIRELESS      NM_DBUS_INTERFACE_DEVICE ".Wireless"
#define NM_DBUS_INTERFACE_DHCP4_CONFIG         NM_DBUS_INTERFACE ".DHCP4Config"
#define NM_DBUS_INTERFACE_DHCP6_CONFIG         NM_DBUS_INTERFACE ".DHCP6Config"
#define NM_DBUS_INTERFACE_IP4_CONFIG           NM_DBUS_INTERFACE ".IP4Config"
#define NM_DBUS_INTERFACE_IP6_CONFIG           NM_DBUS_INTERFACE ".IP6Config"

#define NM_DBUS_PATH                           "/org/freedesktop/NetworkManager"
#define NM_DBUS_PATH_ACCESS_POINT              NM_DBUS_PATH "/AccessPoint"


typedef enum { /*< underscore_name=nm_802_11_ap_security_flags, flags >*/
               NM_802_11_AP_SEC_NONE            = 0x00000000,
               NM_802_11_AP_SEC_PAIR_WEP40      = 0x00000001,
               NM_802_11_AP_SEC_PAIR_WEP104     = 0x00000002,
               NM_802_11_AP_SEC_PAIR_TKIP       = 0x00000004,
               NM_802_11_AP_SEC_PAIR_CCMP       = 0x00000008,
               NM_802_11_AP_SEC_GROUP_WEP40     = 0x00000010,
               NM_802_11_AP_SEC_GROUP_WEP104    = 0x00000020,
               NM_802_11_AP_SEC_GROUP_TKIP      = 0x00000040,
               NM_802_11_AP_SEC_GROUP_CCMP      = 0x00000080,
               NM_802_11_AP_SEC_KEY_MGMT_PSK    = 0x00000100,
               NM_802_11_AP_SEC_KEY_MGMT_802_1X = 0x00000200,
               NM_802_11_AP_SEC_KEY_MGMT_SAE    = 0x00000400,
} NM80211ApSecurityFlags;

typedef enum { /*< underscore_name=nm_802_11_ap_flags, flags >*/
               NM_802_11_AP_FLAGS_NONE    = 0x00000000,
               NM_802_11_AP_FLAGS_PRIVACY = 0x00000001,
               NM_802_11_AP_FLAGS_WPS     = 0x00000002,
               NM_802_11_AP_FLAGS_WPS_PBC = 0x00000004,
               NM_802_11_AP_FLAGS_WPS_PIN = 0x00000008,
} NM80211ApFlags;


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
    QString dbusConnectionPath;
}network_parameters_t;

typedef struct {
    int deviceType;
    QString devicePath;
    QString deviceConnType;
    QString IP4ConfigPath;
    QString activeConnectionPath;
    QString activeConnectionName;
    QString activeConnectionSettingsPath;
    QStringList connectionList;
    QStringList connectionPathList;
    int currentConnectionState;
    QString IP;
    QString gateway;
    QString netmask;
    int deviceSpeed;
} m_device_config;


typedef QMap<QString, QMap<QString, QVariant> > Connection;
Q_DECLARE_METATYPE(Connection)

class NetworkManagerCommon : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManagerCommon(QObject *parent = nullptr);

    int calculatePrefix(QString netmask);
    QString calculateNetmask(int prefix);
    void getIP4Params(m_device_config *dev);
    void findDevices(m_device_config *wired_dev);
    void updateNetworkConfig(m_device_config *dev, unsigned int new_state);
    void getDeviceState(m_device_config *dev);
    void scanSavedConnections(m_device_config *dev);
    void deactivateConnection(QString activeConnPath);
    void getActiveConnection(m_device_config *dev);
    void activateConnection(m_device_config *dev, QString connectionPath);
    void forgetConnection(QString path);



signals:
};

#endif // NETWORKMANAGERCOMMON_H
