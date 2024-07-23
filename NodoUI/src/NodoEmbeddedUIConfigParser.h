#ifndef NODO_EMBEDDED_CONFIG_PARSER_H
#define NODO_EMBEDDED_CONFIG_PARSER_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QCryptographicHash>

#define MAX_FEED_COUNT 10

typedef enum {
    KEY_NAME,
    KEY_URI,
    KEY_SELECTED,
    KEY_VISIBLE,
    KEY_NUM_OF_FEEDS_TO_SHOW,
    KEY_DESCRIPTION_TAG,
    KEY_IMAGE_TAG,
    KEY_IMAGE_ATTR,
    KEY_PUB_DATE_TAG,
}feed_keys_t;

typedef struct {
    QString nameItem;
    QString uriItem;
    bool selectedItem;
    bool visibleItem;
    int numOfFeedsToShowItem;
    QString description_tag;
    QString image_tag;
    QString image_attr_tag;
    QString pub_date_tag;
}feeds_t;



typedef enum {
    DISPLAY_KEY_SS_TIMEOUT,
    DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT,
    DISPLAY_KEY_SCREEN_SAVER_TYPE,
    DISPLAY_KEY_CHANGE_ORIENTATION,
    DISPLAY_KEY_PIN_HASH,
    DISPLAY_KEY_LOCK_AFTER,
}display_keys_t;


typedef struct {
    int screenSaverTimeoutInSec;
    int screenSaverItemChangeTimeoutInSec;
    int screenSaverType;
    int displayOrientation;
    QString pinHash;
    int lockAfter;
}display_settings_t;


class NodoEmbeddedUIConfigParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoEmbeddedUIConfigParser(QObject *parent = Q_NULLPTR);
    QVector<feeds_t> readFeedKeys(void);
    void writeFeedKeys(feed_keys_t key, int index, bool state);
    int getFeedCount(void);

    display_settings_t readDisplaySettings(void);

    void writeScreenSaverTimeout(int timeout);
    int readScreenSaverTimeout(void);

    void writeScreenSaverItemChangeTimeout(int timeout);
    int readScreenSaverItemChangeTimeout(void);

    void writeScreenSaverType(int state);
    int readScreenSaverType(void);

    void writeDisplayOrientation(int orientation);
    int readDisplayOrientation(void);

    bool readPinEnabledStatus(void);
    bool comparePinHash(QString pin);
    bool setNewPin(QString newPin);
    void disablePin(void);
    int getLockAfterTime(void);
    void setLockAfterTime(int newTime);

private:
    int m_feedCount = 0;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_feedsObj;
    QJsonObject m_displayObj;

    QVector< feeds_t > m_feeds_str;
    display_settings_t m_displaySettings;

    const QStringList m_feedKeyList = {"name", "uri", "selected", "visible", "num_of_feeds_to_show", "description_tag", "image_tag", "image_attr", "pub_date_tag"};
    const QStringList m_displayKeyList = {"screensaver_timeout_in_sec", "screensaver_item_change_timeout_in_sec", "screensaver_type", "display_orientation", "pin_hash", "lock_after_in_min"};
    const QString feedObjName = "feeds";
    const QString displayObjName = "display";
    const QString m_feedNames = "feed_";
    const QString m_json_file_name = "/home/nodo/variables/nodoUI.config.json";

    void writeJson(void);
};

#endif // NODO_EMBEDDED_CONFIG_PARSER_H


