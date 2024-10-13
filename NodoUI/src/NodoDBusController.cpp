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
