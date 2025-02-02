#include "NodoConfigParser.h"
#include <QFileSystemWatcher>

#define LOCKFILE "/home/nodo/variables/updatelock"

NodoConfigParser::NodoConfigParser(QObject *parent) : QObject(parent)
{
    readFile();
    m_timer = new QTimer(this);
    QFileSystemWatcher *watcher = new QFileSystemWatcher(this);
    connect(watcher, SIGNAL(fileChanged(LOCKFILE)), this, SLOT(checkLock()));
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updateStatus()));
    m_timer->start(0);
}

bool NodoConfigParser::isUpdateLocked()
{
    return QFileInfo::exists(LOCKFILE);
}

void NodoConfigParser::readFile(void)
{
    QMutexLocker locker(&m_mutex);
    QFile lockfile(m_json_lock_file_name);
    int counter = 0;

    while(true == lockfile.exists())
    {
        QThread::msleep(10);
        counter++;
        if(counter > 10)
        {
            break;
        }
    }

    lockfile.open(QFile::WriteOnly | QFile::Text);
    lockfile.write(" ");
    lockfile.close();

    QString val;
    QFile file;
    file.setFileName(m_json_file_name);
    if(file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        val = file.readAll();
        file.close();

        m_document = QJsonDocument::fromJson(val.toUtf8());
        m_rootObj = m_document.object();
        m_configObj = m_rootObj[configObjName].toObject();

        m_ethernetObj = m_configObj[ethernetObjName].toObject();
        m_wifiObj = m_configObj[wifiObjName].toObject();
        m_versionsObj = m_configObj[versionsObjName].toObject();
        m_moneropayObj = m_configObj[moneropayObjName].toObject();
        m_autoupdateObj = m_configObj[autoupdateObjName].toObject();
        m_banlistsObj = m_configObj[banlistsObjName].toObject();

        locker.unlock();
        lockfile.remove();
        emit configParserReady();
    }
    else
    {
        qDebug() << "couldn't open config file " + m_json_file_name;
        lockfile.remove();
    }

}

QString NodoConfigParser::getStringValueFromKey(QString object, QString key)
{
    QJsonValue jsonValue;
    if(ethernetObjName == object)
    {
        jsonValue = m_ethernetObj.value(key);
    }
    else if(wifiObjName == object)
    {
        jsonValue = m_wifiObj.value(key);
    }
    else if(versionsObjName == object)
    {
        jsonValue = m_versionsObj.value(key);
    }
    else if(configObjName == object)
    {
        jsonValue = m_configObj.value(key);
    }
    else if(moneropayObjName == object)
    {
        jsonValue = m_moneropayObj.value(key);
    }
    else if(autoupdateObjName == object)
    {
        jsonValue = m_autoupdateObj.value(key);
    }
    else if(banlistsObjName == object)
    {
        jsonValue = m_banlistsObj.value(key);
    }

    return jsonValue.toString();
}

int NodoConfigParser::getIntValueFromKey(QString object, QString key)
{
    QJsonValue jsonValue;
    if(ethernetObjName == object)
    {
        jsonValue = m_ethernetObj.value(key);
    }
    else if(wifiObjName == object)
    {
        jsonValue = m_wifiObj.value(key);
    }
    else if(versionsObjName == object)
    {
        jsonValue = m_versionsObj.value(key);
    }
    else if(configObjName == object)
    {
        jsonValue = m_configObj.value(key);
    }
    else if(moneropayObjName == object)
    {
        jsonValue = m_moneropayObj.value(key);
    }
    else if(autoupdateObjName == object)
    {
        jsonValue = m_autoupdateObj.value(key);
    }
    else if(banlistsObjName == object)
    {
        jsonValue = m_banlistsObj.value(key);
    }

    return jsonValue.toInt();
}

void NodoConfigParser::checkLock(void)
{
    if (!isUpdateLocked())
    {
        emit lockGone();
    }
}

void NodoConfigParser::updateStatus(void)
{
    m_timer->stop();
    readFile();
     m_timer->start(10000);
}

void NodoConfigParser::updateRequested(void)
{
    m_timer->stop();
    readFile();
    m_timer->start(10000);
}

QString NodoConfigParser::getSelectedCurrencyName(void)
{
    QJsonValue jsonValue;
    jsonValue = m_configObj.value("ticker");
    return jsonValue.toString().toUpper();
}

void NodoConfigParser::setCurrencyName(QString currency)
{
    m_configObj.insert("ticker", currency);
    writeJson();
}

void NodoConfigParser::writeJson(void)
{
    QMutexLocker locker(&m_mutex);
    QFile lockfile(m_json_lock_file_name);
    int counter = 0;

    while(true == lockfile.exists())
    {
        QThread::msleep(10);
        counter++;
        if(counter > 10)
        {
            break;
        }
    }

    QFile file;
    lockfile.open(QFile::WriteOnly | QFile::Text);
    lockfile.write(" ");
    lockfile.close();

    m_configObj.insert(ethernetObjName, m_ethernetObj);
    m_configObj.insert(wifiObjName, m_wifiObj);
    m_configObj.insert(versionsObjName, m_versionsObj);
    m_configObj.insert(moneropayObjName, m_moneropayObj);
    m_configObj.insert(autoupdateObjName, m_autoupdateObj);
    m_configObj.insert(banlistsObjName, m_banlistsObj);

    m_rootObj.insert(configObjName, m_configObj);

    m_document.setObject(m_rootObj);
    file.setFileName(m_json_file_name);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(m_document.toJson());
    file.close();


    lockfile.remove();

    m_timer->start(0);
}

QString NodoConfigParser::getTimezone(void)
{
    QJsonValue jsonValue;
    jsonValue = m_configObj.value("timezone");
    if("" == jsonValue.toString())
    {
        m_configObj.insert("timezone", "UTC");
        writeJson();

        return "UTC";
    }
    if("GMT" == jsonValue.toString())
    {
        m_configObj.insert("timezone", "Europe/London");
        writeJson();

        return "Europe/London";
    }
    if("CET" == jsonValue.toString())
    {
        m_configObj.insert("timezone", "Europe/Berlin");
        writeJson();

        return "Europe/Berlin";
    }
    return jsonValue.toString();
}

void NodoConfigParser::setTimezone(QString tz)
{
    m_configObj.insert("timezone", tz);
    writeJson();
}

QString NodoConfigParser::getLanguageCode(void)
{
    QJsonValue jsonValue;
    jsonValue = m_configObj.value("language");
    if("" == jsonValue.toString())
    {
        m_configObj.insert("language", "en_US");
        writeJson();

        return "en_US";
    }
    return jsonValue.toString();
}

void NodoConfigParser::setLanguageCode(QString code)
{
    m_configObj.insert("language", code);
    writeJson();
}

QString NodoConfigParser::getDBPathDir(void)
{
    QJsonValue jsonValue;
    jsonValue = m_configObj.value("data_dir");
    if("" == jsonValue.toString())
    {
        return "";
    }
    return jsonValue.toString();
}

void NodoConfigParser::setTheme(bool theme)
{
    m_configObj.insert("night_mode", theme);
    writeJson();
}

bool NodoConfigParser::getTheme(void)
{
    QJsonValue jsonValue;
    jsonValue = m_configObj.value("night_mode");
    if(jsonValue.isNull())
    {
        m_configObj.insert("night_mode", false);
        writeJson();
        return false;
    }
    return jsonValue.toBool();
}

bool NodoConfigParser::getBanlistEnabled(void)
{
    return m_configObj.value("banlist") == "TRUE";
}

void NodoConfigParser::setBanlistEnabled(bool enabled)
{
    m_configObj.insert("banlist", enabled ? "TRUE" : "FALSE");
    writeJson();
}

bool NodoConfigParser::getBanlistsListEnabled(QString banlist)
{
    return m_banlistsObj.value(banlist) == "TRUE";
}

void NodoConfigParser::setBanlistsListEnabled(QString banlist, bool enabled)
{
    m_banlistsObj.insert(banlist, enabled ? "TRUE" : "FALSE");
    writeJson();
}

void NodoConfigParser::setClearnetPort(QString port)
{
    m_configObj.insert("monero_public_port", port.toInt());
    writeJson();
}

void NodoConfigParser::setTorPort(QString port)
{
    m_configObj.insert("tor_port", port.toInt());
    writeJson();
}

void NodoConfigParser::setI2pPort(QString port)
{
    m_configObj.insert("i2p_port", port.toInt());
    writeJson();
}

bool NodoConfigParser::istorProxyEnabled()
{
    return m_configObj.value("torproxy_enabled").toString("FALSE") == "TRUE";
}

void NodoConfigParser::settorProxyEnabled(bool enabled)
{
    m_configObj.insert("torproxy_enabled", enabled ? "TRUE" : "FALSE");
    writeJson();
}

void NodoConfigParser::setrpcEnabledStatus(bool status)
{
    QString stat;
    if(status)
    {
        stat = "TRUE";
    }
    else
    {
        stat = "FALSE";
    }

    m_configObj.insert("rpc_enabled", stat);
    writeJson();
}

void NodoConfigParser::setrpcPort(QString port)
{
    m_configObj.insert("monero_rpc_port", port.toInt());
    writeJson();
}

void NodoConfigParser::setNodeBandwidthParameters(QString in_peers, QString out_peers, QString limit_rate_up, QString limit_rate_down)
{
    qDebug() << in_peers << out_peers << limit_rate_up << limit_rate_down;

    m_configObj.insert("in_peers", in_peers.toInt());
    m_configObj.insert("out_peers", out_peers.toInt());
    m_configObj.insert("limit_rate_up", limit_rate_up.toInt());
    m_configObj.insert("limit_rate_down", limit_rate_down.toInt());
    writeJson();
}

void NodoConfigParser::setMoneroPayParameters(QString address)
{
    m_moneropayObj.insert("deposit_address", address);
    writeJson();
}

QString NodoConfigParser::getMoneroPayAddress(void)
{
    QJsonValue jsonValue;
    jsonValue = m_moneropayObj.value("deposit_address");
    if("" == jsonValue.toString())
    {
        return "";
    }
    return jsonValue.toString();
}

double NodoConfigParser::getExchangeRate(void)
{
    QJsonValue jsonValue;
    jsonValue = m_configObj.value("exchange_rate");

    if(jsonValue.isNull())
    {
        m_configObj.insert("exchange_rate", -1);
        writeJson();
        return -1;
    }

    if(!jsonValue.isDouble())
    {
        return -1;
    }

    return jsonValue.toDouble();
}

void NodoConfigParser::setExchangeRate(double rate)
{
    m_configObj.insert("exchange_rate", rate);
    writeJson();
}

bool NodoConfigParser::getUpdateStatus(QString moduleName)
{
    QJsonValue jsonValue;
    jsonValue = m_autoupdateObj.value(moduleName);

    if(jsonValue.isNull())
    {
        m_autoupdateObj.insert(moduleName, "FALSE");
        writeJson();
        return false;
    }

    if("TRUE" == jsonValue.toString())
    {
        return true;
    }

    return false;
}

void NodoConfigParser::setUpdateStatus(QString moduleName, bool newStatus)
{
    QString stat;
    if(newStatus)
    {
        stat = "TRUE";
    }
    else
    {
        stat = "FALSE";
    }

    m_autoupdateObj.insert(moduleName, stat);
    writeJson();
}

void NodoConfigParser::setHiddenRPCEnabled(bool enabled)
{
    m_configObj.insert("anon_rpc", enabled ? "TRUE" : "FALSE");
    writeJson();
}

void NodoConfigParser::setTorEnabled(bool enabled)
{
    m_configObj.insert("tor_enabled", enabled ? "TRUE" : "FALSE");
    writeJson();
}

void NodoConfigParser::setI2PEnabled(bool enabled)
{
    m_configObj.insert("i2p_enabled", enabled ? "TRUE" : "FALSE");
    writeJson();
}

QString NodoConfigParser::getSoftwareVersion(QString name)
{
    auto it = m_versionsObj.find("names");
    if (it->isObject())
    {
        return it->toObject().value(name).toString("");
    }
    else {
        it = m_versionsObj.find("versions");
        if (it->isObject())
        {
            QString str = it->toObject().value(name).toString("");
            str.truncate(6);
            return str;
        }
    }
    return "";
}
void NodoConfigParser::setrpcUser(QString user)
{
    m_configObj.insert("rpcu", user);
}
void NodoConfigParser::setrpcPassword(QString pass)
{
    m_configObj.insert("rpcp", pass);
}
