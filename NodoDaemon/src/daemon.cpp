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

Daemon::Daemon()
{
    new EmbeddedInterfaceAdaptor(this);
    QDBusConnection connection = QDBusConnection::systemBus();
    connection.registerObject("/com/monero/nodo", this);
    connection.registerService("com.monero.nodo");
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

const static QString operations[] = {"start", "stop", "restart", "enable", "disable"};
const static QString services[] = {"block-explorer", "monerod", "monero-lws", "xmrig"};

void Daemon::serviceManager(QString operation, QString service)
{
    qDebug() << QString("serviceManager ").append(operation).append(" initiated");

    QString program = "/usr/bin/systemctl";

    bool valid = false;
    for (uint i = 0; i < 5; i++)
    {
      if (operation == operations[i])
      {
        valid = true;
        break;
      }
    }
    if (!valid)
    {
        qDebug() << "illegal operation: " << operation;
        emit serviceManagerNotification("illegal operation (either one of: start, stop, restart, enable, disable).");
        return;
    }


    QStringList service_list = service.split(' ');
    for (QString s : service_list)
    {
      valid = false;
      for (uint i = 0; i < 4; i++)
      {
        if (s == services[i] || s == services[i] + ".service")
        {
          valid = true;
          break;
        }
      }
      if (!valid)
      {
          qDebug() << "illegal service: " << s;
          emit serviceManagerNotification("illegal service.");
          return;
      }
    }

    QStringList arguments;

    arguments << operation << service_list;

    QProcess process;
    process.start(program, arguments);
    if(!process.waitForStarted())
    {
        qDebug() << QString("failed to ").append(operation).append(" service").append(". Exiting...");
        emit serviceManagerNotification(QString("failed to ").append(operation).append(" service ").append(". Exiting..."));

        return;
    }

    if(!process.waitForFinished())
    {
        qDebug() << QString("failed to ").append(operation).append(" service ").append(". Exiting...");
        emit serviceManagerNotification(QString("failed to ").append(operation).append("service ").append(". Exiting..."));

        return;
    }

    qDebug() << "success";
    emit serviceManagerNotification("success");
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

    emit restartNotification("received restart request");
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
    emit shutdownNotification("received shutdown request");
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
