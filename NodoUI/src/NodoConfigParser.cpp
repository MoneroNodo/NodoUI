#include "NodoConfigParser.h"

NodoConfigParser::NodoConfigParser(QObject *parent) : QObject(parent)
{
    readFile();
    m_timer = new QTimer(this);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updateStatus()));
    m_timer->start(0);
}

void NodoConfigParser::readFile(void)
{
    m_mutex.lock();
    QFile lockfile(m_json_lock_file_name);

    while(true == lockfile.exists())
    {
        QThread::msleep(100);
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

        m_miningObj = m_configObj[miningObjName].toObject();
        m_ethernetObj = m_configObj[ethernetObjName].toObject();
        m_wifiObj = m_configObj[wifiObjName].toObject();
        m_versionsObj = m_configObj[versionsObjName].toObject();

        emit configParserReady();
    }
    else
    {
        qDebug() << "couldn't open config file " + m_json_file_name;
    }

    lockfile.remove();
    m_mutex.unlock();
}

QString NodoConfigParser::getStringValueFromKey(QString object, QString key)
{
    QJsonValue jsonValue;
    if("mining" == object)
    {
        jsonValue = m_miningObj.value(key);
    }
    else if("ethernet" == object)
    {
        jsonValue = m_ethernetObj.value(key);
    }
    else if("wifi" == object)
    {
        jsonValue = m_wifiObj.value(key);
    }
    else if("versions" == object)
    {
        jsonValue = m_versionsObj.value(key);
    }
    else if("config" == object)
    {
        jsonValue = m_configObj.value(key);
    }

    return jsonValue.toString();
}

int NodoConfigParser::getIntValueFromKey(QString object, QString key)
{
    QJsonValue jsonValue;
    if("mining" == object)
    {
        jsonValue = m_miningObj.value(key);
    }
    else if("ethernet" == object)
    {
        jsonValue = m_ethernetObj.value(key);
    }
    else if("wifi" == object)
    {
        jsonValue = m_wifiObj.value(key);
    }
    else if("versions" == object)
    {
        jsonValue = m_versionsObj.value(key);
    }
    else if("config" == object)
    {
        jsonValue = m_configObj.value(key);
    }

    return jsonValue.toInt();
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
    m_mutex.lock();
    QFile file;
    QFile lockfile(m_json_lock_file_name);

    while(true == lockfile.exists())
    {
        QThread::msleep(100);
    }

    lockfile.open(QFile::WriteOnly | QFile::Text);
    lockfile.write(" ");
    lockfile.close();

    m_configObj.insert(miningObjName, m_miningObj);
    m_configObj.insert(ethernetObjName, m_ethernetObj);
    m_configObj.insert(wifiObjName, m_wifiObj);
    m_configObj.insert(versionsObjName, m_versionsObj);

    m_rootObj.insert(configObjName, m_configObj);

    m_document.setObject(m_rootObj);
    file.setFileName(m_json_file_name);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(m_document.toJson());
    file.close();


    lockfile.remove();
    m_mutex.unlock();

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

void NodoConfigParser::setMinerServiceStatus(bool status)
{
    QString s;
    if(status)
    {
        s = "TRUE";
    }
    else
    {
        s = "FALSE";
    }
    m_miningObj.insert("enabled", s);
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

