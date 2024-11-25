#include "daemon.h"

#define DISABLE_PROCESS_CALLS

#define BACKLIGHT_CONTROL_FILE "/sys/class/backlight/fde30000.dsi.0/brightness"
#define BRIGHTNESS_RANGE_MIN 0
#define BRIGHTNESS_RANGE_MAX 100

#define BRIGHTNESS_LEVEL_MIN 0
#define BRIGHTNESS_LEVEL_MAX 255

#define MIN_ALLOWED_BRIGHTNESS_LEVEL 13 // min allowed level is BRIGHTNESS_LEVEL_MIN + (5% of BRIGHTNESS_LEVEL_MAX)
#define MAX_ALLOWED_BRIGHTNESS_LEVEL 243 // max allowed level is BRIGHTNESS_LEVEL_MAX - (5% of BRIGHTNESS_LEVEL_MAX)

#define m_scaleFactor 2.3 // (MAX_ALLOWED_BRIGHTNESS_LEVEL - MIN_ALLOWED_BRIGHTNESS_LEVEL) / (BRIGHTNESS_RANGE_MAX - BRIGHTNESS_RANGE_MIN)

#define SIZE_TB 1073741824
#define SIZE_GB 1048576
#define SIZE_Tb 1000000000
#define SIZE_Gb 1000000
Daemon::Daemon()
{
    new EmbeddedInterfaceAdaptor(this);
    QDBusConnection connection = QDBusConnection::systemBus();
    if(connection.registerObject("/com/monero/nodo", this))
    {
        if(!connection.registerService("com.monero.nodo"))
        {
            qDebug() << "failed to register service" << "com.monero.nodo";
        }
    }
    else
    {
        qDebug() << "failed to register object" << "/com/monero/nodo";
    }

    m_hardwareStatusTimer = new QTimer(this);
    connect(m_hardwareStatusTimer, SIGNAL(timeout()), this, SLOT(updateHardwareStatus()));
    m_hardwareStatusTimer->start(1000);

    m_serviceStatusTimer = new QTimer(this);
    connect(m_serviceStatusTimer, SIGNAL(timeout()), this, SLOT(updateServiceStatus()));
    m_serviceStatusTimer->start(1000);

    powerKeyThread = new PowerKeyThread();
    connect(powerKeyThread, SIGNAL(poweroffRequested()), this, SLOT(shutdown()));
    connect(powerKeyThread, SIGNAL(buttonPressDetected()), this, SIGNAL(powerButtonPressDetected()));
    connect(powerKeyThread, SIGNAL(buttonReleaseDetected()), this, SIGNAL(powerButtonReleaseDetected()));
    powerKeyThread->startListening();


    recoveryKeyThread = new RecoveryKeyThread();
    connect(recoveryKeyThread, SIGNAL(factoryResetRequested()), this, SIGNAL(factoryResetRequested()));
    connect(recoveryKeyThread, SIGNAL(factoryResetStarted()), this, SIGNAL(factoryResetStarted()));
    connect(recoveryKeyThread, SIGNAL(factoryResetCompleted()), this, SIGNAL(factoryResetCompleted()));
    recoveryKeyThread->startListening();

    moneroLWS = new MoneroLWS();
    connect(moneroLWS, SIGNAL(listAccountsCompleted()), this, SIGNAL(moneroLWSListAccountsCompleted()));
    connect(moneroLWS, SIGNAL(listRequestsCompleted()), this, SIGNAL(moneroLWSListRequestsCompleted()));
    connect(moneroLWS, SIGNAL(accountAdded()), this, SIGNAL(moneroLWSAccountAdded()));

    m_connStat = NM_STATUS_DISCONNECTED;
    m_pingTimer = new QTimer(this);
    connect(m_pingTimer, SIGNAL(timeout()), this, SLOT(ping()));
    m_pingTimer->start(100);

    m_setupDomainsTimer = new QTimer(this);
    connect(m_setupDomainsTimer, SIGNAL(timeout()), this, SLOT(setupDomains()));
    m_setupDomainsTimer->start(100);
}

void Daemon::startRecovery(int recoverFS, int rsyncBlockchain)
{
    qDebug() << QString("received recovery request").append("recoverFS: ").append(QString::number(recoverFS).append(" rsyncBlockchain: ").append(QString::number(rsyncBlockchain)));

    QString program = "/usr/bin/recovery.sh";
    QStringList arguments;

    if(1 == recoverFS)
    {
        arguments << "-repair";
    }

    if(1 == rsyncBlockchain)
    {
        arguments << "-purge";
    }

    QProcess process;
    process.start(program, arguments);
    process.waitForFinished(-1);
    emit startRecoveryNotification("startRecovery initiated");
}

void Daemon::changeServiceStatus(QString operation, QString service)
{
    qDebug() << QString("serviceManager ").append(operation).append(" initiated");

    ServiceManagerThread *sManager = new ServiceManagerThread();
    sManager->setAutoDelete(true);
    sManager->setServiceAndOperation(service, operation);

    connect(sManager, SIGNAL(serviceStatusReady(QString)), this, SLOT(serviceStatusReceived(QString)), Qt::QueuedConnection);
    QThreadPool::globalInstance()->start(sManager);
}


void Daemon::serviceStatusReceived(const QString &message)
{
    ServiceManagerThread* sManager = qobject_cast<ServiceManagerThread*>(sender());
    if(!sManager) return;
    qDebug() << message;
    emit serviceManagerNotification(message);
}

void Daemon::update(void)
{
    qDebug() << "update request";

    QString program = "/usr/bin/bash";

    QStringList arguments;
    arguments << "/home/nodo/update-all.sh";

    QProcess process;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void Daemon::restart(void)
{
    qDebug() << "received restart request";

    QString program = "/usr/bin/systemctl";

    QStringList arguments;
    arguments << "reboot";

    QProcess process;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void Daemon::shutdown(void)
{
    qDebug() << "received shutdown request";

    QString program = "/usr/bin/systemctl";

    QStringList arguments;
    arguments << "poweroff";

    QProcess process;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void Daemon::setBacklightLevel(int backlightLevel)
{
    if(backlightLevel < BRIGHTNESS_RANGE_MIN)
    {
        backlightLevel = BRIGHTNESS_RANGE_MIN;
    }

    if(backlightLevel > BRIGHTNESS_RANGE_MAX)
    {
        backlightLevel = BRIGHTNESS_RANGE_MAX;
    }

    int blLevel = (int)(MIN_ALLOWED_BRIGHTNESS_LEVEL + backlightLevel*m_scaleFactor);

    QString filename = BACKLIGHT_CONTROL_FILE;
    QFile file(filename);
    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);
        stream << QString::number(blLevel);
    }
    else {
        qDebug() << "file open error";
    }
    file.close();
}

int Daemon::getBacklightLevel(void)
{
    int retVal = BRIGHTNESS_RANGE_MAX/2;

    QFile file(BACKLIGHT_CONTROL_FILE);
    if (!file.open(QIODevice::ReadWrite))
    {
        qDebug() << "file read error";
        return BRIGHTNESS_RANGE_MAX;
    }

    while (!file.atEnd()) {
        bool ok;

        QByteArray line = file.readLine();
        retVal = line.toInt(&ok, 10);

        return (int)(retVal/m_scaleFactor);
        file.close();
    }

    if(file.isOpen())
        file.close();

    return retVal;
}

void Daemon::updateServiceStatus(void)
{
    m_serviceStatusTimer->stop();
    qDebug() << "updateServiceStatus";
    QString program = "/usr/bin/systemctl";
    QString serviceList[] = {"monerod", "tor", "i2pd", "monero-lws", "sshd", "moneropay"};

    QStringList arguments;
    arguments << "is-active" << serviceList[0] << serviceList[1] << serviceList[2] << serviceList[3] << serviceList[4] << serviceList[5];

    QProcess process;

    process.start(program, arguments);
    process.waitForFinished(-1);
    QString retVal = process.readAll();
    QStringList status = retVal.split("\n", Qt::SkipEmptyParts);
    QString statusMessage;

    for(int i = 0; i < status.size(); i++)
    {
        statusMessage.append(serviceList[i]).append(":").append(status.at(i)).append("\n");
    }

    qDebug() << statusMessage;
    emit serviceStatusReadyNotification(statusMessage);
    m_serviceStatusTimer->start(5000);
}


void Daemon::updateHardwareStatus(void)
{
    m_hardwareStatusTimer->stop();
    readCPUUsage();
    readAverageCPUFreq();
    readCPUTemperature();
    readRAMUsage();
    readCPUTemperature();
    readBlockchainStorageUsage();
    readSystemStorageUsage();

    m_hardwareStatus.clear();
    m_hardwareStatus.append(QString::number(m_CPUUsage , 'g', 2)).append("\n")
        .append(QString::number(m_AverageCPUFreq)).append("\n")
        .append(QString::number(m_RAMUsage)).append("\n")
        .append(QString::number(m_TotalRAM)).append("\n")
        .append(QString::number(m_CPUTemperature)).append("\n")
        .append(QString::number(m_blockChainStorageUsed)).append("\n")
        .append(QString::number(m_blockChainStorageTotal)).append("\n")
        .append(QString::number(m_systemStorageUsed)).append("\n")
        .append(QString::number(m_systemStorageTotal)).append("\n");

    emit hardwareStatusReadyNotification(m_hardwareStatus);
    m_hardwareStatusTimer->start(5000);
}


void Daemon::readCPUUsage(void)
{
    QFile file("/proc/stat");
    file.open(QFile::ReadOnly);
    const QList<QByteArray> times = file.readLine().simplified().split(' ').mid(1);
    const int idleTime = times.at(3).toInt();
    int totalTime = 0;
    foreach (const QByteArray &time, times) {
        totalTime += time.toInt();
    }

    m_CPUUsage = (1 - (1.0*idleTime-m_prevIdleTime) / (totalTime-m_prevTotalTime)) * 100.0;

    m_prevIdleTime = idleTime;
    m_prevTotalTime = totalTime;
}

void Daemon::readAverageCPUFreq(void)
{
    QProcess process;
    QString program = "/usr/bin/cat";


    for(int i = 0; i < 8; i++)
    {
        QStringList arguments;
        QString path("/sys/devices/system/cpu/cpu");
        path.append(QString::number(i)).append("/cpufreq/cpuinfo_cur_freq");
        arguments << path;

        process.start(program, arguments);
        process.waitForFinished(10000);
        process.waitForReadyRead(10000);

        QString retVal = process.readAll();

        QStringList status = retVal.split("\n", Qt::SkipEmptyParts);
        bool ok;
        m_AverageCPUFreq += status.at(0).toDouble(&ok)/1000;
    }

    m_AverageCPUFreq = (m_AverageCPUFreq/8)/1000; //MHz Avg, then GHz	
}

void Daemon::readRAMUsage(void)
{
    QProcess process;
    QString program = "/usr/bin/free";
    QStringList arguments;


    process.start(program, arguments);
    process.waitForFinished(-1);
    QString retVal = process.readAll();

    QStringList status = retVal.split("\n", Qt::SkipEmptyParts);

    for(int i = 0; i < status.size(); i++)
    {
        if(-1 != status.at(i).indexOf("Mem:"))
        {
            bool ok;
            QStringList status2 = status.at(i).split(" ", Qt::SkipEmptyParts);
            m_TotalRAM = status2.at(1).toFloat(&ok) / (float) SIZE_GB;
            m_RAMUsage = status2.at(2).toFloat(&ok) / (float) SIZE_GB;
        }
    }
}

void Daemon::readCPUTemperature(void)
{
    QProcess process;
    QString program = "/usr/bin/cat";
    QStringList arguments;
    arguments << "/sys/devices/virtual/thermal/thermal_zone0/temp";

    process.start(program, arguments);
    process.waitForFinished(-1);
    QString retVal = process.readAll();
    bool ok;
    m_CPUTemperature = retVal.toFloat(&ok)/(1000.0);
}

void Daemon::readBlockchainStorageUsage(void)
{
    QProcess process;
    QString program = "/usr/bin/df";
    QStringList arguments;

    process.start(program, arguments);
    process.waitForFinished(-1);
    QString retVal = process.readAll();

    QStringList status = retVal.split("\n", Qt::SkipEmptyParts);

    for(int i = 0; i < status.size(); i++)
    {
        if(-1 != status.at(i).indexOf("/dev/nvme0n1p1"))
        {
            bool ok;
            QStringList status2 = status.at(i).split(" ", Qt::SkipEmptyParts);
            m_blockChainStorageTotal = status2.at(1).toFloat(&ok) / (float) SIZE_GB;
            m_blockChainStorageUsed = status2.at(2).toFloat(&ok) / (float) SIZE_GB;
        }
    }
}

void Daemon::readSystemStorageUsage(void)
{
    QProcess process;
    QString program = "/usr/bin/df";
    QStringList arguments;

    process.start(program, arguments);
    process.waitForFinished(-1);
    QString retVal = process.readAll();

    QStringList status = retVal.split("\n", Qt::SkipEmptyParts);

    for(int i = 0; i < status.size(); i++)
    {
        if(-1 != status.at(i).indexOf("overlay"))
        {
            bool ok;
            QStringList status2 = status.at(i).split(" ", Qt::SkipEmptyParts);
            m_systemStorageTotal = status2.at(1).toFloat(&ok) / (float) SIZE_GB;
            m_systemStorageUsed = status2.at(2).toFloat(&ok) / (float) SIZE_GB;
        }
    }
}

void Daemon::setPassword(QString pw)
{
    QProcess sh;
    QString tmp = QString("echo \"nodo:").append(pw).append("\"  | chpasswd");
    sh.start( "sh", { "-c", tmp});
    sh.waitForFinished( -1 );
    qDebug() << "setPassword exit code: " << sh.exitCode();
    emit passwordChangeStatus(sh.exitCode());
}

int Daemon::getBlockchainStorageStatus(void)
{
    return recoveryKeyThread->getBlockchainStorageStatus();
}

void Daemon::factoryResetApproved(void)
{
    recoveryKeyThread->recover();
}

void Daemon::moneroLWSAddAccount(QString address, QString privateKey)
{
    moneroLWS->addAccount(address, privateKey);
}

void Daemon::moneroLWSDeleteAccount(QString address)
{
    moneroLWS->deleteAccount(address);
}

void Daemon::moneroLWSReactivateAccount(QString address)
{
    moneroLWS->reactivateAccount(address);
}

void Daemon::moneroLWSDeactivateAccount(QString address)
{
    moneroLWS->deactivateAccount(address);
}

void Daemon::moneroLWSRescan(QString address, QString height)
{
    moneroLWS->rescan(address, height);
}

void Daemon::moneroLWSAcceptAllRequests(QString requests)
{
    moneroLWS->acceptAllRequests(requests);
}

void Daemon::moneroLWSAcceptRequest(QString address)
{
    moneroLWS->acceptRequest(address);
}

void Daemon::moneroLWSRejectRequest(QString address)
{
    moneroLWS->rejectRequest(address);
}

QString Daemon::moneroLWSGetAccountList(void)
{
    return moneroLWS->getAccountList();
}

QString Daemon::moneroLWSGetRequestList(void)
{
    return moneroLWS->getRequestList();
}

void Daemon::moneroLWSListAccounts(void)
{
    moneroLWS->listAccounts();
}

void Daemon::moneroLWSListRequests(void)
{
    moneroLWS->listRequests();
}

int Daemon::getConnectionStatus(void)
{
    return m_connStat;
}

void Daemon::ping(void)
{
    m_pingTimer->stop();
    QProcess process;
    QStringList arguments;
    arguments << "198.245.51.147" << "-W" << "2" << "-c" << "2"; // IVPN DNS

    process.start("/usr/bin/ping", arguments);
    process.waitForFinished(-1);

    QString p_stdout = process.readAllStandardOutput();
    QString p_stderr = process.readAllStandardError();

    if(!p_stderr.isEmpty())
    {
        if(p_stderr.contains("Network is unreachable"))
        {
            // qDebug() << "no network connection";
            m_connStat = NM_STATUS_DISCONNECTED;
            emit connectionStatusChanged();
            m_pingTimer->start(PING_PERIOD_NOT_CONNECTED);
            return;
        }
    }


    QStringList tmpList = p_stdout.split("\n", Qt::SkipEmptyParts);


    for(int i = 0; i < tmpList.size(); i++)
    {
        if(tmpList.at(i).contains("--- 198.245.51.147 ping statistics ---", Qt::CaseInsensitive))
        {
            QStringList statList = tmpList.at(i+1).split(",", Qt::SkipEmptyParts);
            for(int j = 0; j < statList.size(); j++)
            {
                if(statList.at(j).contains("100% packet loss", Qt::CaseInsensitive))
                {
                    // qDebug() << "no internet";
                    m_connStat = NM_STATUS_NO_INTERNET;
                    emit connectionStatusChanged();
                    m_pingTimer->start(PING_PERIOD_NOT_CONNECTED);
                    return;
                }
                else if(statList.at(j).contains("0% packet loss", Qt::CaseInsensitive))
                {
                    // qDebug() << "connected";
                    m_connStat = NM_STATUS_CONNECTED;
                    emit connectionStatusChanged();
                    m_pingTimer->start(PING_PERIOD_CONNECTED);
                    return;
                }
            }
        }
    }

    m_pingTimer->start(PING_PERIOD_NOT_CONNECTED);
}

void Daemon::setupDomains(void)
{
    qDebug() << "setupDomains";
    m_setupDomainsTimer->stop();
    if(QFileInfo::exists(m_firstBootFileName))
    {
        return;
    }

    QString program = "/usr/bin/systemctl";
    QString serviceList[] = {"tor", "i2pd"};

    QStringList arguments;
    arguments << "is-active" << serviceList[0] << serviceList[1];

    QProcess process;

    process.start(program, arguments);
    process.waitForFinished(-1);
    QString retVal = process.readAll();
    QStringList status = retVal.split("\n", Qt::SkipEmptyParts);


    if(2 != status.size())
    {
        m_setupDomainsTimer->start(3000);
        return;
    }

    if(("active" == status.at(0)) && ("active" == status.at(1)))
    {
        program.clear();
        arguments.clear();
        program = "/usr/bin/bash";
        arguments << "/home/nodo/setup-domains.sh";
        process.start(program, arguments);
				process.waitForFinished(7000);

        QFile file(m_firstBootFileName);
        file.open(QIODevice::ReadWrite | QIODevice::Text);
        file.close();

        return;
    }

    m_setupDomainsTimer->start(3000);
}

void Daemon::changePassword(QString oldPassword, QString newPassword)
{
    UserAuthentication *auth = new UserAuthentication();
    auth->setAutoDelete(true);
    auth->setUsernamePassword(oldPassword, newPassword);
    connect(auth, SIGNAL(authenticationStatusReady(int)), this, SLOT(passwordChangeStatusReceived(int)), Qt::QueuedConnection);
    QThreadPool::globalInstance()->start(auth);
}

void Daemon::passwordChangeStatusReceived(int status)
{
    emit passwordChangeStatus(status);
}

