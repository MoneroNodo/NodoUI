#include "NodoSystemControl.h"


NodoSystemControl::NodoSystemControl(NodoEmbeddedUIConfigParser *embeddedUIConfigParser, NodoConfigParser *configParser) : QObject(embeddedUIConfigParser)
{
    m_appTheme = false;
    setAppTheme(m_appTheme);

    m_embeddedUIConfigParser = embeddedUIConfigParser;
    m_configParser = configParser;
    m_controller = new NodoDBusController(this);

    m_feeds_str = embeddedUIConfigParser->readFeedKeys();
    m_displaySettings = embeddedUIConfigParser->readDisplaySettings();
    m_timezone = m_configParser->getTimezone();
    m_tz_id = m_tzList.indexOf(m_timezone);

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

 void NodoSystemControl::setTimeZoneIndex(int tz_id)
{
    m_tz_id = tz_id;
    m_timezone.clear();
    m_timezone = m_tzList[m_tz_id];
    qDebug() << m_timezone;
    m_configParser->setTimezone(m_timezone);

}

int NodoSystemControl::getTimeZoneIndex(void)
{
    return m_tz_id;
}

QDateTime NodoSystemControl::getChangedDateTime(void)
{
    QDateTime tmp(QDateTime::currentDateTime());
    QDateTime changed_dt = tmp.addSecs(QTimeZone(m_tzList[m_tz_id].toUtf8()).standardTimeOffset(tmp));

    return changed_dt;
}

void NodoSystemControl::setInputFieldText(QString text)
{
    m_inputFieldText.clear();
    m_inputFieldText = text;
    emit inputFieldTextChanged();
}

QString NodoSystemControl::getInputFieldText(void)
{
    return m_inputFieldText;
}

void NodoSystemControl::setEchoMode(int echoMode)
{
    m_echoMode = echoMode;
    emit echoModeChanged();
}

int NodoSystemControl::getEchoMode(void)
{
    return m_echoMode;
}

void NodoSystemControl::setPasswordMode(int passwordMode)
{
    m_passwordMode = passwordMode;
    emit passwordModeChanged();
}

int NodoSystemControl::getPasswordMode(void)
{
    return m_passwordMode;
}
