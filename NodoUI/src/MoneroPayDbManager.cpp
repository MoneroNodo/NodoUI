#include "MoneroPayDbManager.h"

MoneroPayDbManager::MoneroPayDbManager(QObject *parent) : QObject(parent)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(m_dbPath);

    m_timer = new QTimer(this);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(updateSubaddresses()));

    if (!m_db.open())
    {
        qDebug() << m_db.lastError();
    }
    else
    {
        if (!m_db.tables().contains( QLatin1String("payments"))) {
            qDebug() << "no table found. Creating table!";

            QSqlQuery query;
            query.exec("CREATE TABLE payments(subaddress TEXT UNIQUE NOT NULL, confirmations INTEGER, fiat_value REAL, fiat_index INTEGER)");
        }

        m_timer->start(0);
    }
}

void MoneroPayDbManager::updateSubaddresses(void)
{
    m_timer->stop();
    m_dbEntries.clear();

    QSqlQuery query("select * from payments");
    int addressIndex = query.record().indexOf("subaddress");
    int confIndex = query.record().indexOf("confirmations");
    int fiatAmountIndex = query.record().indexOf("fiat_value");
    int fiatIndexIndex = query.record().indexOf("fiat_index");

    while (query.next())
    {
        T_payment p;
        p.depositAddress = query.value(addressIndex).toString();
        p.blockConfirmation = query.value(confIndex).toInt();
        p.fiatAmount = query.value(fiatAmountIndex).toDouble();
        p.fiatIndex = query.value(fiatIndexIndex).toDouble();
        p.paymentStatus = PAYMENT_SATUS_NONE;
        p.signalDisabled = false;
        p.id = -1;
        p.isfromdb = true;

        m_dbEntries.push_front(p);
    }

    emit dbEntriesReady();
}

int MoneroPayDbManager::getDbEntrySize(void)
{
    return m_dbEntries.size();
}

T_payment MoneroPayDbManager::getEntry(int index)
{
    return m_dbEntries.at(index);
}

void MoneroPayDbManager::deleteList(void)
{
    m_dbEntries.clear();
}

void MoneroPayDbManager::deleteEntry(QString address)
{
    QSqlQuery query;
    query.exec("delete from payments where subaddress = '" + address + "'");
}

void MoneroPayDbManager::setNewEntry(T_payment p)
{
    QString q_str = "insert into payments (subaddress, confirmations, fiat_value, fiat_index) VALUES ('";
    q_str.append(p.depositAddress).append("','").append(QString::number(p.blockConfirmation)).append("','").append(QString::number(p.fiatAmount)).append("','").append(QString::number(p.fiatIndex)).append("')");
    QSqlQuery query;
    query.exec(q_str);
}
