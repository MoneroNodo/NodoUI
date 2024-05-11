#include "NodoDBusController.h"
#include <QDate>
NodoDBusController::NodoDBusController(QObject *parent) : QObject{parent}
{
    m_connectionStatus = false;
    nodo = new com::moneronodo::embeddedInterface("com.monero.nodo", "/com/monero/nodo", QDBusConnection::systemBus(), this);
    connect(nodo, SIGNAL(startRecoveryNotification(QString)), this, SLOT(updateTextEdit(QString)));
    connect(nodo, SIGNAL(serviceManagerNotification(QString)), this, SLOT(updateTextEdit(QString)));
    connect(nodo, SIGNAL(restartNotification(QString)), this, SLOT(updateTextEdit(QString)));
    connect(nodo, SIGNAL(shutdownNotification(QString)), this, SLOT(updateTextEdit(QString)));


    startTimer(1000);
}

void NodoDBusController::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);

    bool previousState = m_connectionStatus;
    if (nodo->isValid())
    {
        m_connectionStatus = true;
    }
    else
    {
        m_connectionStatus = false;
    }
    if(previousState == m_connectionStatus)
    {
        emit connectionStatusChanged();
    }
}

bool NodoDBusController::isConnected()
{
    return m_connectionStatus;
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
