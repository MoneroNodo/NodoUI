#include "NodoSystemControl.h"


NodoSystemControl::NodoSystemControl(NodoEmbeddedUIConfigParser *embeddedUIConfigParser) : QObject(embeddedUIConfigParser)
{
    m_appTheme = false;
    setAppTheme(m_appTheme);
    m_embeddedUIConfigParser = embeddedUIConfigParser;
    m_feeds_str = embeddedUIConfigParser->readFeedKeys();
    m_displaySettings = embeddedUIConfigParser->readDisplaySettings();

    m_controller = new NodoDBusController(this);

    m_connectionStatus = m_controller->isConnected();

    if(m_connectionStatus)
    {
        qDebug() << "Connected to the dbus daemon";
    }
    else
    {
        qDebug() << "Couldn't connect to the dbus daemon";
    }

    connect(m_controller, SIGNAL(connectionStatusChanged()), this, SLOT(updateConnectionStatus()));
}

bool NodoSystemControl::getAppTheme(void)
{
    // qDebug() << "get theme: " << m_appTheme;
    return m_appTheme;
}

void NodoSystemControl::setAppTheme(bool appTheme)
{
    // qDebug() << "set theme: " << appTheme;
    m_appTheme = appTheme;
    emit appThemeChanged(m_appTheme);
}


void NodoSystemControl::setVisibleState(int index, bool state)
{
    m_embeddedUIConfigParser->writeFeedKeys(KEY_VISIBLE, index, state);
    m_feeds_str.clear();
    m_feeds_str = m_embeddedUIConfigParser->readFeedKeys();
}


bool NodoSystemControl::getVisibleState(int index)
{
    return m_feeds_str[index].visibleItem;
}


void NodoSystemControl::setSelectedState(int index, bool state)
{
    m_embeddedUIConfigParser->writeFeedKeys(KEY_SELECTED, index, state);
    m_feeds_str.clear();
    m_feeds_str = m_embeddedUIConfigParser->readFeedKeys();
}


QString NodoSystemControl::getFeederNameState(int index)
{
    return m_feeds_str[index].nameItem;
}


bool NodoSystemControl::getSelectedState(int index)
{
    return m_feeds_str[index].selectedItem;
}


void NodoSystemControl::setScreenSaverType(int state)
{
    m_embeddedUIConfigParser->writeScreenSaverType(state);
    m_displaySettings = m_embeddedUIConfigParser->readDisplaySettings();
}


int NodoSystemControl::getScreenSaverType(void)
{
    return m_displaySettings.useFeedsAsScreenSaver;
}


void NodoSystemControl::setScreenSaverTimeout(int timeout)
{
    m_embeddedUIConfigParser->writeScreenSaverTimeout(timeout);
    m_displaySettings = m_embeddedUIConfigParser->readDisplaySettings();
}


int NodoSystemControl::getScreenSaverTimeout(void)
{
    return m_displaySettings.screenSaverTimeoutInSec*1000;
}


void NodoSystemControl::setScreenSaverItemChangeTimeout(int timeout)
{
    m_embeddedUIConfigParser->writeScreenSaverItemChangeTimeout(timeout);
    m_displaySettings = m_embeddedUIConfigParser->readDisplaySettings();
}


int NodoSystemControl::getScreenSaverItemChangeTimeout(void)
{
    return m_displaySettings.screenSaverItemChangeTimeoutInSec*1000;
}


void NodoSystemControl::updateConnectionStatus(void)
{
    bool isConnected = m_controller->isConnected();
    if(m_connectionStatus == isConnected)
    {
        return;
    }

    if(isConnected)
    {
        qDebug() << "Connected to the dbus daemon";
    }
    else
    {
        qDebug() << "Disconnected from the dbus daemon";
    }

    m_connectionStatus = isConnected;
}

void NodoSystemControl::restartDevice()
{
    m_controller->restart();
}

void NodoSystemControl::shutdownDevice()
{
    m_controller->shutdown();
}

void NodoSystemControl::systemRecovery(int recoverFS, int rsyncBlockchain)
{
    m_controller->startRecovery(recoverFS, rsyncBlockchain);
}
