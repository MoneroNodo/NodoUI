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
#define DEFAULT_SCREENSAVER_TYPE 2
#define DEFAULT_DISPLAY_ORIENTATION -90
#define DEFAULT_PIN_HASH ""
#define DEFAULT_LOCK_AFTER 3
#define DEFAULT_KEYBOARD_LAYOUT_LOCALE 0


typedef enum {
    DISPLAY_KEY_SS_TIMEOUT,
    DISPLAY_KEY_SS_ITEM_CHANGE_TIMEOUT,
    DISPLAY_KEY_SCREEN_SAVER_TYPE,
    DISPLAY_KEY_CHANGE_ORIENTATION,
    DISPLAY_KEY_PIN_HASH,
    DISPLAY_KEY_LOCK_AFTER,
    DISPLAY_KEY_KEYBOARD_LAYOUT
}display_keys_t;


typedef struct {
    int screenSaverTimeoutInSec;
    int screenSaverItemChangeTimeoutInSec;
    int screenSaverType;
    int displayOrientation;
    QString pinHash;
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
    bool comparePinHash(QString pin);
    bool setNewPin(QString newPin);
    void disablePin(void);
    int getLockAfterTime(void);
    void setLockAfterTime(int newTime);

    int readKeyboardLayoutType(void);
    void writeKeyboardLayoutType(int kbLayout);

private:
    int m_feedCount = 0;
    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_systemObj;

    display_settings_t m_displaySettings;

    const QStringList m_displayKeyList = {"screensaver_timeout_in_sec", "screensaver_item_change_timeout_in_sec", "screensaver_type", "display_orientation", "pin_hash", "lock_after_in_min", "keyboard_layout"};
    const QString systemObjName = "system";
    const QString m_json_file_name = "/home/nodo/variables/nodoUI.system.json";

    void writeJson(void);
};

#endif // NODO_UI_SYSTEM_PARSER_H


