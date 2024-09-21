#ifndef MONEROPAYDBMANAGER_H
#define MONEROPAYDBMANAGER_H

#include <QObject>
#include <QtSql>
#include <QTimer>
#include <QMutex>

#include "MoneroPayConnection.h"

#define CHEK_DB_TIMEOUT_IN_MS 10*60*1000

class MoneroPayDbManager : public QObject
{
    Q_OBJECT
public:
    explicit MoneroPayDbManager(QObject *parent = Q_NULLPTR);
    int getDbEntrySize(void);
    T_payment getEntry(int index);
    void deleteEntry(QString address);
    void setNewEntry(T_payment p);
    void deleteList(void);


private:
    QString m_dbPath = "/home/nodo/payments.sqlite";
    QSqlDatabase m_db;
    QTimer *m_timer;

    QList < T_payment > m_dbEntries;


private slots:
    void updateSubaddresses(void);

signals:
    void dbEntriesReady(void);
};

#endif // MONEROPAYDBMANAGER_H
