#include "MoneroPay.h"
#include <algorithm>

MoneroPay::MoneroPay(NodoConfigParser *configParser)
{
    m_configParser = configParser;
    m_dbManager = new MoneroPayDbManager();
    m_mpayConnection = new MoneroPayConnection();
    connect(m_dbManager, SIGNAL(dbEntriesReady()), this, SLOT(getPreviousPaymentResults()));
    connect(m_mpayConnection, SIGNAL(healthResultReady(bool)), this, SLOT(healthResultReceived(bool)));

    // m_mpayConnection->checkHealth();
}

bool MoneroPay::isComponentEnabled(void)
{
    return m_componentEnabled;
}

void MoneroPay::clearAllPayments(void)
{
    for(int i = 0; i < m_paymentResults.size(); i++)
    {
        m_dbManager->deleteEntry(m_paymentResults.at(i).depositAddress);
    }

    m_paymentResults.clear();
    m_paymentID = 0;
    emit paymentListReady();
}

bool compareByDate(T_payment left, T_payment right)
{
    return right.dateTime < left.dateTime;
}

int MoneroPay::getPaymentCount(void)
{
    m_displayResults.clear();
    for(int i = 0; i < m_paymentResults.size(); i++)
    {
        m_displayResults.append(m_paymentResults.at(i));
    }
    if(m_displayResults.size() > 0)
    {
        std::sort(m_displayResults.begin(), m_displayResults.end(), compareByDate);
    }
    return m_displayResults.size();
}

void MoneroPay::updateRequested()
{
    if(isUpdateRequested)
    {
        return;
    }

    isUpdateRequested = true;
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
        return PAYMENT_SATUS_NONE;
    }

    return (int)m_displayResults.at(index).paymentStatus;
}

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

void MoneroPay::deletePayment(int index)
{
    m_dbManager->deleteEntry(m_displayResults.at(index).depositAddress);
    m_paymentResults.removeAt(m_displayResults.at(index).id);
    emit paymentListReady();
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
    emit depositAdressCleared();
}

int MoneroPay::getActivePaymentIndex(int id)
{
    return paymentIDList.indexOf(id);
}

int MoneroPay::getPaymentIndexbyAddress(QString address)
{
    int retval = -1;
    int size = m_paymentResults.size();
    for(int i = 0; i < size; i++)
    {
        retval = m_paymentResults.at(i).depositAddress.indexOf(address);
        if(-1 != retval)
        {
            return i;
        }
    }

    return retval;
}

void MoneroPay::paymentStatusReceived(int id)
{
    int index = getActivePaymentIndex(id);
    m_lastPayment = m_paymentRequests[index]->getPayment();
    m_lastPayment.signalDisabled = m_paymentResults[m_lastPayment.id].signalDisabled; //first, update signal disabled status of the last request

    m_paymentResults[m_lastPayment.id] = m_lastPayment;

    if(PAYMENT_SATUS_RECEIVED == m_lastPayment.paymentStatus)
    {
        delete m_paymentRequests[index];
        m_paymentRequests.removeAt(index);
        paymentIDList.removeAt(index);
        if(!m_lastPayment.isfromdb)
        {
            m_dbManager->setNewEntry(m_lastPayment);
            emit paymentUpdated();
        }

        if((!m_lastPayment.signalDisabled) && (!m_lastPayment.isfromdb))
        {
            getPaymentCount();
            emit paymentReceived();
        }
    }
    else if(PAYMENT_SATUS_PENDING == m_lastPayment.paymentStatus)
    {

    }
}

void MoneroPay::getPreviousPaymentResults(void)
{
    int size = m_dbManager->getDbEntrySize();

    for(int i = 0; i < size; i++)
    {
        T_payment p = m_dbManager->getEntry(i);
        p.id = m_paymentID;
        p.xmrAmountInPico = 0;

        MoneroPayConnection *tmp = new MoneroPayConnection(p);
        m_paymentResults.append(p);
        m_paymentRequests.append(tmp);
        paymentIDList.append(m_paymentID);

        connect(tmp, SIGNAL(paymentStatusChanged(int)), this, SLOT(paymentStatusReceived(int)));
        m_paymentRequests.at(m_paymentID)->requestPreviousPayment();
        m_paymentID++;
    }
}

void MoneroPay::xmrRequestPayment(QString xmrAmount, QString fiatAmount, int fiatIndex, QString description, int blockConfirmation)
{
    bool ok;
    double xmr = xmrAmount.toDouble(&ok);
    if(!ok)
    {
        return;
    }

    T_payment p;
    p.xmrAmountInPico = (qint64)(xmr*1000000000000);
    p.fiatAmount = fiatAmount.toDouble(&ok);
    p.description = description;
    p.blockConfirmation = blockConfirmation;
    p.fiatIndex = fiatIndex;
    p.id = m_paymentID;
    p.signalDisabled = false;
    p.isfromdb = false;

    MoneroPayConnection *tmp = new MoneroPayConnection(p);
    m_htmlDecodedDesctiption = description;

    m_paymentResults.append(p);
    m_paymentRequests.append(tmp);
    paymentIDList.append(m_paymentID);

    connect(tmp, SIGNAL(paymentStatusChanged(int)), this, SLOT(paymentStatusReceived(int)));
    connect(tmp, SIGNAL(depositAddressReceived(int)), this, SLOT(updateDepositAddress(int)));

    m_paymentID++;

    tmp->requestPayment();
}

double MoneroPay::getReceivedAmount(void)
{
    return m_lastPayment.xmrAmountInPico/1000000000000;
}

QDateTime MoneroPay::getReceivedTimestamp(void)
{
    return m_lastPayment.dateTime;
}

QString MoneroPay::getReceivedDepositAddress(void)
{
    return m_lastPayment.depositAddress;
}

QString MoneroPay::getReceivedTransactionID(void)
{
    return m_lastPayment.transactionIDList.at(0);
}

QString MoneroPay::getReceivedDescription(void)
{
    return m_lastPayment.description;
}

void MoneroPay::updateDepositAddress(int id)
{
    int index = getActivePaymentIndex(id);

    if(-1 == index)
    {
        return;
    }
    m_lastPayment = m_paymentRequests[index]->getPayment();
    m_paymentResults[id].depositAddress = m_lastPayment.depositAddress;
    m_paymentResults[id].paymentStatus = m_lastPayment.paymentStatus;
    m_paymentResults[id].dateTime = m_lastPayment.dateTime;

    emit depositAddressReceived();
}

QString MoneroPay::getReceivedDescriptionHTMLEncoded(void)
{
    if(m_htmlDecodedDesctiption.isEmpty())
    {
        return "";
    }

    QByteArray desc_url = QUrl::toPercentEncoding(m_htmlDecodedDesctiption);
    QString tmp = QString(desc_url);
    return tmp;
}

QDateTime MoneroPay::getTime(void)
{
    return QDateTime::currentDateTimeUtc();
}

void MoneroPay::cancelPayment(int paymentID)
{
    // if(-1 == paymentID)
    // {
    //     return;
    // }

    // int index = getActivePaymentIndex(paymentID);

    // if(-1 == index)
    // {
    //     return;
    // }
    // m_paymentRequests[index]->setSignalDisabled(true);
    m_paymentResults[paymentID].signalDisabled = true;
}

void MoneroPay::cancelPayment(QString address)
{
    int index = getPaymentIndexbyAddress(address);
    if(-1 == index)
    {
        return;
    }

    m_paymentResults[index].signalDisabled = true;
}

int MoneroPay::getLastPaymentID(void)
{
    return m_paymentID -1;
}

int MoneroPay::getDefaultBlockConfirmations(void)
{
    return m_defaultBlockConfirmations;
}

void MoneroPay::healthResultReceived(bool result)
{
    qDebug() << "moneropay health result: " << result;
}
