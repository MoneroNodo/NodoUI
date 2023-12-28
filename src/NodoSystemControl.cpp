#include "NodoSystemControl.h"


NodoSystemControl::NodoSystemControl(NodoConfigParser *configParser) : QObject(configParser)
{
    m_appTheme = false;
    setAppTheme(m_appTheme);
    m_configParser = configParser;
    m_feeds_str = m_configParser->readFeedKeys();
    m_displaySettings = m_configParser->readDisplaySettings();
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
    m_configParser->writeFeedKeys(KEY_VISIBLE, index, state);
    m_feeds_str.clear();
    m_feeds_str = m_configParser->readFeedKeys();
}


bool NodoSystemControl::getVisibleState(int index)
{
    return m_feeds_str[index].visibleItem;
}


void NodoSystemControl::setSelectedState(int index, bool state)
{
    m_configParser->writeFeedKeys(KEY_SELECTED, index, state);
    m_feeds_str.clear();
    m_feeds_str = m_configParser->readFeedKeys();
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
    m_configParser->writeScreenSaverType(state);
    m_displaySettings = m_configParser->readDisplaySettings();
}


int NodoSystemControl::getScreenSaverType(void)
{
    return m_displaySettings.useFeedsAsScreenSaver;
}


void NodoSystemControl::setScreenSaverTimeout(int timeout)
{
    m_configParser->writeScreenSaverTimeout(timeout);
    m_displaySettings = m_configParser->readDisplaySettings();
}


int NodoSystemControl::getScreenSaverTimeout(void)
{
    return m_displaySettings.screenSaverTimeoutInSec*1000;
}


void NodoSystemControl::setScreenSaverItemChangeTimeout(int timeout)
{
    m_configParser->writeScreenSaverItemChangeTimeout(timeout);
    m_displaySettings = m_configParser->readDisplaySettings();
}


int NodoSystemControl::getScreenSaverItemChangeTimeout(void)
{
    return m_displaySettings.screenSaverItemChangeTimeoutInSec*1000;
}

