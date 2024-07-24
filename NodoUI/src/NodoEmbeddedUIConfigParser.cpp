#include "NodoEmbeddedUIConfigParser.h"

NodoEmbeddedUIConfigParser::NodoEmbeddedUIConfigParser(QObject *parent) : QObject(parent)
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
        m_systemObj = m_rootObj[systemObjName].toObject();
    }
    else
    {
        qDebug() << "couldn't open system file " << m_json_file_name << " Creating system file with default parameters";

        m_displaySettings.screenSaverTimeoutInSec = 90;
        m_displaySettings.screenSaverItemChangeTimeoutInSec = 10;
        m_displaySettings.screenSaverType = 2;
        m_displaySettings.displayOrientation = -90;
        m_displaySettings.pinHash = "";
        m_displaySettings.lockAfter = 3;

        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT], m_displaySettings.screenSaverTimeoutInSec);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT], m_displaySettings.screenSaverItemChangeTimeoutInSec);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE], m_displaySettings.screenSaverType);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION], m_displaySettings.displayOrientation);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_PIN_HASH], m_displaySettings.pinHash);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER], m_displaySettings.lockAfter);

        writeJson();
    }
}

display_settings_t NodoEmbeddedUIConfigParser::readDisplaySettings(void)
{
    if(m_systemObj.isEmpty())
    {
        qDebug() << "couldn't find display settings";
        m_displaySettings.screenSaverTimeoutInSec = 50;
        m_displaySettings.screenSaverItemChangeTimeoutInSec = 10;
        m_displaySettings.screenSaverType = 2;
        m_displaySettings.displayOrientation = 0;
        m_displaySettings.pinHash = "";
        m_displaySettings.lockAfter = 3;

        return m_displaySettings;
    }

    QJsonValue jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT]);
    m_displaySettings.screenSaverTimeoutInSec = jsonValue.toInt();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT]);
    m_displaySettings.screenSaverItemChangeTimeoutInSec = jsonValue.toInt();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE]);
    m_displaySettings.screenSaverType = jsonValue.toInt();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION]);
    m_displaySettings.displayOrientation = jsonValue.toInt();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_PIN_HASH]);
    m_displaySettings.pinHash = jsonValue.toString();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER]);
    m_displaySettings.lockAfter = jsonValue.toInt();

    return m_displaySettings;
}

void NodoEmbeddedUIConfigParser::writeJson(void)
{
    QFile file;

    m_rootObj.insert(systemObjName, m_systemObj);
    m_document.setObject(m_rootObj);
    file.setFileName(m_json_file_name);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(m_document.toJson());
    file.close();
}

void NodoEmbeddedUIConfigParser::writeScreenSaverTimeout(int timeout)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT], timeout);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readScreenSaverTimeout(void)
{
    return m_displaySettings.screenSaverTimeoutInSec;
}

void NodoEmbeddedUIConfigParser::writeScreenSaverItemChangeTimeout(int timeout)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT], timeout);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readScreenSaverItemChangeTimeout(void)
{
    return m_displaySettings.screenSaverItemChangeTimeoutInSec;
}


void NodoEmbeddedUIConfigParser::writeScreenSaverType(int state)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE], state);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readScreenSaverType(void)
{
    return m_displaySettings.screenSaverType;
}


void NodoEmbeddedUIConfigParser::writeDisplayOrientation(int orientation)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION], orientation);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readDisplayOrientation(void)
{
    return m_displaySettings.displayOrientation;
}

bool NodoEmbeddedUIConfigParser::readPinEnabledStatus(void)
{
    return !m_displaySettings.pinHash.isEmpty();
}

bool NodoEmbeddedUIConfigParser::comparePinHash(QString pin)
{
    QByteArrayView pinHash = QCryptographicHash::hash(pin.toUtf8(), QCryptographicHash::Sha256);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();
    if(hashText == m_displaySettings.pinHash.toUtf8())
    {
        return true;
    }

    return false;
}

bool NodoEmbeddedUIConfigParser::setNewPin(QString newPin)
{
    if(m_systemObj.isEmpty())
    {
        return false;
    }

    QByteArrayView pinHash = QCryptographicHash::hash(newPin.toUtf8(), QCryptographicHash::Sha256);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_PIN_HASH], QString(hashText));

    writeJson();

    return true;
}

void NodoEmbeddedUIConfigParser::disablePin(void)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_PIN_HASH], QString(""));

    writeJson();
}

int NodoEmbeddedUIConfigParser::getLockAfterTime(void)
{
    return m_displaySettings.lockAfter;
}

void NodoEmbeddedUIConfigParser::setLockAfterTime(int newTime)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER], newTime);
    writeJson();
}

