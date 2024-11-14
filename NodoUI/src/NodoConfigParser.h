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
    Q_INVOKABLE void setMinerServiceStatus(bool status);
    Q_INVOKABLE void setMinerAddress(QString address);

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

    void setClearnetPort(QString port);
    void setTorPort(QString port);
    void setI2pPort(QString port);

    void setNodeBandwidthParameters(QString in_peers, QString out_peers, QString limit_rate_up, QString limit_rate_down);
    void setrpcEnabledStatus(bool status);
    void setrpcPort(QString port);

    void setMoneroPayParameters(QString address, QString viewKey);
    QString getMoneroPayAddress(void);
    QString getMoneroPayViewKey(void);

    Q_INVOKABLE bool getUpdateStatus(QString moduleName);
    Q_INVOKABLE void setUpdateStatus(QString moduleName, bool newStatus);


signals:
    void configParserReady(void);

private:
    void readFile(void);

    QJsonDocument m_document;
    QJsonObject m_rootObj;
    QJsonObject m_configObj;
    QJsonObject m_miningObj;
    QJsonObject m_ethernetObj;
    QJsonObject m_wifiObj;
    QJsonObject m_versionsObj;
    QJsonObject m_moneropayObj;
    QJsonObject m_autoupdateObj;

    const QString configObjName = "config";
    const QString miningObjName = "mining";
    const QString ethernetObjName = "ethernet";
    const QString wifiObjName = "wifi";
    const QString versionsObjName = "versions";
    const QString moneropayObjName = "moneropay";
    const QString autoupdateObjName = "autoupdate";

    QTimer *m_timer;
    QMutex m_mutex;

    const QString m_json_file_name =  "/home/nodo/variables/config.json";
    const QString m_json_lock_file_name = "/home/nodo/variables/config.json.lock";

    void writeJson(void);

private slots:
    void updateStatus(void);
};

#endif // NODO_CONFIG_PARSER_H


