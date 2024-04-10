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

class NodoConfigParser : public QObject
{
    Q_OBJECT
public:
    explicit NodoConfigParser(QObject *parent = Q_NULLPTR);

    Q_INVOKABLE QString getStringValueFromKey(QString object, QString key);
    Q_INVOKABLE int getIntValueFromKey(QString object, QString key);
    Q_INVOKABLE void updateRequested(void);

    QString getSelectedCurrencyName(void);
    void setCurrencyName(QString currency);

    QString getTimezone(void);
    void setTimezone(QString tz);

    QString getLanguageCode(void);
    void setLanguageCode(QString code);

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

    const QString configObjName = "config";
    const QString miningObjName = "mining";
    const QString ethernetObjName = "ethernet";
    const QString wifiObjName = "wifi";
    const QString versionsObjName = "versions";
    QTimer *m_timer;

    const QString m_json_file_name =  "/home/nodo/variables/config.json";

    void writeJson(void);

private slots:
    void updateStatus(void);
};

#endif // NODO_CONFIG_PARSER_H


