#include "NodoSystemControl.h"


NodoSystemControl::NodoSystemControl(NodoEmbeddedUIConfigParser *embeddedUIConfigParser, NodoConfigParser *configParser) : QObject(embeddedUIConfigParser)
{
    m_embeddedUIConfigParser = embeddedUIConfigParser;
    m_configParser = configParser;
    m_dbusController = new NodoDBusController(this);

    m_feeds_str = embeddedUIConfigParser->readFeedKeys();
    m_displaySettings = embeddedUIConfigParser->readDisplaySettings();
    m_timezone = m_configParser->getTimezone();
    m_tz_id = m_tzList.indexOf(m_timezone);

    m_dbusConnectionStatus = m_dbusController->isConnected();

    if(m_dbusConnectionStatus)
    {
        qDebug() << "Connected to the dbus daemon";
    }
    else
    {
        qDebug() << "Couldn't connect to the dbus daemon";
    }

    m_appTheme = m_configParser->getTheme();

    m_screenSaverTimer = new QTimer(this);
    connect(m_screenSaverTimer, SIGNAL(timeout()), this, SLOT(timedout()));

    connect(m_dbusController, SIGNAL(dbusConnectionStatusChanged()), this, SLOT(updateDbusConnectionStatus()));
    connect(m_dbusController, SIGNAL(serviceStatusReceived(QString)), this, SLOT(updateServiceStatus(QString)));
    connect(m_dbusController, SIGNAL(serviceManagerNotificationReceived(QString)), this, SLOT(processNotification(QString)));

    if(m_configParser->getStringValueFromKey("mining", "enabled") == "TRUE")
    {
        serviceManager("start", "xmrig");
    }
    else
    {
        serviceManager("stop", "xmrig");
    }
}

bool NodoSystemControl::getAppTheme(void)
{
    return m_appTheme;
}

void NodoSystemControl::setAppTheme(bool appTheme)
{
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


void NodoSystemControl::updateDbusConnectionStatus(void)
{
    bool isConnected = m_dbusController->isConnected();
    if(m_dbusConnectionStatus == isConnected)
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

    m_dbusConnectionStatus = isConnected;
}

void NodoSystemControl::restartDevice()
{
    m_dbusController->restart();
}

void NodoSystemControl::shutdownDevice()
{
    m_dbusController->shutdown();
}

void NodoSystemControl::systemRecovery(int recoverFS, int rsyncBlockchain)
{
    m_dbusController->startRecovery(recoverFS, rsyncBlockchain);
}

 void NodoSystemControl::setTimeZoneIndex(int tz_id)
{
    m_tz_id = tz_id;
    m_timezone.clear();
    m_timezone = m_tzList[m_tz_id];
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
    m_dbusController->setBacklightLevel(backlightLevel);
}

int NodoSystemControl::getBacklightLevel(void)
{
    return m_dbusController->getBacklightLevel();
}

void NodoSystemControl::startServiceStatusUpdate(void)
{
    m_dbusController->getServiceStatus();
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
    double CPUUsage = m_dbusController->getCPUUsage();
    double averageCPUFreq = m_dbusController->getAverageCPUFreq();
    double RAMUsed = m_dbusController->getRAMUsage();
    double RAMTotal = m_dbusController->getTotalRAM();
    double CPUTemperature = m_dbusController->getCPUTemperature();
    double blockChainStorageUsed = m_dbusController->getBlockchainStorageUsage();
    double blockChainStorageTotal = m_dbusController->getTotalBlockchainStorage();
    double systemStorageUsed = m_dbusController->getSystemStorageUsage();
    double systemStorageTotal = m_dbusController->getTotalSystemStorage();

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
    m_dbusController->setPassword(pw);
}

void NodoSystemControl::serviceManager(QString operation, QString service)
{
    m_dbusController->serviceManager(operation, service);
}

void NodoSystemControl::restartScreenSaverTimer(void)
{
    stopScreenSaverTimer();
    m_screenSaverTimer->start(getScreenSaverTimeout());
}

void NodoSystemControl::stopScreenSaverTimer(void)
{
    m_screenSaverTimer->stop();
}

void NodoSystemControl::timedout(void)
{
    emit screenSaverTimedout();
}

int NodoSystemControl::getErrorCode(void)
{
    return m_errorCode;
}

QString NodoSystemControl::getErrorMessage(void)
{
    return m_notifier.getMessageText((m_messageIDs)m_errorCode);
}

void NodoSystemControl::setClearnetPort(QString port)
{
    enableComponent(false);
    m_configParser->setClearnetPort(port);
    m_dbusController->serviceManager("restart", "monerod");
}

void NodoSystemControl::setClearnetPeer(QString peer)
{
    enableComponent(false);
    m_configParser->setClearnetPeer(peer);
    m_dbusController->serviceManager("restart", "monerod");
}

void NodoSystemControl::setTorPort(QString port)
{
    enableComponent(false);
    m_configParser->setTorPort(port);
    m_dbusController->serviceManager("restart", "monerod");
}

void NodoSystemControl::setTorPeer(QString peer)
{
    enableComponent(false);
    m_configParser->setTorPeer(peer);
    m_dbusController->serviceManager("restart", "monerod");
}

void NodoSystemControl::setI2pPort(QString port)
{
    enableComponent(false);
    m_configParser->setI2pPort(port);
    m_dbusController->serviceManager("restart", "monerod");
}

void NodoSystemControl::setI2pPeer(QString peer)
{
    enableComponent(false);
    m_configParser->setI2pPeer(peer);
    m_dbusController->serviceManager("restart", "monerod");
}

bool NodoSystemControl::isComponentEnabled(void)
{
    return m_componentEnabled;
}

void NodoSystemControl::enableComponent(bool enabled)
{
    m_componentEnabled = enabled;
    emit componentEnabledStatusChanged();
}

bool NodoSystemControl::getrpcEnabledStatus(void)
{
    QString retVal = m_configParser->getStringValueFromKey("config", "rpc_enabled");
    if("false" == retVal.toLower())
    {
        return false;
    }
    else if("true" == retVal.toLower())
    {
        return true;
    }

    return false;
}

void NodoSystemControl::setrpcEnabledStatus(bool status)
{
    enableComponent(false);
    m_configParser->setrpcEnabledStatus(status);
    m_dbusController->serviceManager("restart", "monerod");
}

int NodoSystemControl::getrpcPort(void)
{
    return m_configParser->getIntValueFromKey("config", "monero_rpc_port");
}

void NodoSystemControl::setrpcPort(QString port)
{
    enableComponent(false);
    m_configParser->setrpcPort(port);
    m_dbusController->serviceManager("restart", "monerod");
}

QString NodoSystemControl::getrpcUser(void)
{
    return m_configParser->getStringValueFromKey("config", "rpcu");
}

QString NodoSystemControl::getrpcPassword(void)
{
    return m_configParser->getStringValueFromKey("config", "rpcp");
}

void NodoSystemControl::setNodeBandwidthParameters(QString in_peers, QString out_peers, QString limit_rate_up, QString limit_rate_down)
{
    enableComponent(false);
    m_configParser->setNodeBandwidthParameters(in_peers, out_peers, limit_rate_up, limit_rate_down);
    m_dbusController->serviceManager("restart", "monerod");
}

void NodoSystemControl::processNotification(QString message)
{
    QStringList serviceStat = message.split(":");

    enableComponent(true);

    if(serviceStat.size() != 3)
    {
        m_errorCode = CONNECTION_TO_NODO_DBUS_FAILED;
        emit errorDetected();
        return;
    }

    if(("monerod" == serviceStat[0]) && "restart" == serviceStat[1])
    {
        if("1" == serviceStat[2])
        {
            m_errorCode = NO_ERROR;
        }
        else
        {
            m_errorCode = RESTARTING_MONERO_FAILED;
            emit errorDetected();
            return;
        }
    }
}


#ifdef ENABLE_TEST_CODE

//QTimer::singleShot(4000, this, SLOT(processNotificationTest()));

void NodoSystemControl::processNotificationTest(void)
{
    QString message = "monerod:restart:0";
    QStringList serviceStat = message.split(":");

    m_componentEnabled = true;
    emit componentEnabledStatusChanged();

    if(serviceStat.size() != 3)
    {
        m_errorCode = CONNECTION_TO_NODO_DBUS_FAILED;
        emit errorDetected();
        return;
    }

    if(("monerod" == serviceStat[0]) && "restart" == serviceStat[1])
    {
        if("1" == serviceStat[2])
        {
            m_errorCode = NO_ERROR;
        }
        else
        {
            m_errorCode = RESTARTING_MONERO_FAILED;
            emit errorDetected();
            return;
        }
    }
}
#endif


