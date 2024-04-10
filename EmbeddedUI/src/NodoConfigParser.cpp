#include "NodoConfigParser.h"

NodoConfigParser::NodoConfigParser(QObject *parent) : QObject(parent)
{
    readFile();
    m_timer = new QTimer(this);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updateStatus()));
    m_timer->start(10000);
}

void NodoConfigParser::readFile(void)
{
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
    readFile();
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
    QFile file;

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
