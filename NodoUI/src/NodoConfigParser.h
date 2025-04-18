#ifndef NODO_CONFIG_PARSER_H
#define NODO_CONFIG_PARSER_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>
#include <QMutex>
#include <QThread>
#include <QMutexLocker>

class NodoConfigParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoConfigParser(QObject *parent = Q_NULLPTR);

    Q_INVOKABLE QString getStringValueFromKey(QString object, QString key);
    Q_INVOKABLE int getIntValueFromKey(QString object, QString key);
    Q_INVOKABLE void updateRequested(void);
    Q_INVOKABLE bool isUpdateLocked(void);

    QString getSelectedCurrencyName(void);
    void setCurrencyName(QString currency);

    double getExchangeRate(void);
    void setExchangeRate(double rate);

    QString getTimezone(void);
    void setTimezone(QString tz);

    QString getLanguageCode(void);
    void setLanguageCode(QString code);
    QString getDBPathDir(void);

    void setTheme(bool theme);
    bool getTheme(void);

    void setHiddenRPCEnabled(bool);
    void setTorEnabled(bool);
    void setI2PEnabled(bool);

    bool getBanlistEnabled(void);
    void setBanlistEnabled(bool);
    bool getBanlistsListEnabled(QString);
    void setBanlistsListEnabled(QString, bool);

    bool istorProxyEnabled();

    QString getSoftwareVersion(QString);

    void setClearnetPort(QString port);
    void setTorPort(QString port);
    void setI2pPort(QString port);

    void setNodeBandwidthParameters(QString in_peers, QString out_peers, QString limit_rate_up, QString limit_rate_down);
    void setrpcEnabledStatus(bool status);
    void setrpcPort(QString port);
    void setrpcUser(QString);
    void setrpcPassword(QString);
    void settorProxyEnabled(bool);

    void setMoneroPayParameters(QString address);
    QString getMoneroPayAddress(void);

    Q_INVOKABLE bool getUpdateStatus(QString moduleName);
    Q_INVOKABLE void setUpdateStatus(QString moduleName, bool newStatus);


signals:
    void configParserReady(void);
    void lockGone(void);

private:
    void readFile(void);

    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_configObj;
    QJsonObject m_ethernetObj;
    QJsonObject m_wifiObj;
    QJsonObject m_versionsObj;
    QJsonObject m_moneropayObj;
    QJsonObject m_autoupdateObj;
    QJsonObject m_banlistsObj;

    const QString configObjName = "config";
    const QString ethernetObjName = "ethernet";
    const QString wifiObjName = "wifi";
    const QString versionsObjName = "versions";
    const QString moneropayObjName = "moneropay";
    const QString autoupdateObjName = "autoupdate";
    const QString banlistsObjName = "banlists";

    QTimer *m_timer;
    QMutex m_mutex;

    const QString m_json_file_name =  "/home/nodo/variables/config.json";
    const QString m_json_lock_file_name = "/home/nodo/variables/config.json.lock";

    void writeJson(void);

private slots:
    void updateStatus(void);
    void checkLock(void);
};

#endif // NODO_CONFIG_PARSER_H


