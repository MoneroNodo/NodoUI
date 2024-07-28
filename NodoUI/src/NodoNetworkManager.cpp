#include "NodoNetworkManager.h"

NodoNetworkManager::NodoNetworkManager(QObject *parent)
{
    Q_UNUSED(parent);
    m_wired = new NodoWiredController();
    m_wireless = new NodoWirelessController();

    connect(m_wired, SIGNAL(deviceStatusChangedNotification(uint)), this, SLOT(processWiredDeviceStatus(uint)));
    connect(m_wired, SIGNAL(scanCompletedNotification(QString)), this, SLOT(parseWiredNetworkList(QString)));
    connect(m_wired, SIGNAL(connectionProfileCreated()), this, SIGNAL(wiredConnectionProfileCreated()));

    connect(m_wireless, SIGNAL(deviceStatusChangedNotification(uint)), this, SLOT(processWirelessDeviceStatus(uint)));
    connect(m_wireless, SIGNAL(scanCompletedNotification(QString)), this, SLOT(parseWirelessNetworkList(QString)));
    connect(m_wireless, SIGNAL(apScanStatus()), this, SIGNAL(aPScanStatusReceived()));

    m_wirelessActiveConnection.connected = false;
    m_wiredActiveConnection.connected = false;

    getEthernetDeviceStatus();
    getWifiDeviceStatus();


    if((m_wiredDeviceConnectionStatus == 100) || (m_wirelessDeviceConnectionStatus == 100))
    {
        checkNetworkStatusAndIP();
    }

    if((m_wiredDeviceConnectionStatus == 30) || (m_wiredDeviceConnectionStatus == 100))
    {
        m_wired->scanConnections();
    }

    if((m_wirelessDeviceConnectionStatus == 30) || (m_wirelessDeviceConnectionStatus == 100))
    {
        m_wireless->scanAccessPoints();
    }
}

void NodoNetworkManager::processWirelessDeviceStatus(unsigned wifiDeviceStatus)
{
    m_wirelessDeviceConnectionStatus = wifiDeviceStatus;

    if(m_wirelessDeviceConnectionStatus > 20)
    {
        m_wireless->scanAccessPoints();
    }

    checkNetworkStatusAndIP();
    emit wifiDeviceStatusChanged();
}

int NodoNetworkManager::getWifiDeviceStatus(void)
{
    m_wirelessDeviceConnectionStatus = m_wireless->getDeviceConnectionStatus();
    return m_wirelessDeviceConnectionStatus;
}

void NodoNetworkManager::setWifiDeviceStatus(bool wifiDeviceStatus)
{
    m_wireless->enableWireless(wifiDeviceStatus);
}

void NodoNetworkManager::checkNetworkStatusAndIP(void)
{
    m_networkIP.clear();
    bool tmpConnState = true;

    QString wirelessIP = m_wireless->getIP();
    QString wiredIP = m_wired->getIP();

    if(wirelessIP.isEmpty() && wiredIP.isEmpty())
    {
        tmpConnState = false;
        m_networkIP = "nan";
    }

    if(!wiredIP.isEmpty())
    {
        m_networkIP = wiredIP;
    }
    else if(!wirelessIP.isEmpty())
    {
        m_networkIP = wirelessIP;
    }

    emit iPReady();

    if(tmpConnState != isConnectedNetworkAvailable)
    {
        isConnectedNetworkAvailable = tmpConnState;
        emit networkStatusChanged();
    }
}

bool NodoNetworkManager::isConnected(void)
{
    return isConnectedNetworkAvailable;
}

QString NodoNetworkManager::getNetworkIP(void)
{
    return m_networkIP;
}

void NodoNetworkManager::parseWirelessNetworkList(QString networkList)
{
    m_wirelessScanList.clear();
    m_wirelessActiveConnection.connectionName.clear();
    m_wirelessActiveConnection.IP.clear();
    m_wirelessActiveConnection.netmask.clear();
    m_wirelessActiveConnection.gateway.clear();
    m_wirelessActiveConnection.connected = false;
    m_wirelessActiveConnection.connectedBefore = false;
    m_wirelessActiveConnection.signalStrength = -1;
    m_wirelessActiveConnection.encryption.clear();
    m_wirelessActiveConnection.frequency = 0;

    QStringList SSIDs = networkList.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < SSIDs.size(); i++)
    {
        QStringList SSID_params = SSIDs[i].split(":");
        bool ok;
        network_parameters_t test;
        test.connectionName = SSID_params[0];
        test.IP = SSID_params[1];
        test.netmask = SSID_params[2];
        test.gateway = SSID_params[3];
        test.connected = (bool)SSID_params[4].toInt(&ok, 10);
        test.connectedBefore = (bool)SSID_params[5].toInt(&ok, 10);
        test.signalStrength = SSID_params[6].toInt(&ok, 10);
        test.encryption = SSID_params[7];
        test.frequency = SSID_params[8];
        test.dbusConnectionPath = SSID_params[9];

        if(!test.connected)
        {
            m_wirelessScanList.append(test);
        }
        else
        {
            m_wirelessActiveConnection.connectionName = test.connectionName;
            m_wirelessActiveConnection.IP = test.IP;
            m_wirelessActiveConnection.netmask = test.netmask;
            m_wirelessActiveConnection.gateway = test.gateway;
            m_wirelessActiveConnection.connected = test.connected;
            m_wirelessActiveConnection.connectedBefore = test.connectedBefore;
            m_wirelessActiveConnection.signalStrength = test.signalStrength;
            m_wirelessActiveConnection.encryption = test.encryption;
            m_wirelessActiveConnection.frequency = test.frequency;
            m_wirelessActiveConnection.dbusConnectionPath = test.dbusConnectionPath;
        }
    }

    emit connectedSSIDParamsUpdated();
    emit wifiScanCopleted();
}

int NodoNetworkManager::getSSIDListSize(void)
{
    return m_wirelessScanList.size();
}

int NodoNetworkManager::getSSIDSignalStrength(int index)
{
    return m_wirelessScanList.at(index).signalStrength;
}

QString NodoNetworkManager::getSSIDName(int index)
{
    return m_wirelessScanList.at(index).connectionName;
}

double NodoNetworkManager::getSSIDFrequency(int index)
{
    bool ok;
    QStringList fields = m_wirelessScanList.at(index).frequency.split(" ");
    return QString(fields[0]).toDouble(&ok);
}

QString NodoNetworkManager::getSSIDEncryptionType(int index)
{
    return m_wirelessScanList.at(index).encryption;
}

void NodoNetworkManager::disconnectFromWiFi()
{
    m_wireless->deactivateConnection();
}

bool NodoNetworkManager::isWiFiConnectedBefore(int index)
{
    return m_wirelessScanList.at(index).connectedBefore;
}

void NodoNetworkManager::activateWiFi(QString path)
{
    m_wireless->activateConnection(path);
}

void NodoNetworkManager::connectToWiFi(QString ssidName, QString password, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS, QString security)
{
    m_wireless->addConnection(ssidName, password, DHCP, IP, netmask, gateway, DNS, security);
}

void NodoNetworkManager::startWifiScan(void)
{
    m_wireless->startScan();
}

void NodoNetworkManager::stopWifiScan(void)
{
    m_wireless->stopScan();
}

void NodoNetworkManager::forgetWiredNetwork(QString connectionPath)
{
    m_wired->forgetConnection(connectionPath);
}

void NodoNetworkManager::forgetWirelessNetwork(QString connectionPath)
{
    m_wireless->forgetConnection(connectionPath);
}

bool NodoNetworkManager::isConnectedSSIDAvailable(void)
{
    return m_wirelessActiveConnection.connected;
}

QString NodoNetworkManager::getConnectedSSIDName(void)
{
    return m_wirelessActiveConnection.connectionName;
}

QString NodoNetworkManager::getConnectedSSIDIP(void)
{
    return m_wirelessActiveConnection.IP;
}

QString NodoNetworkManager::getConnectedSSIDGateway(void)
{
    return m_wirelessActiveConnection.gateway;
}

QString NodoNetworkManager::getConnectedSSIDEncryptionType(void)
{
    return m_wirelessActiveConnection.encryption;
}

int NodoNetworkManager::getConnectedSSIDSignalStrength(void)
{
    return m_wirelessActiveConnection.signalStrength;
}

double NodoNetworkManager::getConnectedSSIDFrequency(void)
{
    bool ok;
    QStringList fields = m_wirelessActiveConnection.frequency.split(" ");
    return QString(fields[0]).toDouble(&ok);
}

void NodoNetworkManager::startEthScan(void)
{
    m_wired->scanConnections();
}

void NodoNetworkManager::stopEthScan(void)
{
}

int NodoNetworkManager::getEthernetDeviceStatus(void)
{
    m_wiredDeviceConnectionStatus = m_wired->getDeviceConnectionStatus();
    return m_wiredDeviceConnectionStatus;
}

void NodoNetworkManager::setEthernetDeviceStatus(bool ethDeviceStatus)
{
    Q_UNUSED(ethDeviceStatus);
}

int NodoNetworkManager::getEthernetConnectionListSize(void)
{
    return m_wiredScanList.size();
}

QString NodoNetworkManager::getEthernetConnectionName(int index)
{
    return m_wiredScanList.at(index).connectionName;
}

void NodoNetworkManager::disconnectFromEthernet(void)
{
    m_wired->deactivateConnection();
}

bool NodoNetworkManager::isEthernetConnectedBefore(int index)
{
    return m_wiredScanList.at(index).connectedBefore;
}

void NodoNetworkManager::activateEthernetConnection(int index)
{
    m_wired->activateConnection(index);
}

void NodoNetworkManager::connectToEthernet(QString connectionName, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS)
{
    m_wired->addConnection(connectionName, DHCP, IP, netmask, gateway, DNS);
}

QString NodoNetworkManager::getConnectedEthernetProfileName(void)
{
    return m_wiredActiveConnection.connectionName;
}

QString NodoNetworkManager::getConnectedEthernetIP(void)
{
    return m_wiredActiveConnection.IP;
}

QString NodoNetworkManager::getConnectedEthernetGateway(void)
{
    return m_wiredActiveConnection.gateway;
}

bool NodoNetworkManager::isConnectedEthernetProfileAvailable(void)
{
    return m_wiredActiveConnection.connected;
}

int NodoNetworkManager::getErrorCode(void)
{
    return m_errorCode;
}

QString NodoNetworkManager::getErrorMessage(void)
{
    return m_notifier.getMessageText((m_messageIDs)m_errorCode);
}

QString NodoNetworkManager::ethernetConnectionSpeed(void)
{
    return QString::number(m_wired->getDeviceSpeed()).append(" MBit/s");
}

void NodoNetworkManager::parseWiredNetworkList(QString networkList)
{
    m_wiredScanList.clear();
    m_wiredActiveConnection.connectionName.clear();
    m_wiredActiveConnection.IP.clear();
    m_wiredActiveConnection.netmask.clear();
    m_wiredActiveConnection.gateway.clear();
    m_wiredActiveConnection.connected = false;
    m_wiredActiveConnection.connectedBefore = false;
    m_wiredActiveConnection.dbusConnectionPath.clear();

    QStringList ehtConnList = networkList.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < ehtConnList.size(); i++)
    {
        QStringList eth_params = ehtConnList[i].split(":");

        bool ok;
        network_parameters_t test;
        test.connectionName = eth_params[0];
        test.IP = eth_params[1];
        test.netmask = eth_params[2];
        test.gateway = eth_params[3];
        test.connected = (bool)eth_params[4].toInt(&ok, 10);
        test.connectedBefore = (bool)eth_params[5].toInt(&ok, 10);
        test.dbusConnectionPath = eth_params[6];

        if(!test.connected)
        {
            m_wiredScanList.append(test);
        }
        else
        {
            m_wiredActiveConnection.connectionName = test.connectionName;
            m_wiredActiveConnection.IP = test.IP;
            m_wiredActiveConnection.netmask = test.netmask;
            m_wiredActiveConnection.gateway = test.gateway;
            m_wiredActiveConnection.connected = test.connected;
            m_wiredActiveConnection.connectedBefore = test.connectedBefore;
            m_wiredActiveConnection.dbusConnectionPath = test.dbusConnectionPath;
        }
    }

    emit connectedEthernetParamsUpdated();
    emit ethernetScanCopleted();
}

void NodoNetworkManager::processWiredDeviceStatus(unsigned ethDeviceStatus)
{
    m_wiredDeviceConnectionStatus = ethDeviceStatus;
    checkNetworkStatusAndIP();
    emit ethernetDeviceStatusChanged();
}

QString NodoNetworkManager::getEthernetConnectionPath(int index)
{
    return m_wiredScanList.at(index).dbusConnectionPath;
}

QString NodoNetworkManager::getConnectedEthernetConnectionPath(void)
{
    return m_wiredActiveConnection.dbusConnectionPath;
}

QString NodoNetworkManager::getConnectedSSIDConnectionPath(void)
{
    return m_wirelessActiveConnection.dbusConnectionPath;
}

QString NodoNetworkManager::getSSIDConnectionPath(int index)
{
    return m_wirelessScanList.at(index).dbusConnectionPath;
}

bool NodoNetworkManager::getAPScanStatus(void)
{
    return m_wireless->getAPScanStatus();
}
