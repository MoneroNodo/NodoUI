#ifndef NODO_SYSTEM_CONTROL_H
#define NODO_SYSTEM_CONTROL_H
#include <QObject>
#include <QNetworkProxy>
#include "NodoUISystemParser.h"
#include "NodoConfigParser.h"
#include "NodoDBusController.h"
#include <QTimeZone>
#include <QTimer>
#include "NodoNotificationMessages.h"

// #define ENABLE_TEST_CODE

class NodoSystemControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool appTheme READ getAppTheme WRITE setAppTheme NOTIFY appThemeChanged)

public:
    NodoSystemControl(NodoUISystemParser *uiSystemParser = Q_NULLPTR, NodoConfigParser *configParser = Q_NULLPTR, NodoDBusController *dbusController = Q_NULLPTR);

    bool getAppTheme(void);
    void setAppTheme(bool appTheme);

    Q_INVOKABLE void setScreenSaverType(int state);
    Q_INVOKABLE int getScreenSaverType(void);

    Q_INVOKABLE void setScreenSaverTimeout(int timeout);
    Q_INVOKABLE int getScreenSaverTimeout(void);

    Q_INVOKABLE void setScreenSaverItemChangeTimeout(int timeout);
    Q_INVOKABLE int getScreenSaverItemChangeTimeout(void);

    Q_INVOKABLE void restartDevice();
    Q_INVOKABLE void shutdownDevice();
    Q_INVOKABLE void updateDevice();
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

    Q_INVOKABLE QString getServiceStatus(QString serviceName);

    Q_INVOKABLE QString getUptime(void);
    Q_INVOKABLE QString getCPUUsage(void);
    Q_INVOKABLE QString getTemperature(void);
    Q_INVOKABLE QString getRAMUsage(void);
    Q_INVOKABLE QString getBlockChainStorageUsage(void);
    Q_INVOKABLE QString getSystemStorageUsage(void);

    Q_INVOKABLE void setPassword(QString pw);
    Q_INVOKABLE void changePassword(QString oldPassword, QString newPassword);
    Q_INVOKABLE void serviceManager(QString operation, QString service);

    Q_INVOKABLE void restartScreenSaverTimer(void);
    Q_INVOKABLE void stopScreenSaverTimer(void);

    Q_INVOKABLE bool getBanlistEnabled(void);
    Q_INVOKABLE void setBanlistEnabled(bool);
    Q_INVOKABLE bool getBanlistsListEnabled(QString);
    Q_INVOKABLE void setBanlistsListEnabled(QString, bool);

    Q_INVOKABLE void setClearnetPort(QString port);
    Q_INVOKABLE void setTorPort(QString port);
    Q_INVOKABLE void setI2pPort(QString port);
    Q_INVOKABLE void settorProxyEnabled(bool enabled);
    Q_INVOKABLE void setTickerEnabled(bool enabled);
    Q_INVOKABLE void setFeedsEnabled(bool enabled);
    Q_INVOKABLE void set24hEnabled(bool enabled);

    Q_INVOKABLE int getErrorCode(void);

    Q_INVOKABLE void setNodeBandwidthParameters(QString in_peers, QString out_peers, QString limit_rate_up, QString limit_rate_down);

    Q_INVOKABLE bool isComponentEnabled(void);

    Q_INVOKABLE bool getrpcEnabledStatus(void);
    Q_INVOKABLE void setrpcEnabledStatus(bool status);
    Q_INVOKABLE int getclearnetPort(void);
    Q_INVOKABLE int gettorPort(void);
    Q_INVOKABLE int geti2pPort(void);
    Q_INVOKABLE int getrpcPort(void);
    Q_INVOKABLE void setrpcPort(QString port);
    Q_INVOKABLE QString getrpcUser(void);
    Q_INVOKABLE QString getrpcPassword(void);
    Q_INVOKABLE void setrpcUser(QString);
    Q_INVOKABLE void setrpcPassword(QString);
    Q_INVOKABLE bool istorProxyEnabled(void);
    Q_INVOKABLE bool isTickerEnabled(void);
    Q_INVOKABLE bool isFeedsEnabled(void);
    Q_INVOKABLE bool is24hEnabled(void);


    Q_INVOKABLE bool isLockPinEnabled(void);
    Q_INVOKABLE bool verifyLockPinCode(QString pin);
    Q_INVOKABLE void setLockPin(QString newPin);
    Q_INVOKABLE void disableLockPin(void);
    Q_INVOKABLE void enableLockPin(void);
    Q_INVOKABLE int getLockAfterTime(void);
    Q_INVOKABLE void setLockAfterTime(QString newTime);

    Q_INVOKABLE void restartLockScreenTimer(void);
    Q_INVOKABLE void stopLockScreenTimer(void);
    Q_INVOKABLE void closePopup(void);

    Q_INVOKABLE void setHiddenRPCEnabled(bool);
    Q_INVOKABLE void setTorEnabled(bool);
    Q_INVOKABLE void setI2PEnabled(bool);

    Q_INVOKABLE QString getSoftwareVersion(QString);
    Q_INVOKABLE int getKeyboardLayoutType(void);
    Q_INVOKABLE void setKeyboardLayoutType(int kbLayout);
    Q_INVOKABLE QString getKeyboardLayoutLocale(void);

    Q_INVOKABLE bool isFirstBootConfigDone(void);
    Q_INVOKABLE void setFirstBootConfigDone(void);
    Q_INVOKABLE void setAddressPin(QString newPIN);
    Q_INVOKABLE bool verifyAddressPinCode(QString pin);

    Q_INVOKABLE void factoryResetApproved(void);
    Q_INVOKABLE int getBlockchainStorageStatus(void);

    Q_INVOKABLE bool isPasswordValid(QString password);
    Q_INVOKABLE void sendUpdate(void);


signals:
    void appThemeChanged(bool);
    void inputFieldTextChanged(void);
    void echoModeChanged(void);
    void passwordModeChanged(void);
    void orientationChanged(void);
    void serviceStatusReady(void);
    void systemStatusReady(void);
    void screenSaverTimedout(void);
    void lockScreenTimedout(void);
    void errorDetected(void);
    void componentEnabledStatusChanged(void);
    void closePopupRequested(void);
    void passwordChangeStatus(int status);
    void feedsEnabledChanged(bool);
    void tickerEnabledChanged(bool);
    void _24hEnabledChanged(bool);
    void torProxyEnabledChanged(bool);

    void factoryResetStarted(void);
    void factoryResetRequested(void);
    void factoryResetCompleted(void);
    void powerButtonPressDetected(void);
    void powerButtonReleaseDetected(void);
    void serviceManagerNotificationReceived(QString); // delegate

private:
    bool m_appTheme;

    display_settings_t m_displaySettings;
    NodoUISystemParser *m_uiSystemParser;
    NodoConfigParser *m_configParser;
    NodoDBusController *m_dbusController;

    NodoNotifier m_notifier;
    bool m_componentEnabled = true;

    bool m_dbusConnectionStatus;
    int m_tz_id;
    QString m_timezone;
    QString m_inputFieldText;
    int m_echoMode = -1;
    int m_passwordMode = -1;
    QString m_serviceStatusMessage;
    int m_errorCode;
    bool m_firstBootDone = false;
    QString m_firstBootFileName = "/home/nodo/variables/firstboot";

    QString m_uptime;
    QString m_CPUUsage;
    QString m_Temperature;
    QString m_RAMUsage;
    QString m_blockchainStorage;
    QString m_systemStorage;
    QTimer *m_screenSaverTimer;
    QTimer *m_lockScreenTimer;

    QStringList m_tzList = {
        "UTC",
        "Europe/London",
        "Europe/Berlin",
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

    void enableComponent(bool enabled);

private slots:
    void updateDbusConnectionStatus(void);
    void updateServiceStatus(QString statusMessage);
    void sstimedout(void);
    void lstimedout(void);
    void processNotification(QString message);
    void passwordChangeStatusReceived(int status);
    void updateHardwareStatus(QString message);


#ifdef ENABLE_TEST_CODE
    void testSlotFunction(void);
    void processNotificationTest(void);
#endif
};


#endif // NODO_SYSTEM_CONTROL_H
