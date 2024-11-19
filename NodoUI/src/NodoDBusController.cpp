#include "NodoDBusController.h"
#include <QDate>
NodoDBusController::NodoDBusController(QObject *parent) : QObject{parent}
{
    m_dbusAdapterConnectionStatus = false;
    nodo = new com::moneronodo::embeddedInterface("com.monero.nodo", "/com/monero/nodo", QDBusConnection::systemBus(), this);
    connect(nodo, SIGNAL(serviceManagerNotification(QString)), this, SIGNAL(serviceManagerNotificationReceived(QString)));
    connect(nodo, SIGNAL(hardwareStatusReadyNotification(QString)), this, SIGNAL(hardwareStatusReadyNotification(QString)));
    connect(nodo, SIGNAL(serviceStatusReadyNotification(QString)), this, SIGNAL(serviceStatusReceived(QString)));
    connect(nodo, SIGNAL(passwordChangeStatus(int)), this, SIGNAL(passwordChangeStatus(int)));
    connect(nodo, SIGNAL(factoryResetStarted()), this, SIGNAL(factoryResetStarted()));
    connect(nodo, SIGNAL(factoryResetCompleted()), this, SIGNAL(factoryResetCompleted()));
    connect(nodo, SIGNAL(factoryResetRequested()), this, SIGNAL(factoryResetRequested()));
    connect(nodo, SIGNAL(powerButtonPressDetected()), this, SIGNAL(powerButtonPressDetected()));
    connect(nodo, SIGNAL(powerButtonReleaseDetected()), this, SIGNAL(powerButtonReleaseDetected()));

    connect(nodo, SIGNAL(moneroLWSListAccountsCompleted()), this, SIGNAL(moneroLWSListAccountsCompleted()));
    connect(nodo, SIGNAL(moneroLWSListRequestsCompleted()), this, SIGNAL(moneroLWSListRequestsCompleted()));
    connect(nodo, SIGNAL(moneroLWSAccountAdded()), this, SIGNAL(moneroLWSAccountAdded()));

    connect(nodo, SIGNAL(connectionStatusChanged()), this, SIGNAL(networkConnectionStatusChanged()));

    startTimer(1000);
}

void NodoDBusController::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);

    bool previousState = m_dbusAdapterConnectionStatus;
    if (nodo->isValid())
    {
        m_dbusAdapterConnectionStatus = true;
    }
    else
    {
        m_dbusAdapterConnectionStatus = false;
    }
    if(previousState != m_dbusAdapterConnectionStatus)
    {
        qDebug() << "m_dbusAdapterConnectionStatus";
        emit dbusConnectionStatusChanged();
    }
}

bool NodoDBusController::isConnected()
{
    return m_dbusAdapterConnectionStatus;
}

void NodoDBusController::startRecovery(int recoverFS, int rsyncBlockchain)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->startRecovery(recoverFS, rsyncBlockchain);
}

void NodoDBusController::serviceManager(QString operation, QString service)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->changeServiceStatus(operation, service);
}

void NodoDBusController::update()
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->update();
}

void NodoDBusController::restart()
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->restart();
}

void NodoDBusController::shutdown()
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->shutdown();
}

void NodoDBusController::setBacklightLevel(int backlightLevel)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->setBacklightLevel(backlightLevel);
}

int NodoDBusController::getBacklightLevel(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return 0;
    }
    return nodo->getBacklightLevel();
}

void NodoDBusController::setPassword(QString pw)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->setPassword(pw);
}

void NodoDBusController::changePassword(QString oldPassword, QString newPassword)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->changePassword(oldPassword, newPassword);
}

void NodoDBusController::factoryResetApproved(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->factoryResetApproved();
}

int NodoDBusController::getBlockchainStorageStatus(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return 0;
    }
    return nodo->getBlockchainStorageStatus();
}

void NodoDBusController::moneroLWSAddAccount(QString address, QString privateKey)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSAddAccount(address, privateKey);
}

void NodoDBusController::moneroLWSDeleteAccount(QString address)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSDeleteAccount(address);
}

void NodoDBusController::moneroLWSReactivateAccount(QString address)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSReactivateAccount(address);
}

void NodoDBusController::moneroLWSDeactivateAccount(QString address)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSDeactivateAccount(address);
}

void NodoDBusController::moneroLWSRescan(QString address, QString height)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSRescan(address, height);
}

void NodoDBusController::moneroLWSAcceptAllRequests(QString requests)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSAcceptAllRequests(requests);
}

void NodoDBusController::moneroLWSAcceptRequest(QString address)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSAcceptRequest(address);
}

void NodoDBusController::moneroLWSRejectRequest(QString address)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSRejectRequest(address);
}

QString NodoDBusController::moneroLWSGetAccountList(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return "";
    }
    return nodo->moneroLWSGetAccountList();
}

QString NodoDBusController::moneroLWSGetRequestList(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return "";
    }
    return nodo->moneroLWSGetRequestList();
}

void NodoDBusController::moneroLWSListAccounts(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSListAccounts();
}

void NodoDBusController::moneroLWSListRequests(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return;
    }
    nodo->moneroLWSListRequests();
}

int NodoDBusController::getNetworkConnectionStatus(void)
{
    if(false == m_dbusAdapterConnectionStatus)
    {
        return 0;
    }
    return nodo->getConnectionStatus();
}
