#include "NetworkManagerCommon.h"

NetworkManagerCommon::NetworkManagerCommon(QObject *parent)
    : QObject{parent}
{

}

const QDBusArgument &operator>>(const QDBusArgument &argument, QList<QVariantMap> &varMapList)
{
    argument.beginArray();
    varMapList.clear();

    while(!argument.atEnd()) {
        QVariantMap map;
        argument >> map;
        varMapList.append(map);
    }

    argument.endArray();
    return argument;
}

int NetworkManagerCommon::calculatePrefix(QString netmask)
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

QString NetworkManagerCommon::calculateNetmask(int prefix)
{
    unsigned long mask = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    return QString().append(QString::number(mask >> 24)).append(".").
        append(QString::number((mask >> 16) & 0xFF)).append(".").
        append(QString::number((mask >> 8) & 0xFF)).append(".").
        append(QString::number(mask & 0xFF));
}

void NetworkManagerCommon::getIP4Params(m_device_config *dev)
{
    QDBusConnection bus = QDBusConnection::systemBus();
    QDBusMessage message = QDBusMessage::createMethodCall(NM_DBUS_SERVICE, dev->IP4ConfigPath, NM_DBUS_PROPERTIES, "Get");

    QList<QVariant> arguments;
    arguments << "org.freedesktop.NetworkManager.IP4Config" << "AddressData";
    message.setArguments(arguments);

    auto reply = bus.call(message);

    auto arg = reply.arguments().first();
    QList<QVariantMap> list;
    arg.value<QDBusVariant>().variant().value<QDBusArgument>() >> list;
    dev->IP.clear();
    dev->gateway.clear();
    dev->netmask.clear();

    if(list.size() != 0)
    {
        QDBusInterface ifc(NM_DBUS_SERVICE, dev->IP4ConfigPath, NM_DBUS_INTERFACE_IP4_CONFIG, QDBusConnection::systemBus());
        dev->gateway = ifc.property("Gateway").toString();
        dev->IP = list.first()["address"].toString();
        dev->netmask = calculateNetmask(list.first()["prefix"].toInt());
    }

    // qDebug() << "getIP4Params" << dev->devicePath << dev->IP;
}

void NetworkManagerCommon::findDevices(m_device_config *dev)
{
    QDBusInterface nm(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_SERVICE, QDBusConnection::systemBus());

    QDBusMessage msg = nm.call("GetDevices");
    QDBusArgument arg = msg.arguments().at(0).value<QDBusArgument>();

    QList<QDBusObjectPath> pathsLst = qdbus_cast<QList<QDBusObjectPath> >(arg);
    foreach(QDBusObjectPath p, pathsLst)
    {
        QDBusInterface device(NM_DBUS_SERVICE, p.path(), NM_DBUS_INTERFACE_DEVICE, QDBusConnection::systemBus());
        QDBusObjectPath ip4Path = qdbus_cast<QDBusObjectPath >(device.property("Ip4Config"));
        int devState = device.property("State").toInt();

        if ((device.property("DeviceType").toInt() == dev->deviceType) && (devState > 0))
        {
            // qDebug() << dev->deviceConnType << p.path() << devState;
            dev->devicePath = p.path();
            dev->IP4ConfigPath = ip4Path.path();
            updateNetworkConfig(dev, devState);
        }
    }
}

void NetworkManagerCommon::updateNetworkConfig(m_device_config *dev, unsigned new_state)
{
    dev->currentConnectionState = new_state;

    if(new_state == 100)
    {
        getIP4Params(dev);
    }
    else{
        dev->IP.clear();
        dev->gateway.clear();
        dev->netmask.clear();
    }
}

void NetworkManagerCommon::getDeviceState(m_device_config *dev)
{
    bool ok;
    QDBusInterface nm(NM_DBUS_SERVICE, dev->devicePath, "org.freedesktop.NetworkManager.Device", QDBusConnection::systemBus());
    dev->currentConnectionState = nm.property("State").toInt(&ok);
    // qDebug() << "getDeviceState" << dev->devicePath << dev->currentConnectionState;
}

void NetworkManagerCommon::scanSavedConnections(m_device_config *dev)
{
    QDBusInterface connections(NM_DBUS_SERVICE, NM_DBUS_PATH_SETTINGS, NM_DBUS_INTERFACE_SETTINGS, QDBusConnection::systemBus());
    QDBusReply<QList<QDBusObjectPath> > result = connections.call("ListConnections");

    dev->connectionList.clear();
    dev->connectionPathList.clear();

    foreach (const QDBusObjectPath& connection, result.value()) {
        QDBusInterface conn(NM_DBUS_SERVICE, connection.path(), "org.freedesktop.NetworkManager.Settings.Connection", QDBusConnection::systemBus());
        QDBusMessage Settings = conn.call("GetSettings");

        const QDBusArgument &dbusArg = Settings.arguments().at(0).value<QDBusArgument>();
        QMap<QString, QVariantMap> tmp;
        dbusArg >> tmp;

        if(tmp["connection"]["type"].toString() == dev->deviceConnType)
        {
            if(connection.path() != dev->activeConnectionSettingsPath)
            {
                dev->connectionList.append(tmp["connection"]["id"].toString());
                dev->connectionPathList.append(connection.path());
            }
        }
    }
}

void NetworkManagerCommon::deactivateConnection(QString activeConnPath)
{
    QDBusInterface nm(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_SERVICE, QDBusConnection::systemBus());
    QDBusMessage result = nm.call("DeactivateConnection", QDBusObjectPath(activeConnPath));
}

void NetworkManagerCommon::getActiveConnection(m_device_config *dev)
{
    dev->activeConnectionPath.clear();
    dev->activeConnectionSettingsPath.clear();
    dev->activeConnectionName.clear();

    QDBusInterface device(NM_DBUS_SERVICE, dev->devicePath, "org.freedesktop.NetworkManager.Device", QDBusConnection::systemBus());
    QDBusObjectPath acPath = qdbus_cast<QDBusObjectPath >(device.property("ActiveConnection"));
    dev->activeConnectionPath = acPath.path();

    QDBusInterface acs(NM_DBUS_SERVICE, dev->activeConnectionPath, "org.freedesktop.NetworkManager.Connection.Active", QDBusConnection::systemBus());
    QDBusObjectPath acsPath = qdbus_cast<QDBusObjectPath >(acs.property("Connection"));
    dev->activeConnectionSettingsPath = acsPath.path();

    dev->activeConnectionName = acs.property("Id").toString();
}

void NetworkManagerCommon::activateConnection(m_device_config *dev, QString connectionPath)
{
    QDBusInterface nm(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_SERVICE, QDBusConnection::systemBus());
    QDBusMessage result = nm.call("ActivateConnection", QDBusObjectPath(connectionPath), QDBusObjectPath(dev->devicePath), QDBusObjectPath("/"));
}

void NetworkManagerCommon::forgetConnection(QString path)
{
    QDBusInterface conn(NM_DBUS_SERVICE, path, "org.freedesktop.NetworkManager.Settings.Connection", QDBusConnection::systemBus());
    QDBusMessage Settings = conn.call("Delete");
}
