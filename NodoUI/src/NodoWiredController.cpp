#include "NodoWiredController.h"

NodoWiredController::NodoWiredController(QObject *parent)
    : QObject{parent}
{
    m_nmCommon = new NetworkManagerCommon();
    m_device.deviceConnType = "802-3-ethernet";
    m_device.deviceType = 1;
    m_device.devicePath = "";

    m_nmCommon->findDevices(&m_device);
    m_interface = new QDBusInterface(NM_DBUS_SERVICE, m_device.devicePath, NM_DBUS_INTERFACE_DEVICE, QDBusConnection::systemBus());
    connect(m_interface, SIGNAL(StateChanged(unsigned, unsigned, unsigned)), this, SLOT(updateNetworkConfig(unsigned, unsigned, unsigned)));

    m_nmCommon->getDeviceState(&m_device);
    getDeviceSpeed(&m_device);

    if(m_device.currentConnectionState == 100)
    {
        m_nmCommon->getIP4Params(&m_device);
    }
    m_detailsOpened = false;
}

/************private functions*******************/
void NodoWiredController::updateNetworkConfig(unsigned new_state, unsigned old_state, unsigned reason)
{
    Q_UNUSED(old_state);
    Q_UNUSED(reason);

    m_nmCommon->updateNetworkConfig(&m_device, new_state);

    // qDebug() << "updateNetworkConfig" << m_device.devicePath << "new state:" << new_state;

    if((new_state == 30) || (new_state == 100))
    {
        QTimer::singleShot(100, this, SLOT(scanConnectionsThread()));
    }

    if((new_state == 10) || (new_state == 20) || (new_state == 30) || (new_state == 100))
    {
        emit deviceStatusChangedNotification(new_state);
    }
}

void NodoWiredController::getActiveConnection(void)
{
    m_nmCommon->getActiveConnection(&m_device);
}

QString NodoWiredController::packageConnections(void)
{
    QVector< network_parameters_t > ethList;

    if(!m_device.activeConnectionName.isEmpty())
    {
        network_parameters_t test;
        test.connectionName = m_device.activeConnectionName;
        test.IP = m_device.IP;
        test.netmask = m_device.netmask;
        test.gateway = m_device.gateway;
        test.connected = true;
        test.connectedBefore = true;
        test.dbusConnectionPath = m_device.activeConnectionSettingsPath;
        ethList.append(test);
    }

    for(int i = 0; i < m_device.connectionList.size(); i++)
    {
        network_parameters_t test;
        test.connectionName = m_device.connectionList.at(i);
        test.connected = false;
        test.connectedBefore = true;
        test.dbusConnectionPath = m_device.connectionPathList.at(i);
        ethList.append(test);
    }

    QString AllEthParams;

    for(int i = 0; i < ethList.size(); i++)
    {
        QString ethParams;
        ethParams.append(ethList.at(i).connectionName).append(":")
            .append(ethList.at(i).IP).append(":")
            .append(ethList.at(i).netmask).append(":")
            .append(ethList.at(i).gateway).append(":")
            .append(ethList.at(i).connected?"1":"0").append(":")
            .append(ethList.at(i).connectedBefore?"1":"0").append(":")
            .append(ethList.at(i).dbusConnectionPath).append("\n");
        AllEthParams.append(ethParams);
    }

    return AllEthParams;
}

void NodoWiredController::scanConnectionsThread(void)
{
    if (m_detailsOpened)
        return;
    if(m_device.devicePath.isEmpty())
    {
        return;
    }
    getActiveConnection();
    m_nmCommon->scanSavedConnections(&m_device);
    m_nmCommon->getIP4Params(&m_device);
    QString ethernetList = packageConnections();
    emit scanCompletedNotification(ethernetList);
}

void NodoWiredController::updateThread(void)
{
    getActiveConnection();
    scanConnections();
}


void NodoWiredController::getDeviceSpeed(m_device_config *dev)
{
    bool ok;
    QDBusInterface nm(NM_DBUS_SERVICE, dev->devicePath, "org.freedesktop.NetworkManager.Device.Wired", QDBusConnection::systemBus());
    dev->deviceSpeed = nm.property("Speed").toInt(&ok);

    // qDebug() << "getDeviceSpeed" << dev->devicePath << dev->deviceSpeed;
}

/************public functions*******************/
void NodoWiredController::forgetConnection(QString path)
{
    m_nmCommon->forgetConnection(path);
    getActiveConnection();
    scanConnections();
}

void NodoWiredController::addConnection(QString profileName, bool isDHCP, QString IP, QString netmask, QString gateway, QString DNS)
{
    qDBusRegisterMetaType<Connection>();
    qDBusRegisterMetaType<QList<uint> >();
    qDBusRegisterMetaType<QList<QList<uint> > >();

    Connection connection;

    // Build up the 'connection' Setting
    connection["connection"]["uuid"] = QUuid::createUuid().toString().remove('{').remove('}');
    connection["connection"]["id"] = profileName;
    connection["connection"]["type"] = "802-3-ethernet";

    connection["802-3-ethernet"];
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
    QDBusInterface settings(NM_DBUS_SERVICE, NM_DBUS_PATH_SETTINGS, NM_DBUS_INTERFACE_SETTINGS, QDBusConnection::systemBus());
    QDBusReply<QDBusObjectPath> result = settings.call("AddConnection", QVariant::fromValue(connection));

    getActiveConnection();
    scanConnections();
    emit connectionProfileCreated();
}

void NodoWiredController::activateConnection(int connectionIndex)
{
    m_nmCommon->activateConnection(&m_device, m_device.connectionPathList.at(connectionIndex));
    QTimer::singleShot(1000, this, SLOT(updateThread()));
}

void NodoWiredController::deactivateConnection(void)
{
    m_nmCommon->deactivateConnection(m_device.activeConnectionPath);
    QTimer::singleShot(1000, this, SLOT(updateThread()));
}

unsigned NodoWiredController::getDeviceConnectionStatus(void)
{
    return m_device.currentConnectionState;
}

void NodoWiredController::scanConnections(void)
{
    QTimer::singleShot(100, this, SLOT(scanConnectionsThread()));
}

int NodoWiredController::getDeviceSpeed(void)
{
    return m_device.deviceSpeed;
}

QString NodoWiredController::getIP(void)
{
    return m_device.IP;
}

void NodoWiredController::requestConnectionStateUpdate(void)
{
    m_nmCommon->getDeviceState(&m_device);
}

void NodoWiredController::setDetailsOpened(bool opened)
{
    m_detailsOpened = opened;
}

bool NodoWiredController::getDetailsOpened(void)
{
    return m_detailsOpened;
}
