#include "MoneroPay.h"
#include <algorithm>

MoneroPay::MoneroPay(NodoConfigParser *configParser)
{
    m_configParser = configParser;
    m_dbManager = new MoneroPayDbManager();
    m_mpayConnection = new MoneroPayConnection();
    connect(m_dbManager, SIGNAL(dbEntriesReady()), this, SLOT(getPreviousPaymentResults()));

    m_lastPayment.paymentStatus = PAYMENT_STATUS_NONE;
    m_lastPayment.blockConfirmation = 10;
    m_lastPayment.depositAddress = "n/a";
    m_lastPayment.description = "n/a";
    m_lastPayment.fiatAmount = 0;
    m_lastPayment.xmrAmountInPico = 0;

    QDateTime date;
    QString s = "1970-01-01T00:00:00";
    date = QDateTime::fromString(s,"yyyy-MM-ddThh:mm:ss");
    m_lastPayment.dateTime = date;
}

bool compareByDate(payment_t left, payment_t right)
{
    return right.dateTime < left.dateTime;
}

int MoneroPay::getPaymentIndexbyID(int id)
{
    for(int i = 0; i < m_payments.size(); i++)
    {
        if(id == m_payments[i].id)
            return i;
    }

    return -1;
}

int MoneroPay::getRequestIndexbyID(int id)
{
    for(int i = 0; i < paymentIDList.size(); i++)
    {
        if(id == paymentIDList[i])
            return i;
    }

    return -1;
}

void MoneroPay::paymentStatusReceived(void)
{
    MoneroPayConnection *tmpc = qobject_cast<MoneroPayConnection*>(sender());
    int index = 0;
    int id = tmpc->getID();
    index = getPaymentIndexbyID(id);

    if(-1 == index)
    {
        return;
    }
    m_lastPayment = tmpc->getPayment();
    m_payments[index] = m_lastPayment;
    if(PAYMENT_STATUS_RECEIVED == m_lastPayment.paymentStatus)
    {
        int tmp = getRequestIndexbyID(id);
        delete m_mpayRequests[tmp];
        m_mpayRequests.removeAt(tmp);
        paymentIDList.removeAt(tmp);

        if(!m_lastPayment.isfromdb)
        {
            getPaymentCount();
            emit paymentReceived();
        }
        else
        {
            emit paymentListReady();
        }
    }
}

void MoneroPay::updateDepositAddress(void)
{
    int index = 0;
    MoneroPayConnection *tmpc = qobject_cast<MoneroPayConnection*>(sender());
    index = getPaymentIndexbyID(tmpc->getID());

    if(-1 == index)
    {
        return;
    }
    m_lastPayment = tmpc->getPayment();
    m_payments[index] = m_lastPayment;
    m_dbManager->setNewEntry(m_lastPayment);

    emit depositAddressReceived();
}

void MoneroPay::xmrRequestPayment(QString xmrAmount, QString fiatAmount, int fiatIndex, QString description, int blockConfirmation)
{
    bool ok;
    double xmr = xmrAmount.toDouble(&ok);
    if(!ok)
    {
        return;
    }

    payment_t p;
    p.xmrAmountInPico = (qint64)(xmr*1000000000000);
    p.fiatAmount = fiatAmount.toDouble(&ok);
    p.description = description;
    p.blockConfirmation = blockConfirmation;
    p.fiatIndex = fiatIndex;
    p.id = m_paymentID;
    p.isfromdb = false;

    MoneroPayConnection *tmpc = new MoneroPayConnection(p);
    m_htmlDecodedDesctiption = description;

    m_payments.append(p);
    m_mpayRequests.append(tmpc);
    paymentIDList.append(m_paymentID);

    connect(tmpc, SIGNAL(paymentStatusChanged()), this, SLOT(paymentStatusReceived()));
    connect(tmpc, SIGNAL(depositAddressReceived()), this, SLOT(updateDepositAddress()));

    m_paymentID++;

    tmpc->requestPayment();
}

void MoneroPay::getPreviousPaymentResults(void)
{
    int size = m_dbManager->getDbEntrySize();

    for(int i = 0; i < size; i++)
    {
        payment_t p = m_dbManager->getEntry(i);
        p.id = m_paymentID;
        p.xmrAmountInPico = 0;

        MoneroPayConnection *tmp = new MoneroPayConnection(p);
        m_payments.append(p);
        m_mpayRequests.append(tmp);
        paymentIDList.append(m_paymentID);

        connect(tmp, SIGNAL(paymentStatusChanged()), this, SLOT(paymentStatusReceived()));
        m_mpayRequests.at(m_paymentID)->requestPreviousPayment();
        m_paymentID++;
    }
}

int MoneroPay::getPaymentCount(void)
{
    m_displayResults.clear();
    for(int i = 0; i < m_payments.size(); i++)
    {
        m_displayResults.append(m_payments.at(i));
    }
    if(m_displayResults.size() > 0)
    {
        std::sort(m_displayResults.begin(), m_displayResults.end(), compareByDate);
    }
    return m_displayResults.size();
}

void MoneroPay::clearAllPayments(void)
{
    int size = m_mpayRequests.size();
    for(int i = 0; i < size; i++)
    {
        delete m_mpayRequests[i];
    }

    m_mpayRequests.clear();
    paymentIDList.clear();
    m_payments.clear();
    m_displayResults.clear();

    m_dbManager->deleteAllEntries();

    emit paymentListReady();
}

void MoneroPay::deletePayment(QString address)
{
    int index = getPaymentIndexbyAddress(address);
    if(index == -1)
    {
        return;
    }

    int tmpid = m_payments[index].id;
    int index2 = getRequestIndexbyPaymentID(tmpid);
    if(index2 != -1)
    {
        delete m_mpayRequests[index2];
        m_mpayRequests.removeAt(index2);
        paymentIDList.removeAt(index2);
    }

    m_payments.removeAt(index);
    m_dbManager->deleteEntry(address);
    emit paymentListReady();
}

int MoneroPay::getRequestIndexbyPaymentID(int ID)
{
    int size = paymentIDList.size();
    for(int i = 0; i < size; i++)
    {
        if(paymentIDList.at(i) == ID)
        {
            return i;
        }
    }
    return -1;
}

int MoneroPay::getPaymentIndexbyAddress(QString address)
{
    int size = m_payments.size();
    for(int i = 0; i < size; i++)
    {
        if(m_payments.at(i).depositAddress.contains(address))
        {
            return i;
        }
    }

    return -1;
}

bool MoneroPay::isComponentEnabled(void)
{
    return m_componentEnabled;
}

qint64 MoneroPay::getPaymentAmount(int index)
{
    if(m_displayResults.size() <= index)
    {
        return -1;
    }
    return m_displayResults.at(index).xmrAmountInPico;
}

double MoneroPay::getFiatAmount(int index)
{
    if(m_displayResults.size() <= index)
    {
        return -1;
    }

    return m_displayResults.at(index).fiatAmount;
}

int MoneroPay::getPaymentStatus(int index)
{
    if(m_displayResults.size() <= index)
    {
        return PAYMENT_STATUS_NONE;
    }

    return (int)m_displayResults.at(index).paymentStatus;}

QDateTime MoneroPay::getPaymentTimestamp(int index)
{
    if(m_displayResults.size() <= index)
    {
        QDateTime date;
        QString s = "1970-01-01T00:00:00";
        date = QDateTime::fromString(s,"yyyy-MM-ddThh:mm:ss");
        return date;
    }
    return m_displayResults.at(index).dateTime;
}

QString MoneroPay::getPaymentDepositAddress(int index)
{
    if(m_displayResults.size() <= index)
    {
        return "n/a";
    }
    return m_displayResults.at(index).depositAddress;
}

QString MoneroPay::getPaymentTransactionID(int p_index, int t_index)
{
    if(m_displayResults.size() <= p_index)
    {
        return "n/a";
    }
    if(m_displayResults.at(p_index).transactionIDList.size() <= t_index)
    {
        return "n/a";
    }

    return m_displayResults.at(p_index).transactionIDList.at(t_index);
}

QString MoneroPay::getPaymentDescription(int index)
{
    if(m_displayResults.size() <= index)
    {
        return "n/a";
    }

    return m_displayResults.at(index).description;
}

int MoneroPay::transactionIDSize(int index)
{
    return m_displayResults.at(index).transactionIDList.size();
}

void MoneroPay::enableComponent(bool enabled)
{
    m_componentEnabled = enabled;
    emit componentEnabledStatusChanged();
}

void MoneroPay::setDepositAddress(QString address, QString viewKey)
{
    QFile::remove(m_mpayFile);
    QFile::remove(m_mpayKeyFile);

    m_configParser->setMoneroPayParameters(address, viewKey);
    emit depositAddressSet(address, viewKey);
}

QString MoneroPay::getMoneroPayAddress(void)
{
    return m_configParser->getMoneroPayAddress();
}

QString MoneroPay::getMoneroPayViewKey(void)
{
    return m_configParser->getMoneroPayViewKey();
}

void MoneroPay::clearDepositAddress(void)
{
    enableComponent(false);
    m_configParser->setMoneroPayParameters("", "");
    enableComponent(true);
    emit depositAddressCleared();
}

double MoneroPay::getLastXMRAmount(void)
{
    return m_lastPayment.xmrAmountInPico/1000000000000.0;
}

double MoneroPay::getLastFiatAmount(void)
{
    return m_lastPayment.fiatAmount;
}

QDateTime MoneroPay::getLastTimestamp(void)
{   
    return m_lastPayment.dateTime;
}

QString MoneroPay::getLastDepositAddress(void)
{
    if(m_lastPayment.depositAddress.isEmpty())
    {
        return "n/a";
    }
    return m_lastPayment.depositAddress;
}

QString MoneroPay::getLastTransactionID(void)
{
    if(m_lastPayment.transactionIDList.isEmpty())
    {
        return "n/a";
    }

    return m_lastPayment.transactionIDList.at(0);
}

QString MoneroPay::getLastDescription(void)
{
    return m_lastPayment.description;
}

QString MoneroPay::getLastDescriptionHTMLEncoded(void)
{
    if(m_htmlDecodedDesctiption.isEmpty())
    {
        return "";
    }

    QByteArray desc_url = QUrl::toPercentEncoding(m_htmlDecodedDesctiption);
    QString tmp = QString(desc_url);
    return tmp;
}

QString MoneroPay::getDescriptionHTMLEncoded(int index)
{
    if(m_displayResults.size() <= index)
    {
        return "";
    }

    if(m_displayResults.at(index).description.isEmpty())
    {
        return "";
    }

    QByteArray desc_url = QUrl::toPercentEncoding(m_displayResults.at(index).description);
    QString tmp = QString(desc_url);
    return tmp;
}

int MoneroPay::getDefaultBlockConfirmations(void)
{
    return m_defaultBlockConfirmations;
}

void MoneroPay::newPaymentRequest(void)
{
    emit newPaymentRequested();
}

void MoneroPay::openViewPaymentsScreenRequest(void)
{
    emit openViewPaymentsScreenRequested();
}

bool MoneroPay::isDepositAddressSet(void)
{
    return m_isDepositAddressSet;
}

void MoneroPay::setDepositAddressSet(bool set)
{
    m_isDepositAddressSet = set;
}
