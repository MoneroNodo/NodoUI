#include "NodoUISystemParser.h"

NodoUISystemParser::NodoUISystemParser(QObject *parent) : QObject(parent)
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

        m_displaySettings.screenSaverTimeoutInSec = DEFAULT_SCREENSAVER_TIMEOUT;
        m_displaySettings.screenSaverItemChangeTimeoutInSec = DEFAULT_SCREENSAVER_ITEM_CHANGE_TIMEOUT;
        m_displaySettings.screenSaverType = DEFAULT_SCREENSAVER_TYPE;
        m_displaySettings.displayOrientation = DEFAULT_DISPLAY_ORIENTATION;
        m_displaySettings.lockPinHash = DEFAULT_LOCK_PIN_HASH;
        m_displaySettings.lockAfter = DEFAULT_LOCK_AFTER;
        m_displaySettings.keyboardLayout = DEFAULT_KEYBOARD_LAYOUT_LOCALE; //"en_us"
        m_displaySettings.addressPinHash = DEFAULT_ADDRESS_PIN_HASH;
        m_displaySettings.lockPinEnabled = DEFAULT_LOCK_PIN_ENABLED;
        m_displaySettings.addressPinEnabled = DEFAULT_ADDRESS_PIN_ENABLED;


        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT], m_displaySettings.screenSaverTimeoutInSec);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT], m_displaySettings.screenSaverItemChangeTimeoutInSec);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE], m_displaySettings.screenSaverType);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION], m_displaySettings.displayOrientation);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_HASH], m_displaySettings.lockPinHash);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER], m_displaySettings.lockAfter);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_KEYBOARD_LAYOUT], m_displaySettings.keyboardLayout);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_ADDRESS_PIN_HASH], m_displaySettings.addressPinHash);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_ENABLED], DEFAULT_LOCK_PIN_ENABLED);
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_ADDRESS_PIN_ENABLED], DEFAULT_ADDRESS_PIN_ENABLED);


        writeJson();
    }

    bool updateFile = false;
    QJsonValue jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT], DEFAULT_SCREENSAVER_TIMEOUT);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT], DEFAULT_SCREENSAVER_ITEM_CHANGE_TIMEOUT);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE], DEFAULT_SCREENSAVER_TYPE);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION], DEFAULT_DISPLAY_ORIENTATION);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_HASH]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_HASH], DEFAULT_LOCK_PIN_HASH);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER], DEFAULT_LOCK_AFTER);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_KEYBOARD_LAYOUT]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_KEYBOARD_LAYOUT], DEFAULT_KEYBOARD_LAYOUT_LOCALE);
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_ADDRESS_PIN_HASH]);
    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_ADDRESS_PIN_HASH], DEFAULT_ADDRESS_PIN_HASH);
        updateFile = true;
    }

    if(updateFile)
    {
        writeJson();
    }

    readDisplaySettings();
}

display_settings_t NodoUISystemParser::readDisplaySettings(void)
{
    bool updateFile = false;

    QJsonValue jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT]);
    m_displaySettings.screenSaverTimeoutInSec = jsonValue.toInt();

    if(m_displaySettings.screenSaverTimeoutInSec < MINIMUM_SCREENSAVER_TIMEOUT)
    {
        m_displaySettings.screenSaverTimeoutInSec = DEFAULT_SCREENSAVER_TIMEOUT;
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT]);
    m_displaySettings.screenSaverItemChangeTimeoutInSec = jsonValue.toInt();

    if(m_displaySettings.screenSaverItemChangeTimeoutInSec < MINIMUM_SCREENSAVER_ITEM_CHANGE_TIMEOUT)
    {
        m_displaySettings.screenSaverItemChangeTimeoutInSec = DEFAULT_SCREENSAVER_ITEM_CHANGE_TIMEOUT;
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE]);
    m_displaySettings.screenSaverType = jsonValue.toInt();

    if((m_displaySettings.screenSaverType < MINIMUM_SCREENSAVER_TYPE) || (m_displaySettings.screenSaverType > MAXIMUM_SCREENSAVER_TYPE))
    {
        m_displaySettings.screenSaverType = DEFAULT_SCREENSAVER_TYPE;
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION]);
    m_displaySettings.displayOrientation = jsonValue.toInt();

    if(m_displaySettings.displayOrientation%90 != 0)
    {
        m_displaySettings.displayOrientation = DEFAULT_DISPLAY_ORIENTATION;
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_HASH]);
    m_displaySettings.lockPinHash = jsonValue.toString();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER]);
    m_displaySettings.lockAfter = jsonValue.toInt();

    if(m_displaySettings.lockAfter < MINIMUM_LOCK_AFTER)
    {
        m_displaySettings.lockAfter = DEFAULT_LOCK_AFTER;
        updateFile = true;
    }

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_ADDRESS_PIN_HASH]);
    m_displaySettings.addressPinHash = jsonValue.toString();

    jsonValue = m_systemObj.value(m_displayKeyList[DISPLAY_KEY_KEYBOARD_LAYOUT]);

    if(jsonValue.isUndefined() || jsonValue.isNull())
    {
        qDebug() << "undefined";
        m_displaySettings.keyboardLayout = DEFAULT_KEYBOARD_LAYOUT_LOCALE;
        updateFile = true;
    }
    else
    {
        m_displaySettings.keyboardLayout = jsonValue.toInt();

        if((m_displaySettings.keyboardLayout < 0) || (m_displaySettings.keyboardLayout > KEYBOARD_LAYOUT_COUNT))
        {
            m_displaySettings.keyboardLayout = DEFAULT_KEYBOARD_LAYOUT_LOCALE;
            updateFile = true;
        }
    }

    if(updateFile)
    {
        writeJson();
    }

    return m_displaySettings;
}

void NodoUISystemParser::writeJson(void)
{
    QFile file;

    m_rootObj.insert(systemObjName, m_systemObj);
    m_document.setObject(m_rootObj);
    file.setFileName(m_json_file_name);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(m_document.toJson());
    file.close();
}

void NodoUISystemParser::writeScreenSaverTimeout(int timeout)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT], timeout);
    writeJson();
}

int NodoUISystemParser::readScreenSaverTimeout(void)
{
    return m_displaySettings.screenSaverTimeoutInSec;
}

void NodoUISystemParser::writeScreenSaverItemChangeTimeout(int timeout)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT], timeout);
    writeJson();
}

int NodoUISystemParser::readScreenSaverItemChangeTimeout(void)
{
    return m_displaySettings.screenSaverItemChangeTimeoutInSec;
}


void NodoUISystemParser::writeScreenSaverType(int state)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE], state);
    writeJson();
}

int NodoUISystemParser::readScreenSaverType(void)
{
    return m_displaySettings.screenSaverType;
}


void NodoUISystemParser::writeDisplayOrientation(int orientation)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION], orientation);
    writeJson();
}

int NodoUISystemParser::readDisplayOrientation(void)
{
    return m_displaySettings.displayOrientation;
}

bool NodoUISystemParser::readPinEnabledStatus(void)
{
    return m_systemObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_ENABLED]).toBool(true)
        && !m_displaySettings.lockPinHash.isEmpty();
}

bool NodoUISystemParser::compareLockPinHash(QString pin)
{
    QByteArrayView pinHash = QCryptographicHash::hash(pin.toUtf8(), QCryptographicHash::Sha256);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();
    if(hashText == m_displaySettings.lockPinHash.toUtf8())
    {
        return true;
    }

    return false;
}

bool NodoUISystemParser::setNewLockPin(QString newPin)
{
    if(m_systemObj.isEmpty())
    {
        return false;
    }

    QByteArrayView pinHash = QCryptographicHash::hash(newPin.toUtf8(), QCryptographicHash::Sha256);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_HASH], QString(hashText));

    writeJson();

    return true;
}

void NodoUISystemParser::enableLockPin(void)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_ENABLED], true);
    writeJson();
}

void NodoUISystemParser::disableLockPin(void)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    //m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_HASH], QString(""));
    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_PIN_ENABLED], false);
    writeJson();
}

int NodoUISystemParser::getLockAfterTime(void)
{
    return m_displaySettings.lockAfter;
}

void NodoUISystemParser::setLockAfterTime(int newTime)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER], newTime);
    writeJson();
}

int NodoUISystemParser::readKeyboardLayoutType(void)
{
    return m_displaySettings.keyboardLayout;
}

void NodoUISystemParser::writeKeyboardLayoutType(int kbLayout)
{
    if(m_systemObj.isEmpty())
    {
        return;
    }

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_KEYBOARD_LAYOUT], kbLayout);
    writeJson();
}

bool NodoUISystemParser::compareAddressPinHash(QString pin)
{
    QByteArrayView pinHash = QCryptographicHash::hash(pin.toUtf8(), QCryptographicHash::Sha384);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();
    if(hashText == m_displaySettings.addressPinHash.toUtf8())
    {
        return true;
    }

    return false;
}

bool NodoUISystemParser::setNewAddressPin(QString newPin)
{
    if(m_systemObj.isEmpty())
    {
        return false;
    }

    QByteArrayView pinHash = QCryptographicHash::hash(newPin.toUtf8(), QCryptographicHash::Sha384);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();

    m_systemObj.insert(m_displayKeyList[DISPLAY_KEY_ADDRESS_PIN_HASH], QString(hashText));

    writeJson();

    return true;
}


bool NodoUISystemParser::isFeedsEnabled(void)
{
    return m_rootObj.value("feeds_enabled").toBool(true);
}

bool NodoUISystemParser::is24hEnabled(void)
{
    return m_rootObj.value("24h_enabled").toBool(false);
}

bool NodoUISystemParser::isTickerEnabled(void)
{
    return m_rootObj.value("ticker_enabled").toBool(true);
}

void NodoUISystemParser::setFeedsEnabled(bool enabled)
{
    m_rootObj.insert("feeds_enabled", enabled);
    writeJson();
}

void NodoUISystemParser::set24hEnabled(bool enabled)
{
    m_rootObj.insert("24h_enabled", enabled);
    writeJson();
}

void NodoUISystemParser::setTickerEnabled(bool enabled)
{
    m_rootObj.insert("ticker_enabled", enabled);
    writeJson();
}
