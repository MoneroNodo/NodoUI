#include "NodoWirelessController.h"

NodoWirelessController::NodoWirelessController(QObject *parent)
    : QObject{parent}
{
    m_nmCommon = new NetworkManagerCommon();
    m_device.deviceConnType = "802-11-wireless";
    m_device.deviceType = 2;
    m_device.devicePath = "";

    m_nmCommon->findDevices(&m_device);

    m_interface = new QDBusInterface(NM_DBUS_SERVICE, m_device.devicePath, NM_DBUS_INTERFACE_DEVICE, QDBusConnection::systemBus());
    connect(m_interface, SIGNAL(StateChanged(unsigned, unsigned, unsigned)), this, SLOT(updateNetworkConfig(unsigned, unsigned, unsigned)));

    m_settingsInterface = new QDBusInterface(NM_DBUS_SERVICE, NM_DBUS_PATH_SETTINGS, NM_DBUS_INTERFACE_SETTINGS, QDBusConnection::systemBus());
    connect(m_settingsInterface, SIGNAL(NewConnection(QDBusObjectPath)), this, SLOT(newConnectionCreated(QDBusObjectPath)));

    getDeviceSpeed(&m_device);
    m_nmCommon->getDeviceState(&m_device);

    m_scanTimer = new QTimer(this);
    connect(m_scanTimer, SIGNAL(timeout()), this, SLOT(scanConnectionThread()));

    if(m_device.currentConnectionState == 100)
    {
        m_nmCommon->getIP4Params(&m_device);
    }
}

/************private functions*******************/
void NodoWirelessController::newConnectionCreated(QDBusObjectPath path)
{
    // qDebug() << "new connection detected: " << path.path();
    QDBusInterface nm(NM_DBUS_SERVICE, path.path(), NM_DBUS_INTERFACE_SETTINGS_CONNECTION, QDBusConnection::systemBus());
    QDBusReply<Connection> result = nm.call("GetSettings");

    if(result.value().contains("802-11-wireless"))
    {
        m_scanTimer->start(100);
    }
}

void NodoWirelessController::updateNetworkConfig(unsigned new_state, unsigned old_state, unsigned reason)
{
    Q_UNUSED(old_state);
    Q_UNUSED(reason);

    m_nmCommon->updateNetworkConfig(&m_device, new_state);

    if((new_state == 20) || (new_state == 30) || (new_state == 100))
    {
        emit deviceStatusChangedNotification(new_state);
    }
}

void NodoWirelessController::scanConnectionThread(void)
{
    if(m_device.currentConnectionState <=20)
    {
        return;
    }

    m_APScanStarted = true;
    emit apScanStatus();
    m_scanTimer->stop();
    getActiveConnection();
    m_nmCommon->scanSavedConnections(&m_device);
    m_nmCommon->getIP4Params(&m_device);
    requestScan();
    QTimer::singleShot(1000, this, SLOT(tmpThread()));
}

void NodoWirelessController::getDeviceSpeed(m_device_config *dev)
{
    bool ok;
    QDBusInterface nm(NM_DBUS_SERVICE, dev->devicePath, "org.freedesktop.NetworkManager.Device.Wireless", QDBusConnection::systemBus());
    dev->deviceSpeed = nm.property("Bitrate").toInt(&ok)/1000;
}

void NodoWirelessController::requestScan(void)
{
    QMap<QString, QVariant> argList;
    QDBusInterface nm(NM_DBUS_SERVICE, m_device.devicePath, NM_DBUS_INTERFACE_DEVICE_WIRELESS, QDBusConnection::systemBus());
    nm.call("RequestScan", argList);
}

void NodoWirelessController::tmpThread(void)
{
    QVector< network_parameters_t > wirelessList;
    QVector< network_parameters_t > connected;
    QVector< network_parameters_t > previouslyConnectedList;
    QVector< network_parameters_t > others;

    QDBusInterface nm(NM_DBUS_SERVICE, m_device.devicePath, NM_DBUS_INTERFACE_DEVICE_WIRELESS, QDBusConnection::systemBus());
    QDBusReply<QList<QDBusObjectPath> > ap_path_list = nm.call("GetAllAccessPoints");
    foreach (const QDBusObjectPath& p, ap_path_list.value()) {
        QDBusInterface ap(NM_DBUS_SERVICE, p.path(), NM_DBUS_INTERFACE_ACCESS_POINT, QDBusConnection::systemBus());
        if(!ap.property("Ssid").toString().isEmpty())
        {
            bool ok;
            int tmp = -1;
            network_parameters_t test;
            test.connectionName = ap.property("Ssid").toString();
            test.signalStrength = ap.property("Strength").toInt(&ok);
            test.frequency = ap.property("Frequency").toString();

            uint32_t flags = ap.property("Flags").toInt(&ok);
            uint32_t WPAFlags = ap.property("WpaFlags").toInt(&ok);
            uint32_t RSNFlags = ap.property("RsnFlags").toInt(&ok);

            if((flags & NM_802_11_AP_FLAGS_PRIVACY) && (WPAFlags == NM_802_11_AP_SEC_NONE) && (RSNFlags == NM_802_11_AP_SEC_NONE))
            {
                test.encryption = "WEP";
            }
            if(WPAFlags != NM_802_11_AP_SEC_NONE)
            {
                test.encryption = "WPA";
            }
            if(RSNFlags != NM_802_11_AP_SEC_NONE)
            {
                test.encryption = "WPA2";
            }
            if((WPAFlags & NM_802_11_AP_SEC_KEY_MGMT_802_1X) || (RSNFlags & NM_802_11_AP_SEC_KEY_MGMT_802_1X))
            {
                test.encryption = "Enterprise";
            }
            if(RSNFlags & NM_802_11_AP_SEC_KEY_MGMT_SAE)
            {
                test.encryption = "WPA3";
            }

            if(test.connectionName == m_device.activeConnectionName)
            {
                test.IP = m_device.IP;
                test.netmask = m_device.netmask;
                test.gateway = m_device.gateway;
                test.connected = true;
                test.connectedBefore = true;
                test.dbusConnectionPath = m_device.activeConnectionSettingsPath;
                connected.append(test);
                continue;
            }
            if(-1 != (tmp = m_device.connectionList.indexOf(test.connectionName)))
            {
                test.connected = false;
                test.connectedBefore = true;
                test.dbusConnectionPath = m_device.connectionPathList.at(tmp);
                previouslyConnectedList.append(test);
            }
            else
            {
                test.connected = false;
                test.connectedBefore = false;
                test.dbusConnectionPath = p.path();;
                others.append(test);
            }
        }
    }

    if(!connected.isEmpty())
    {
        wirelessList.append(connected.at(0));
    }

    if(!previouslyConnectedList.isEmpty())
    {
        for(int i = 0; i < previouslyConnectedList.size(); i++)
        {
            wirelessList.append(previouslyConnectedList.at(i));
        }
    }

    if(!others.isEmpty())
    {
        for(int i = 0; i < others.size(); i++)
        {
            wirelessList.append(others.at(i));
        }
    }

    QString AllAccessPoints;

    for(int i = 0; i < wirelessList.size(); i++)
    {
        QString accessPoint;
        accessPoint.append(wirelessList.at(i).connectionName).append(":")
                   .append(wirelessList.at(i).IP).append(":")
                   .append(wirelessList.at(i).netmask).append(":")
                   .append(wirelessList.at(i).gateway).append(":")
                   .append(wirelessList.at(i).connected?"1":"0").append(":")
                   .append(wirelessList.at(i).connectedBefore?"1":"0").append(":")
                   .append(QString::number(wirelessList.at(i).signalStrength)).append(":")
                   .append(wirelessList.at(i).encryption).append(":")
                   .append(wirelessList.at(i).frequency).append(":")
                   .append(wirelessList.at(i).dbusConnectionPath).append("\n");

        AllAccessPoints.append(accessPoint);
    }

    emit scanCompletedNotification(AllAccessPoints);
    m_APScanStarted = false;
    emit apScanStatus();
    m_scanTimer->start(10000);
}

/************public functions*******************/
void NodoWirelessController::forgetConnection(QString path)
{
    m_nmCommon->forgetConnection(path);
    m_scanTimer->start(500);
}

void NodoWirelessController::addConnection(QString profileName, QString password, bool isDHCP, QString IP, QString netmask, QString gateway, QString DNS, QString security)
{
    qDBusRegisterMetaType<Connection>();
    qDBusRegisterMetaType<QList<uint> >();
    qDBusRegisterMetaType<QList<QList<uint> > >();
    Connection connection;

    // Build up the 'connection' Setting
    connection["connection"]["uuid"] = QUuid::createUuid().toString().remove('{').remove('}');
    connection["connection"]["id"] = profileName;
    connection["connection"]["type"] = "802-11-wireless";

    connection["802-11-wireless"]["mode"] = "infrastructure";
    connection["802-11-wireless"]["ssid"] = QVariant(profileName.toLatin1());

    qDebug() << "Wireless security: " << security;
    if(security == "WEP" || security.isEmpty())
    {
        connection["802-11-wireless-security"]["key-mgmt"] = "none";
        connection["802-11-wireless-security"]["wep-key-type"] = 2;
        connection["802-11-wireless-security"]["wep-key0"] = password;
    }
    else if(security == "WPA2")
    {
        connection["802-11-wireless-security"]["key-mgmt"] = "wpa-psk";
        connection["802-11-wireless-security"]["psk"] = password;
    }
    else if(security == "WPA3")
    {
        connection["802-11-wireless-security"]["key-mgmt"] = "sae";
        connection["802-11-wireless-security"]["psk"] = password;
    }

    if(isDHCP)
    {
        connection["ipv4"]["method"] = "auto";
    }
    else
    {
        QList<QList<uint> > addresses;
        QList<uint> addr1, addr2;
        addr1 << htonl(QHostAddress(IP).toIPv4Address()) << m_nmCommon->calculatePrefix(netmask) << htonl(QHostAddress(gateway).toIPv4Address());
        addr2 << htonl(QHostAddress(gateway).toIPv4Address());
        addresses << addr1;

        connection["ipv4"]["method"] = "manual";
        connection["ipv4"]["addresses"] = QVariant::fromValue(addresses);
        connection["ipv4"]["dns"] = QVariant::fromValue(addr2);
    }

    // Call AddConnection
    QDBusReply<QDBusObjectPath> result = m_settingsInterface->call("AddConnection", QVariant::fromValue(connection));
}

void NodoWirelessController::activateConnection(QString connectionPath)
{
    m_nmCommon->activateConnection(&m_device, connectionPath);
}

void NodoWirelessController::deactivateConnection(void)
{
    m_nmCommon->deactivateConnection(m_device.activeConnectionPath);
}

void NodoWirelessController::getActiveConnection(void)
{
    m_nmCommon->getActiveConnection(&m_device);
}

void NodoWirelessController::scanAccessPoints(void)
{
    if (!m_detailsOpened)
        m_scanTimer->start(0);
}

unsigned NodoWirelessController::getDeviceConnectionStatus(void)
{
    return m_device.currentConnectionState;
}

void NodoWirelessController::enableWireless(bool enable)
{
    QDBusInterface nm(NM_DBUS_SERVICE, NM_DBUS_PATH, "org.freedesktop.NetworkManager", QDBusConnection::systemBus());
    nm.setProperty("WirelessEnabled", enable);
}

QString NodoWirelessController::getIP(void)
{
    return m_device.IP;
}

bool NodoWirelessController::getAPScanStatus(void)
{
    return m_APScanStarted;
}

void NodoWirelessController::stopScan(void)
{
    m_detailsOpened = true;
    m_scanTimer->stop();
}

void NodoWirelessController::startScan(void)
{
    m_detailsOpened = false;
    m_scanTimer->start(0);
}

void NodoWirelessController::requestConnectionStateUpdate(void)
{
    m_nmCommon->getDeviceState(&m_device);
}
