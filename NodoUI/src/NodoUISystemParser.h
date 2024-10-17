#ifndef NODO_UI_SYSTEM_PARSER_H
#define NODO_UI_SYSTEM_PARSER_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QCryptographicHash>

#define DEFAULT_SCREENSAVER_TIMEOUT 90
#define DEFAULT_SCREENSAVER_ITEM_CHANGE_TIMEOUT 10
#define DEFAULT_DISPLAY_ORIENTATION -90
#define DEFAULT_LOCK_PIN_HASH ""
#define DEFAULT_LOCK_AFTER 3
#define DEFAULT_KEYBOARD_LAYOUT_LOCALE 0
#define DEFAULT_ADDRESS_PIN_HASH ""


#define MINIMUM_SCREENSAVER_TIMEOUT 10
#define MINIMUM_SCREENSAVER_ITEM_CHANGE_TIMEOUT 5
#define KEYBOARD_LAYOUT_COUNT 3
#define MINIMUM_LOCK_AFTER 1

struct screenSaverTypes_t {
    QMap<QString, int> ids;
    QStringList names;
    QStringList titles;
    QStringList components;
    int defaultType;
};

extern const screenSaverTypes_t screenSaverTypes;

typedef enum {
    DISPLAY_KEY_SS_TIMEOUT,
    DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT,
    DISPLAY_KEY_SCREEN_SAVER_TYPE,
    DISPLAY_KEY_CHANGE_ORIENTATION,
    DISPLAY_KEY_LOCK_PIN_HASH,
    DISPLAY_KEY_LOCK_AFTER,
    DISPLAY_KEY_KEYBOARD_LAYOUT,
    DISPLAY_KEY_ADDRESS_PIN_HASH,
}display_keys_t;


typedef struct {
    int screenSaverTimeoutInSec;
    int screenSaverItemChangeTimeoutInSec;
    int screenSaverType;
    int displayOrientation;
    QString lockPinHash;
    QString addressPinHash;
    int lockAfter;
    int keyboardLayout;
}display_settings_t;


class NodoUISystemParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoUISystemParser(QObject *parent = Q_NULLPTR);

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
    bool compareLockPinHash(QString pin);
    bool setNewLockPin(QString newPin);
    void disableLockPin(void);
    int getLockAfterTime(void);
    void setLockAfterTime(int newTime);

    int readKeyboardLayoutType(void);
    void writeKeyboardLayoutType(int kbLayout);

    bool compareAddressPinHash(QString pin);
    bool setNewAddressPin(QString newPin);

private:
    int m_feedCount = 0;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_systemObj;

    display_settings_t m_displaySettings;

    const QStringList m_displayKeyList = {"screensaver_timeout_in_sec", "screensaver_item_change_timeout_in_sec", "screensaver_type", "display_orientation", "lock_pin_hash", "lock_after_in_min", "keyboard_layout", "address_pin_hash"};
    const QString systemObjName = "system";
    const QString m_json_file_name = "/home/nodo/variables/nodoUI.system.json";

    void writeJson(void);
};

#endif // NODO_UI_SYSTEM_PARSER_H


