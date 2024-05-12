#ifndef NODO_SYSTEM_CONTROL_H
#define NODO_SYSTEM_CONTROL_H
#include <QObject>
#include "NodoEmbeddedUIConfigParser.h"
#include "NodoConfigParser.h"
#include "NodoDBusController.h"
#include <QTimeZone>

class NodoSystemControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool appTheme READ getAppTheme WRITE setAppTheme NOTIFY appThemeChanged)

public:
    NodoSystemControl(NodoEmbeddedUIConfigParser *embeddedUIConfigParser = Q_NULLPTR, NodoConfigParser *configParser = Q_NULLPTR);

    bool getAppTheme(void);
    void setAppTheme(bool appTheme);


    Q_INVOKABLE void setVisibleState(int index, bool state);
    Q_INVOKABLE bool getVisibleState(int index);

    Q_INVOKABLE void setSelectedState(int index, bool state);
    Q_INVOKABLE bool getSelectedState(int index);

    Q_INVOKABLE QString getFeederNameState(int index);

    Q_INVOKABLE void setScreenSaverType(int state);
    Q_INVOKABLE int getScreenSaverType(void);

    Q_INVOKABLE void setScreenSaverTimeout(int timeout);
    Q_INVOKABLE int getScreenSaverTimeout(void);

    Q_INVOKABLE void setScreenSaverItemChangeTimeout(int timeout);
    Q_INVOKABLE int getScreenSaverItemChangeTimeout(void);

    Q_INVOKABLE void restartDevice();
    Q_INVOKABLE void shutdownDevice();
    Q_INVOKABLE void systemRecovery(int recoverFS, int rsyncBlockchain);

    Q_INVOKABLE void setTimeZoneIndex(int tz_id);
    Q_INVOKABLE QDateTime getChangedDateTime(void);
    Q_INVOKABLE int getTimeZoneIndex(void);

    Q_INVOKABLE void setInputFieldText(QString text);
    Q_INVOKABLE QString getInputFieldText(void);

    Q_INVOKABLE void setEchoMode(int echoMode);
    Q_INVOKABLE int getEchoMode(void);

    Q_INVOKABLE void setPasswordMode(int passwordMode);
    Q_INVOKABLE int getPasswordMode(void);

    Q_INVOKABLE void setOrientation(int orientation);
    Q_INVOKABLE int getOrientation(void);

    Q_INVOKABLE void setBacklightLevel(int backlightLevel);
    Q_INVOKABLE int getBacklightLevel(void);

    Q_INVOKABLE void startServiceStatusUpdate(void);
    Q_INVOKABLE QString getServiceStatus(QString serviceName);

signals:
    void appThemeChanged(bool);
    void inputFieldTextChanged(void);
    void echoModeChanged(void);
    void passwordModeChanged(void);
    void orientationChanged(void);
    void serviceStatusReady(void);

private:
    bool m_appTheme;
    QVector< feeds_t > m_feeds_str;
    display_settings_t m_displaySettings;
    NodoEmbeddedUIConfigParser *m_embeddedUIConfigParser;
    NodoConfigParser *m_configParser;
    NodoDBusController *m_controller;
    bool m_connectionStatus;
    int m_tz_id;
    QString m_timezone;
    QString m_inputFieldText;
    int m_echoMode = -1;
    int m_passwordMode = -1;
    QString m_serviceStatusMessage;

    QStringList m_tzList = {
        "UTC",
        "Europe/London",
        "Europe/Bucharest",
        "Europe/Moscow",
        "Asia/Tehran",
        "Asia/Dubai",
        "Asia/Kabul",
        "Asia/Karachi",
        "Asia/Calcutta",
        "Asia/Katmandu",
        "Asia/Dhaka",
        "Asia/Rangoon",
        "Asia/Bangkok",
        "Asia/Singapore",
        "Australia/Darwin",
        "Asia/Tokyo",
        "Australia/Adelaide",
        "Australia/Brisbane",
        "Australia/Lord_Howe",
        "Australia/Currie",
        "Pacific/Kosrae",
        "Pacific/Auckland",
        "Pacific/Chatham",
        "Pacific/Tongatapu",
        "UTC+14:00",
        "Atlantic/Cape_Verde",
        "America/Noronha",
        "America/Cayenne",
        "America/St_Johns",
        "America/St_Kitts",
        "America/Caracas",
        "America/New_York",
        "America/Edmonton",
        "America/Denver",
        "America/Los_Angeles",
        "America/Anchorage",
        "America/Adak",
        "Pacific/Midway",
        "UTC-12:00",
        "UTC-13:00",
    };

private slots:
    void updateConnectionStatus(void);
    void updateServiceStatus(QString statusMessage);

};


#endif // NODO_SYSTEM_CONTROL_H
