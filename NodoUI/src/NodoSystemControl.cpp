#include "NodoSystemControl.h"


NodoSystemControl::NodoSystemControl(NodoEmbeddedUIConfigParser *embeddedUIConfigParser, NodoConfigParser *configParser) : QObject(embeddedUIConfigParser)
{
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

    m_appTheme = m_configParser->getTheme();

    connect(m_controller, SIGNAL(connectionStatusChanged()), this, SLOT(updateConnectionStatus()));
    connect(m_controller, SIGNAL(serviceStatusReceived(QString)), this, SLOT(updateServiceStatus(QString)));
    connect(m_controller, SIGNAL(newNetworkConfigurationReceived()), this, SLOT(updateNetworkConfig()));


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
    m_configParser->setTheme(m_appTheme);
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


void NodoSystemControl::setOrientation(int orientation)
{
    m_embeddedUIConfigParser->writeDisplayOrientation(orientation);
    m_displaySettings = m_embeddedUIConfigParser->readDisplaySettings();
    emit orientationChanged();
}

int NodoSystemControl::getOrientation(void)
{
    return m_displaySettings.displayOrientation;
}

void NodoSystemControl::setBacklightLevel(int backlightLevel)
{
    m_controller->setBacklightLevel(backlightLevel);
}

int NodoSystemControl::getBacklightLevel(void)
{
    return m_controller->getBacklightLevel();
}

void NodoSystemControl::startServiceStatusUpdate(void)
{
    m_controller->getServiceStatus();
}

void NodoSystemControl::updateServiceStatus(QString statusMessage)
{
    m_serviceStatusMessage.clear();
    m_serviceStatusMessage = statusMessage;
    emit serviceStatusReady();
}

QString NodoSystemControl::getServiceStatus(QString serviceName)
{
    if(m_serviceStatusMessage.isEmpty())
    {
        return "N/A";
    }

    QStringList statusList = m_serviceStatusMessage.split("\n", Qt::SkipEmptyParts);

    for(int i = 0; i < statusList.size(); i++)
    {
        QStringList service = statusList[i].split(":");
        if(service[0] == serviceName)
        {
            return service[1];
        }
    }

    return "N/A";
}

void NodoSystemControl::startSystemStatusUpdate(void)
{
    double CPUUsage = m_controller->getCPUUsage();
    double averageCPUFreq = m_controller->getAverageCPUFreq();
    double RAMUsed = m_controller->getRAMUsage();
    double RAMTotal = m_controller->getTotalRAM();
    double CPUTemperature = m_controller->getCPUTemperature();
    double blockChainStorageUsed = m_controller->getBlockchainStorageUsage();
    double blockChainStorageTotal = m_controller->getTotalBlockchainStorage();
    double systemStorageUsed = m_controller->getSystemStorageUsage();
    double systemStorageTotal = m_controller->getTotalSystemStorage();

    m_CPUUsage = QString("%1").arg(averageCPUFreq, 0, 'f', 1).append(" MHz (").append(QString("%1").arg(CPUUsage, 0, 'f', 1)).append("%)");
    m_Temperature = QString("%1").arg(CPUTemperature, 0, 'f', 1).append("°C");
    m_RAMUsage = QString::number(RAMUsed).append("/").append(QString::number(RAMTotal)).append("GB (").append(QString("%1").arg((RAMUsed/RAMTotal)*100, 0, 'f', 1)).append("%)");
    m_blockchainStorage = QString::number(blockChainStorageUsed).append("/").append(QString::number(blockChainStorageTotal)).append("GB (").append(QString("%1").arg((blockChainStorageUsed/blockChainStorageTotal)*100, 0, 'f', 1)).append("%)");
    m_systemStorage = QString::number(systemStorageUsed).append("/").append(QString::number(systemStorageTotal)).append("GB (").append(QString("%1").arg((systemStorageUsed/systemStorageTotal)*100, 0, 'f', 1)).append("%)");

    emit systemStatusReady();
}

QString NodoSystemControl::getCPUUsage(void)
{
    return m_CPUUsage;
}

QString NodoSystemControl::getTemperature(void)
{
    return m_Temperature;
}

QString NodoSystemControl::getRAMUsage(void)
{
    return m_RAMUsage;
}

QString NodoSystemControl::getBlockChainStorageUsage(void)
{
    return m_blockchainStorage;
}

QString NodoSystemControl::getSystemStorageUsage(void)
{
    return m_systemStorage;
}

void NodoSystemControl::setPassword(QString pw)
{
    m_controller->setPassword(pw);
}

void NodoSystemControl::serviceManager(QString operation, QString service)
{
    m_controller->serviceManager(operation, service);
}

void NodoSystemControl::requestNetworkIP(void)
{
    updateNetworkConfig();
}


void NodoSystemControl::updateNetworkConfig(void)
{
    m_networkIP.clear();
    QString nmConfig = m_controller->getConnectedDeviceConfig();
    if(!nmConfig.isEmpty())
    {
        QStringList params = nmConfig.split("\n", Qt::SkipEmptyParts);
        m_networkIP = params.at(0);
    }

    emit networkConnStatusReady();
}

QString NodoSystemControl::getNetworkIP(void)
{
    return m_networkIP;
}
