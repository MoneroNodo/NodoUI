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
        m_feedsObj = m_rootObj[feedObjName].toObject();
        m_displayObj = m_rootObj[displayObjName].toObject();
    }
    else
    {
        qDebug() << "couldn't open config file " + m_json_file_name;
    }
}

display_settings_t NodoEmbeddedUIConfigParser::readDisplaySettings(void)
{
    if(m_displayObj.isEmpty())
    {
        qDebug() << "couldn't find display settings";
        m_displaySettings.screenSaverTimeoutInSec = 50;
        m_displaySettings.screenSaverItemChangeTimeoutInSec = 10;
        m_displaySettings.screenSaverType = 0;
        m_displaySettings.displayOrientation = 0;
        m_displaySettings.pinHash = "";
        m_displaySettings.lockAfter = 0;

        return m_displaySettings;
    }

    QJsonValue jsonValue = m_displayObj.value(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT]);
    m_displaySettings.screenSaverTimeoutInSec = jsonValue.toInt();

    jsonValue = m_displayObj.value(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT]);
    m_displaySettings.screenSaverItemChangeTimeoutInSec = jsonValue.toInt();

    jsonValue = m_displayObj.value(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE]);
    m_displaySettings.screenSaverType = jsonValue.toInt();

    jsonValue = m_displayObj.value(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION]);
    m_displaySettings.displayOrientation = jsonValue.toInt();

    jsonValue = m_displayObj.value(m_displayKeyList[DISPLAY_KEY_PIN_HASH]);
    m_displaySettings.pinHash = jsonValue.toString();

    jsonValue = m_displayObj.value(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER]);
    m_displaySettings.lockAfter = jsonValue.toInt();

    return m_displaySettings;
}

QVector<feeds_t> NodoEmbeddedUIConfigParser::readFeedKeys(void)
{
    m_feeds_str.clear();

    if(m_feedsObj.isEmpty())
    {
        qDebug() << "couldn't find feed keys";
        m_feedCount = MAX_FEED_COUNT;

        for(int i = 0; i < m_feedCount; i++)
        {
            feeds_t tmp_feeds;
            tmp_feeds.nameItem = "";
            tmp_feeds.uriItem = "";
            tmp_feeds.selectedItem = false;
            tmp_feeds.visibleItem = false;
            tmp_feeds.numOfFeedsToShowItem = 0;
            tmp_feeds.description_tag = "";
            tmp_feeds.image_tag = "";
            tmp_feeds.image_attr_tag = "";
            tmp_feeds.pub_date_tag = "";

            m_feeds_str.push_back(tmp_feeds);
        }
        return m_feeds_str;
    }

    m_feedCount = m_feedsObj.size();
    if(m_feedCount > MAX_FEED_COUNT)
    {
        m_feedCount = MAX_FEED_COUNT;
    }

    for(int i = 0; i < m_feedCount; i++)
    {
        feeds_t tmp_feeds;
        QJsonObject feeds_obj = m_feedsObj[m_feedNames + QString::number(i, 10)].toObject();
        QJsonValue jsonValue = feeds_obj.value(m_feedKeyList[KEY_NAME]);
        tmp_feeds.nameItem = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_URI]);
        tmp_feeds.uriItem = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_SELECTED]);
        tmp_feeds.selectedItem = jsonValue.toBool();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_VISIBLE]);
        tmp_feeds.visibleItem = jsonValue.toBool();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_NUM_OF_FEEDS_TO_SHOW]);
        tmp_feeds.numOfFeedsToShowItem = jsonValue.toInt();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_DESCRIPTION_TAG]);
        tmp_feeds.description_tag = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_IMAGE_TAG]);
        tmp_feeds.image_tag = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_IMAGE_ATTR]);
        tmp_feeds.image_attr_tag = jsonValue.toString();

        jsonValue = feeds_obj.value(m_feedKeyList[KEY_PUB_DATE_TAG]);
        tmp_feeds.pub_date_tag = jsonValue.toString();

        m_feeds_str.push_back(tmp_feeds);
    }
    return m_feeds_str;
}

void NodoEmbeddedUIConfigParser::writeJson(void)
{
    QFile file;

    m_rootObj.insert(feedObjName, m_feedsObj);
    m_rootObj.insert(displayObjName, m_displayObj);
    m_document.setObject(m_rootObj);
    file.setFileName(m_json_file_name);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(m_document.toJson());
    file.close();
}

void NodoEmbeddedUIConfigParser::writeFeedKeys(feed_keys_t key, int index, bool state)
{
    if(m_feedsObj.isEmpty())
    {
        return;
    }

    QJsonObject feeds = m_feedsObj[m_feedNames + QString::number(index, 10)].toObject();
    feeds.insert(m_feedKeyList[key], state);
    m_feedsObj.insert(m_feedNames + QString::number(index, 10), feeds);
    writeJson();
}

int NodoEmbeddedUIConfigParser::getFeedCount(void)
{
    return m_feedCount;
}

void NodoEmbeddedUIConfigParser::writeScreenSaverTimeout(int timeout)
{
    if(m_displayObj.isEmpty())
    {
        return;
    }

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_SS_TIMEOUT], timeout);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readScreenSaverTimeout(void)
{
    return m_displaySettings.screenSaverTimeoutInSec;
}

void NodoEmbeddedUIConfigParser::writeScreenSaverItemChangeTimeout(int timeout)
{
    if(m_displayObj.isEmpty())
    {
        return;
    }

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT], timeout);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readScreenSaverItemChangeTimeout(void)
{
    return m_displaySettings.screenSaverItemChangeTimeoutInSec;
}


void NodoEmbeddedUIConfigParser::writeScreenSaverType(int state)
{
    if(m_displayObj.isEmpty())
    {
        return;
    }

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_SCREEN_SAVER_TYPE], state);
    writeJson();
}

int NodoEmbeddedUIConfigParser::readScreenSaverType(void)
{
    return m_displaySettings.screenSaverType;
}


void NodoEmbeddedUIConfigParser::writeDisplayOrientation(int orientation)
{
    if(m_displayObj.isEmpty())
    {
        return;
    }

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_CHANGE_ORIENTATION], orientation);
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
    if(m_displayObj.isEmpty())
    {
        return false;
    }

    QByteArrayView pinHash = QCryptographicHash::hash(newPin.toUtf8(), QCryptographicHash::Sha256);
    QByteArray hashText = QByteArray(pinHash.toByteArray(), pinHash.size()).toHex().constData();

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_PIN_HASH], QString(hashText));

    writeJson();

    return true;
}

void NodoEmbeddedUIConfigParser::disablePin(void)
{
    if(m_displayObj.isEmpty())
    {
        return;
    }

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_PIN_HASH], QString(""));

    writeJson();
}

int NodoEmbeddedUIConfigParser::getLockAfterTime(void)
{
    return m_displaySettings.lockAfter;
}

void NodoEmbeddedUIConfigParser::setLockAfterTime(int newTime)
{
    if(m_displayObj.isEmpty())
    {
        return;
    }

    m_displayObj.insert(m_displayKeyList[DISPLAY_KEY_LOCK_AFTER], newTime);
    writeJson();
}

