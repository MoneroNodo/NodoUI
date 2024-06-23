#include "NodoDbusNetworkManager.h"


NodoNetworkManager::NodoNetworkManager()
{
    new EmbeddedNetworkInterfaceAdaptor(this);
    QDBusConnection connection = QDBusConnection::systemBus();
    connection.registerObject("/com/monero/nodonm", this);
    connection.registerService("com.monero.nodonm");

    m_networkProcess = new QProcess();
    getNetforkDeviceNames();
    GetWiFiStatus();

    m_networkTimer = new QTimer(this);
    connect(m_networkTimer, SIGNAL(timeout()), this, SLOT(runScanNetworks()));
    m_networkTimer->start(0);
}

/***************general controls**********************/
int NodoNetworkManager::calculatePrefix(QString netmask)
{
    QByteArray ba = netmask.toLocal8Bit();
    const char *network = ba.data();

    int n;
    inet_pton(AF_INET, network, &n);
    int i = 0;

    while (n > 0) {
        n = n >> 1;
        i++;
    }

    return i;
}

QString NodoNetworkManager::calculateNetmask(int prefix)
{
    unsigned long mask = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    return QString().append(QString::number(mask >> 24)).append(".").
        append(QString::number((mask >> 16) & 0xFF)).append(".").
        append(QString::number((mask >> 8) & 0xFF)).append(".").
        append(QString::number(mask & 0xFF));
}

QString NodoNetworkManager::callnmcli(QStringList arguments)
{
    QString program = "/usr/bin/nmcli";

    m_networkProcess->start(program, arguments);
    m_networkProcess->waitForFinished(-1);
    return QString(m_networkProcess->readAll());
}

QString NodoNetworkManager::callip(QStringList arguments)
{
    QString program = "/usr/bin/ip";

    m_networkProcess->start(program, arguments);
    m_networkProcess->waitForFinished(-1);
    return QString(m_networkProcess->readAll());
}

void NodoNetworkManager::readNetworkConfig(QString device, network_parameters_t *nmp)
{
    QStringList arguments;

    nmp->SSID.clear();
    nmp->connected = false;
    nmp->IP.clear();
    nmp->netmask.clear();
    nmp->gateway.clear();

    arguments << "-t" << "dev" << "show" << device;

    QString result = callnmcli(arguments);
    QStringList sl = result.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < sl.size(); i++)
    {
        QStringList params = sl[i].split(":");
        if(params[0] == "GENERAL.STATE")
        {
            QStringList sl = params[1].split(" ");
            if(sl[0] == "100") //connected
            {
                nmp->connected = true;
            }
            else
            {
                nmp->connected = false;
                return;
            }
        }

        if(params[0] == "GENERAL.CONNECTION")
        {
            if(params[1] != "--")
            {
                nmp->SSID = params[1];
            }
        }

        if(params[0] == "IP4.ADDRESS[1]")
        {
            bool ok;
            QStringList sl = params[1].split("/");
            nmp->IP = sl[0];
            nmp->netmask = calculateNetmask(sl[1].toInt(&ok));
        }

        if(params[0] == "IP4.GATEWAY")
        {
            if(params[1] != "--")
            {
                nmp->gateway = params[1];
            }
        }
    }
}

void NodoNetworkManager::readNetworkConfigurations(void)
{
    bool isConfigChanged = false;
    network_parameters_t tmp_wifi, tmp_ethernet;
    readNetworkConfig(m_wifi_dev_name, &tmp_wifi);
    readNetworkConfig(m_eth_dev_name, &tmp_ethernet);

    if((wifi_config.connected != tmp_wifi.connected) || (wifi_config.gateway != tmp_wifi.gateway) || (wifi_config.IP != tmp_wifi.IP) || (wifi_config.netmask != tmp_wifi.netmask))
    {
        wifi_config.statusChanged = true;
        wifi_config.SSID = tmp_wifi.SSID;
        wifi_config.connected = tmp_wifi.connected;
        wifi_config.IP = tmp_wifi.IP;
        wifi_config.netmask = tmp_wifi.netmask;
        wifi_config.gateway = tmp_wifi.gateway;
        isConfigChanged = true;
    }

    if((ethernet_config.connected != tmp_ethernet.connected) || (ethernet_config.gateway != tmp_ethernet.gateway) || (ethernet_config.IP != tmp_ethernet.IP) || (ethernet_config.netmask != tmp_ethernet.netmask))
    {
        ethernet_config.statusChanged = true;
        ethernet_config.SSID = tmp_ethernet.SSID;
        ethernet_config.connected = tmp_ethernet.connected;
        ethernet_config.IP = tmp_ethernet.IP;
        ethernet_config.netmask = tmp_ethernet.netmask;
        ethernet_config.gateway = tmp_ethernet.gateway;
        isConfigChanged = true;
    }

    if(true == isConfigChanged)
    {
        emit networkConfigurationChangedNotification(ethernet_config.connected | wifi_config.connected);
    }
}

void NodoNetworkManager::getNetforkDeviceNames(void)
{
    QStringList arguments;
    int cnt = 0;
    arguments << "-t" << "-f" << "GENERAL.TYPE,GENERAL.DEVICE" << "device" << "show";

    QString result = callnmcli(arguments);

    while(result.isEmpty())
    {
        cnt++;
        QThread::sleep(1);
        result = callnmcli(arguments);
        if(cnt >= 5)
        {
            m_eth_dev_name = "eth0";
            m_wifi_dev_name = "wlan0";

            return;
        }
    }


    QStringList sl = result.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < sl.size(); i++)
    {
        QStringList params = sl[i].split(":");
        if(params[0] == "GENERAL.TYPE")
        {
            if(params[1] == "wifi")
            {
                QStringList params2 = sl[i+1].split(":");
                if(params2[0] == "GENERAL.DEVICE")
                {
                    m_wifi_dev_name = params2[1];
                    continue;
                }
            }
            else if(params[1] == "ethernet")
            {
                QStringList params2 = sl[i+1].split(":");
                if(params2[0] == "GENERAL.DEVICE")
                {
                    m_eth_dev_name = params2[1];
                    continue;
                }
            }
        }
    }

    if(m_eth_dev_name.isEmpty())
    {
        m_eth_dev_name = "eth0";
    }

    if(m_wifi_dev_name.isEmpty())
    {
        m_wifi_dev_name = "wlan0";
    }

    qDebug() << "m_wifi_dev_name: " << m_wifi_dev_name << ";m_eth_dev_name: " << m_eth_dev_name;
}

QString NodoNetworkManager::getConnectedDeviceConfig(void)
{
    QString retVal;
    if(ethernet_config.connected) //ethernet connection has higher priority
    {
        retVal.append(ethernet_config.IP).append("\n").append(ethernet_config.netmask).append("\n").append(ethernet_config.gateway);
    }
    else if(wifi_config.connected)
    {
        retVal.append(wifi_config.IP).append("\n").append(wifi_config.netmask).append("\n").append(wifi_config.gateway);
    }

    return retVal;
}

void NodoNetworkManager::forgetNetwork(QString connectionName)
{
    QStringList arguments;
    arguments << "connection" << "delete" << "id" << connectionName;
    callnmcli(arguments);
    m_networkTimer->start(0);
}

void NodoNetworkManager::runScanNetworks(void)
{
    m_networkTimer->stop();

    readNetworkConfigurations();
    scanWifiNetworks();
    scanEthernetNetworks();

    m_networkTimer->start(5000);
}

bool NodoNetworkManager::isAvtiveConnectionAvailable(void)
{
    return (ethernet_config.connected | wifi_config.connected);
}

/***************wifi controls*************************/
void NodoNetworkManager::enableWiFi(bool enable)
{
    QStringList arguments;

    arguments << "radio" << "wifi";
    if(enable)
    {
        arguments << "on";
    }
    else
    {
        arguments << "off";
    }

    QString result = callnmcli(arguments);
    qDebug() << "enableWiFi result: " << result;
    GetWiFiStatus();
}

bool NodoNetworkManager::GetWiFiStatus(void)
{
    QStringList arguments;

    arguments << "radio" << "wifi";

    QString result = callnmcli(arguments);

    if(result.contains("enabled"))
    {
        m_isWifiEnabled = true;
    }
    else
    {
        m_isWifiEnabled = false;
    }
    qDebug() << "wifi enabled status: " << m_isWifiEnabled;

    emit wifiDeviceStatusChangedNotification(m_isWifiEnabled);

    return m_isWifiEnabled;
}

QString NodoNetworkManager::listSavedWifiNetworks(void)
{
    QString savedNetworks;
    QStringList arguments;
    arguments << "-t" << "-f" << "DEVICE,NAME,TYPE" << "con" << "show";

    QString result = callnmcli(arguments);

    QStringList connections = result.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < connections.size(); i++)
    {
        QStringList connection_params = connections[i].split(":");
        if("802-11-wireless" == connection_params[2])
        {
            savedNetworks.append(connection_params[1]).append("\n");
        }
    }
    return savedNetworks;
}

QString NodoNetworkManager::createWifiNetworkList(QString wifiList)
{
    QVector< network_parameters_t > m_wifiList;
    QStringList SSIDs = wifiList.split("\n", Qt::SkipEmptyParts);
    QString savedWifiNetworks = listSavedWifiNetworks();
    QStringList prevConnList = savedWifiNetworks.split("\n", Qt::SkipEmptyParts);

    QVector< network_parameters_t > connected;
    QVector< network_parameters_t > previouslyConnectedList;
    QVector< network_parameters_t > others;

    for(int i = 0; i < SSIDs.size(); i++)
    {
        QStringList SSID_params = SSIDs[i].split(":");
        network_parameters_t test;

        if(SSID_params[1].isEmpty()) //don't add hidden networks
        {
            continue;
        }

        test.SSID = SSID_params[1];
        test.signalStrength = SSID_params[2].toInt();

        if(SSID_params[3].contains("WPA1 WPA2") || SSID_params[3].contains("WPA2 802.1X"))
        {
            SSID_params[3] = "WPA2";
        }

        test.encryption = SSID_params[3];
        test.frequency = SSID_params[4];

        if(SSID_params[0] == "*")
        {
            test.IP = wifi_config.IP;
            test.netmask = wifi_config.netmask;
            test.gateway = wifi_config.gateway;
            test.connected = true;
            test.connectedBefore = true;
            connected.push_back(test);
        }
        else if(-1 != prevConnList.indexOf(test.SSID))
        {
            test.connected = false;
            test.connectedBefore = true;
            previouslyConnectedList.push_back(test);
        }
        else {
            test.connected = false;
            test.connectedBefore = false;
            others.push_back(test);
        }
    }

    if(!connected.isEmpty())
    {
        m_wifiList.append(connected.at(0));
    }

    if(!previouslyConnectedList.isEmpty())
    {
        for(int i = 0; i < previouslyConnectedList.size(); i++)
        {
            m_wifiList.append(previouslyConnectedList.at(i));
        }
    }

    if(!others.isEmpty())
    {
        for(int i = 0; i < others.size(); i++)
        {
            m_wifiList.append(others.at(i));
        }
    }

    QString AllSSIDParams;

    for(int i = 0; i < m_wifiList.size(); i++)
    {
        QString SSIDParams;
        SSIDParams.append(m_wifiList.at(i).SSID).append(":")
            .append(m_wifiList.at(i).IP).append(":")
            .append(m_wifiList.at(i).netmask).append(":")
            .append(m_wifiList.at(i).gateway).append(":")
            .append(m_wifiList.at(i).connected?"1":"0").append(":")
            .append(m_wifiList.at(i).connectedBefore?"1":"0").append(":")
            .append(QString::number(m_wifiList.at(i).signalStrength)).append(":")
            .append(m_wifiList.at(i).encryption).append(":")
            .append(m_wifiList.at(i).frequency).append("\n");
        AllSSIDParams.append(SSIDParams);
    }

    return AllSSIDParams;
}

void NodoNetworkManager::scanWifiNetworks(void)
{
    QStringList arguments;

    arguments << "-t" << "-f" << "IN-USE,SSID,SIGNAL,SECURITY,FREQ" << "dev" << "wifi";
    QString result = callnmcli(arguments);
    m_ssidList.clear();
    m_ssidList = createWifiNetworkList(result);
    emit wifiScanCompletedNotification(m_ssidList);
}


void NodoNetworkManager::disconnectFromWiFi(QString ssid)
{
    QStringList arguments;
    arguments << "con" << "down" << "id" << ssid;
    callnmcli(arguments);
    m_networkTimer->start(0);
}

void NodoNetworkManager::connectToWiFi(QString ssid, QString password, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS)
{
    QStringList arguments;
    int prefix = calculatePrefix(netmask);
    if(DHCP)
    {
        arguments << "device" << "wifi"<< "connect" << ssid << "password" << password;
    }
    else
    {
        arguments << "device" << "wifi"<< "connect" << ssid << "password" << password << "ip4" << IP.append("/").append(QString::number(prefix, 10)) << "gw4" << gateway << "ipv4.dns" << DNS ;
    }

    QString result = callnmcli(arguments);
    if(result.contains("successfully activated with"))
    {
        qDebug() << "createWirelessConnection success";
    }
    else
    {
        qDebug() << "createWirelessConnection failed";
    }
    m_networkTimer->start(0);
}

void NodoNetworkManager::activateWiFi(QString ssid)
{
    QStringList arguments;
    arguments << "dev" << "wifi" << "connect" << ssid;

    callnmcli(arguments);

    m_networkTimer->start(0);
}

/***************ethernet controls**********************/
void NodoNetworkManager::enableEthernet(bool enable)
{
    QStringList arguments;

    arguments << "link" << "set" << m_eth_dev_name;
    if(enable)
    {
        arguments << "up";
    }
    else
    {
        arguments << "down";
    }

    QString result = callip(arguments);
    qDebug() << "enableEthernet result: " << result;
}

bool NodoNetworkManager::GetEthernetStatus(void)
{
    QStringList arguments;

    arguments << "-br" << "link" << "show" << m_eth_dev_name;

    QString result = callip(arguments);

    if(result.contains("UP"))
    {
        m_isEthernetEnabled = true;
    }
    else
    {
        m_isEthernetEnabled = false;
    }
    qDebug() << "ethernet enabled status: " << m_isEthernetEnabled;

    emit ethDeviceStatusChangedNotification(m_isEthernetEnabled);

    return m_isEthernetEnabled;
}

QString NodoNetworkManager::createEthernetNetworkList(void)
{
    QStringList arguments;
    QVector< network_parameters_t > connected;
    QVector< network_parameters_t > previouslyConnectedList;
    QVector< network_parameters_t > ethList;

    arguments << "-t" << "-f" << "ACTIVE,DEVICE,NAME,TYPE" << "con" << "show";

    QString result = callnmcli(arguments);

    QStringList connections = result.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < connections.size(); i++)
    {
        QStringList connection_params = connections[i].split(":");
        network_parameters_t test;
        if("802-3-ethernet" == connection_params[3])
        {
            test.SSID = connection_params[2];


            if("yes" == connection_params[0])
            {
                test.IP = ethernet_config.IP;
                test.netmask = ethernet_config.netmask;
                test.gateway = ethernet_config.gateway;
                test.connected = true;
                test.connectedBefore = true;
                connected.push_back(test);
            }
            else
            {
                test.connected = false;
                test.connectedBefore = true;
                previouslyConnectedList.push_back(test);
            }
        }
    }

    if(!connected.isEmpty())
    {
        ethList.append(connected.at(0));
    }

    if(!previouslyConnectedList.isEmpty())
    {
        for(int i = 0; i < previouslyConnectedList.size(); i++)
        {
            ethList.append(previouslyConnectedList.at(i));
        }
    }

    QString AllEthParams;

    for(int i = 0; i < ethList.size(); i++)
    {
        QString ethParams;
        ethParams.append(ethList.at(i).SSID).append(":")
            .append(ethList.at(i).IP).append(":")
            .append(ethList.at(i).netmask).append(":")
            .append(ethList.at(i).gateway).append(":")
            .append(ethList.at(i).connected?"1":"0").append(":")
            .append(ethList.at(i).connectedBefore?"1":"0").append(":");
        AllEthParams.append(ethParams);
    }

    return AllEthParams;
}

void NodoNetworkManager::scanEthernetNetworks(void)
{
    m_ethernetList.clear();
    m_ethernetList = createEthernetNetworkList();
    emit ethScanCompletedNotification(m_ethernetList);
}

void NodoNetworkManager::connectToEthernet(QString connectionName, bool DHCP, QString IP, QString netmask, QString gateway, QString DNS)
{
    QStringList arguments;
    int prefix = calculatePrefix(netmask);
    if(DHCP)
    {
        arguments << "con" << "add" << "type" << "ethernet" << "con-name" << connectionName << "ifname" << m_eth_dev_name;
    }
    else
    {
        arguments << "con" << "add" << "type" << "ethernet" << "con-name" << connectionName << "ifname" << m_eth_dev_name << "ip4" << IP.append("/").append(QString::number(prefix, 10)) << "gw4" << gateway << "ipv4.dns" << DNS ;
    }

    QString result = callnmcli(arguments);
    if(result.contains("successfully activated with"))
    {
        qDebug() << "createWirelessConnection success";
    }
    else
    {
        qDebug() << "createWirelessConnection failed";
    }
    m_networkTimer->start(0);
}

void NodoNetworkManager::activateEthernetConnection(QString connectionName)
{
    QStringList arguments;
    arguments << "con" << "up" << connectionName;
    callnmcli(arguments);
    m_networkTimer->start(0);
}

void NodoNetworkManager::disconnectFromEthernet(QString connectionName)
{
    QStringList arguments;
    arguments << "con" << "down" << connectionName;
    callnmcli(arguments);
    m_networkTimer->start(0);
}
