#include "NodoDBusController.h"
#include <QDate>
NodoDBusController::NodoDBusController(QObject *parent) : QObject{parent}
{
    m_dbusAdapterConnectionStatus = false;
    nodo = new com::moneronodo::embeddedInterface("com.monero.nodo", "/com/monero/nodo", QDBusConnection::systemBus(), this);
    connect(nodo, SIGNAL(serviceManagerNotification(QString)), this, SIGNAL(serviceManagerNotificationReceived(QString)));
    connect(nodo, SIGNAL(serviceStatusReadyNotification(QString)), this, SLOT(updateServiceStatus(QString)));
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
    nodo->startRecovery(recoverFS, rsyncBlockchain);
}

void NodoDBusController::serviceManager(QString operation, QString service)
{
    nodo->serviceManager(operation, service);
}

void NodoDBusController::restart()
{
    nodo->restart();
}

void NodoDBusController::shutdown()
{
    nodo->shutdown();
}

void NodoDBusController::updateTextEdit(QString message)
{
    Q_UNUSED(message);
}

void NodoDBusController::setBacklightLevel(int backlightLevel)
{
    nodo->setBacklightLevel(backlightLevel);
}

int NodoDBusController::getBacklightLevel(void)
{
    return nodo->getBacklightLevel();
}

void NodoDBusController::updateServiceStatus(QString message)
{
    emit serviceStatusReceived(message);
}
void NodoDBusController::getServiceStatus(void)
{
    nodo->getServiceStatus();
}

double NodoDBusController::getCPUUsage(void)
{
    return nodo->getCPUUsage();
}

double NodoDBusController::getAverageCPUFreq(void)
{
    return nodo->getAverageCPUFreq();
}

double NodoDBusController::getRAMUsage(void)
{
    return nodo->getRAMUsage();
}

double NodoDBusController::getTotalRAM(void)
{
    return nodo->getTotalRAM();
}

double NodoDBusController::getCPUTemperature(void)
{
    return nodo->getCPUTemperature();
}

double NodoDBusController::getBlockchainStorageUsage(void)
{
    return nodo->getBlockchainStorageUsage();
}

double NodoDBusController::getTotalBlockchainStorage(void)
{
    return nodo->getTotalBlockchainStorage();
}

double NodoDBusController::getSystemStorageUsage(void)
{
    return nodo->getSystemStorageUsage();
}

double NodoDBusController::getTotalSystemStorage(void)
{
    return nodo->getTotalSystemStorage();
}

void NodoDBusController::setPassword(QString pw)
{
    nodo->setPassword(pw);
}

double NodoDBusController::getGPUUsage(void)
{
    return nodo->getGPUUsage();
}

double NodoDBusController::getMaxGPUSpeed(void)
{
    return nodo->getMaxGPUSpeed();
}

double NodoDBusController::getCurrentGPUSpeed(void)
{
    return nodo->getCurrentGPUSpeed();
}

void NodoDBusController::factoryResetApproved(void)
{
    nodo->factoryResetApproved();
}

int NodoDBusController::getBlockchainStorageStatus(void)
{
    return nodo->getBlockchainStorageStatus();
}
