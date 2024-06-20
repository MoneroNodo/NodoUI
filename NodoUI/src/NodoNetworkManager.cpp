#include "NodoNetworkManager.h"

NodoNetworkManager::NodoNetworkManager(QObject *parent)
    : QObject{parent}
{
    nm = new com::moneronodo::embeddedNetworkInterface("com.monero.nodonm", "/com/monero/nodonm", QDBusConnection::systemBus(), this);

    connect(nm, SIGNAL(networkConfigurationChangedNotification()), this, SLOT(updateNetworkConfig()));

    connect(nm, SIGNAL(wifiDeviceStatusChangedNotification(bool)), this, SLOT(processWifiDeviceStatus(bool)));
    connect(nm, SIGNAL(wifiScanCompletedNotification(QString)), this, SLOT(parseWifiNetworkList(QString)));

    m_wifiDeviceStatus = nm->GetWiFiStatus();
    m_ethernetDeviceStatus = nm->GetEthernetStatus();

    m_connectedWifiParams.connected = false;
    m_connectedEthernetParams.connected = false;

    m_stopWifiScanRequested = false;
    m_stopEthScanRequested = false;
}

void NodoNetworkManager::processWifiDeviceStatus(bool wifiDeviceStatus)
{
    m_wifiDeviceStatus = wifiDeviceStatus;
    emit wifiDeviceStatusChanged();
}

bool NodoNetworkManager::getWifiDeviceStatus(void)
{
    return m_wifiDeviceStatus;
}

void NodoNetworkManager::setWifiDeviceStatus(bool wifiDeviceStatus)
{
    if(m_wifiDeviceStatus != wifiDeviceStatus)
    {
        nm->enableWiFi(wifiDeviceStatus);
        m_wifiDeviceStatus = wifiDeviceStatus;
    }
}

void NodoNetworkManager::requestNetworkIP(void)
{
    updateNetworkConfig();
}

QString NodoNetworkManager::getNetworkIP(void)
{
    return m_networkIP;
}

void NodoNetworkManager::updateNetworkConfig(void)
{
    m_networkIP.clear();
    QString nmConfig = nm->getConnectedDeviceConfig();
    if(!nmConfig.isEmpty())
    {
        QStringList params = nmConfig.split("\n", Qt::SkipEmptyParts);
        if(params.count() != 3)
        {
            m_errorCode = CONNECTION_TO_NODONM_DBUS_FAILED;
            emit errorDetected();
            return;
        }
        else
        {
            m_networkIP = params.at(0);
        }
    }

    emit networkConnStatusReady();
}

void NodoNetworkManager::parseWifiNetworkList(QString networkList)
{
    m_wifiScanList.clear();
    m_connectedWifiParams.connectionName.clear();
    m_connectedWifiParams.IP.clear();
    m_connectedWifiParams.netmask.clear();
    m_connectedWifiParams.gateway.clear();
    m_connectedWifiParams.connected = false;
    m_connectedWifiParams.connectedBefore = false;
    m_connectedWifiParams.signalStrength = -1;
    m_connectedWifiParams.encryption.clear();
    m_connectedWifiParams.frequency = 0;

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

        if(!test.connected)
        {
            m_wifiScanList.append(test);
        }
        else
        {
            m_connectedWifiParams.connectionName = test.connectionName;
            m_connectedWifiParams.IP = test.IP;
            m_connectedWifiParams.netmask = test.netmask;
            m_connectedWifiParams.gateway = test.gateway;
            m_connectedWifiParams.connected = test.connected;
            m_connectedWifiParams.connectedBefore = test.connectedBefore;
            m_connectedWifiParams.signalStrength = test.signalStrength;
            m_connectedWifiParams.encryption = test.encryption;
            m_connectedWifiParams.frequency = test.frequency;
        }
    }

    if(!m_stopWifiScanRequested)
    {
        emit connectedSSIDParamsUpdated();
        emit wifiScanCopleted();
    }
}

int NodoNetworkManager::getSSIDListSize(void)
{
    return m_wifiScanList.size();
}

int NodoNetworkManager::getSSIDSignalStrength(int index)
{
    return m_wifiScanList.at(index).signalStrength;
}

QString NodoNetworkManager::getSSIDName(int index)
{
    return m_wifiScanList.at(index).connectionName;
}

double NodoNetworkManager::getSSIDFrequency(int index)
{
    bool ok;
    QStringList fields = m_wifiScanList.at(index).frequency.split(" ");
    return QString(fields[0]).toDouble(&ok);
}

QString NodoNetworkManager::getSSIDEncryptionType(int index)
{
    return m_wifiScanList.at(index).encryption;
}

void NodoNetworkManager::disconnectFromWiFi()
{
    nm->disconnectFromWiFi(m_connectedWifiParams.connectionName);
}

bool NodoNetworkManager::isWiFiConnectedBefore(int index)
{
    return m_wifiScanList.at(index).connectedBefore;
}

void NodoNetworkManager::activateWiFi(QString ssidName)
{
    nm->activateWiFi(ssidName);
}

void NodoNetworkManager::connectToWiFi(QString ssidName, QString password, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS)
{
    nm->connectToWiFi(ssidName, password, DHCP, IP, netmask, gateway, DNS);
}

void NodoNetworkManager::startWifiScan(void)
{
    m_stopWifiScanRequested = false;
}

void NodoNetworkManager::stopWifiScan(void)
{
    m_stopWifiScanRequested = true;
}

void NodoNetworkManager::forgetNetwork(QString connectionName)
{
    nm->forgetNetwork(connectionName);
}

bool NodoNetworkManager::isConnectedSSIDAvailable(void)
{
    return m_connectedWifiParams.connected;
}

QString NodoNetworkManager::getConnectedSSIDName(void)
{
    return m_connectedWifiParams.connectionName;
}

QString NodoNetworkManager::getConnectedSSIDIP(void)
{
    return m_connectedWifiParams.IP;
}

QString NodoNetworkManager::getConnectedSSIDGateway(void)
{
    return m_connectedWifiParams.gateway;
}

QString NodoNetworkManager::getConnectedSSIDEncryptionType(void)
{
    return m_connectedWifiParams.encryption;
}

int NodoNetworkManager::getConnectedSSIDSignalStrength(void)
{
    return m_connectedWifiParams.signalStrength;
}

double NodoNetworkManager::getConnectedSSIDFrequency(void)
{
    bool ok;
    QStringList fields = m_connectedWifiParams.frequency.split(" ");
    return QString(fields[0]).toDouble(&ok);
}


void NodoNetworkManager::parseEthernetNetworkList(QString networkList)
{
    m_ethernetScanList.clear();
    m_connectedEthernetParams.connectionName.clear();
    m_connectedEthernetParams.IP.clear();
    m_connectedEthernetParams.netmask.clear();
    m_connectedEthernetParams.gateway.clear();
    m_connectedEthernetParams.connected = false;
    m_connectedEthernetParams.connectedBefore = false;

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

        if(!test.connected)
        {
            m_ethernetScanList.append(test);
        }
        else
        {
            m_connectedEthernetParams.connectionName = test.connectionName;
            m_connectedEthernetParams.IP = test.IP;
            m_connectedEthernetParams.netmask = test.netmask;
            m_connectedEthernetParams.gateway = test.gateway;
            m_connectedEthernetParams.connected = test.connected;
            m_connectedEthernetParams.connectedBefore = test.connectedBefore;
        }
    }

    if(!m_stopEthScanRequested)
    {
        emit connectedEthernetParamsUpdated();
        emit ethernetScanCopleted();
    }
}

void NodoNetworkManager::startEthScan(void)
{
    m_stopEthScanRequested = false;
}

void NodoNetworkManager::stopEthScan(void)
{
    m_stopEthScanRequested = true;
}

void NodoNetworkManager::processEthernetDeviceStatus(bool ethDeviceStatus)
{
    m_ethernetDeviceStatus = ethDeviceStatus;
    emit ethernetDeviceStatusChanged();
}

bool NodoNetworkManager::getEthernetDeviceStatus(void)
{
    return m_ethernetDeviceStatus;
}

void NodoNetworkManager::setEthernetDeviceStatus(bool ethDeviceStatus)
{
    if(m_ethernetDeviceStatus != ethDeviceStatus)
    {
        nm->enableWiFi(ethDeviceStatus);
        m_ethernetDeviceStatus = ethDeviceStatus;
    }
}

int NodoNetworkManager::getEthernetConnectionListSize(void)
{
    return m_ethernetScanList.size();
}

QString NodoNetworkManager::getEthernetConnectionName(int index)
{
    return m_ethernetScanList.at(index).connectionName;
}

void NodoNetworkManager::disconnectFromEthernet(void)
{
    nm->disconnectFromEthernet(m_connectedEthernetParams.connectionName);
}

bool NodoNetworkManager::isEthernetConnectedBefore(int index)
{
    return m_ethernetScanList.at(index).connectedBefore;
}

void NodoNetworkManager::activateEthernetConnection(QString connectionName)
{
    nm->activateEthernetConnection(connectionName);
}

void NodoNetworkManager::connectToEthernet(QString connectionName, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS)
{
    nm->connectToEthernet(connectionName, DHCP, IP, netmask, gateway, DNS);
}

QString NodoNetworkManager::getConnectedEthernetProfileName(void)
{
    return m_connectedEthernetParams.connectionName;
}

QString NodoNetworkManager::getConnectedEthernetIP(void)
{
    return m_connectedEthernetParams.IP;
}

QString NodoNetworkManager::getConnectedEthernetGateway(void)
{
    return m_connectedEthernetParams.gateway;
}

bool NodoNetworkManager::isConnectedEthernetProfileAvailable(void)
{
    return m_connectedEthernetParams.connected;
}

int NodoNetworkManager::getErrorCode(void)
{
    return m_errorCode;
}

QString NodoNetworkManager::getErrorMessage(void)
{
    return m_notifier.getMessageText((m_messageIDs)m_errorCode);
}
