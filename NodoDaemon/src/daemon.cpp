#include "daemon.h"

#define DISABLE_PROCESS_CALLS

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

QString operations[] = {"start", "stop", "restart", "enable", "disable"};
QString services[] = {"block-explorer", "monerod", "monero-lws", "xmrig"};

void Daemon::serviceManager(QString operation, QString service)
{
    qDebug() << QString("serviceManager ").append(operation).append(" initiated");

    QString program = "/usr/bin/systemctl";


    bool valid = false;
    for (uint i = 0; i < 5; i++) {
      if (operation == operations[i]) {
        valid = true;
        break;
      }
    }
    if (!valid)
    {
        qDebug() << "illegal operation.";
        emit serviceManagerNotification("illegal operation (either one of: start, stop, restart, enable, disable).");
        return;
    }
    valid = false;
    for (uint i = 0; i < 4; i++) {
      if (service == services[i] || service == services[i] + ".service") {
        valid = true;
        break;
      }
    }
    if (!valid)
    {
        qDebug() << "illegal service.";
        emit serviceManagerNotification("illegal service.");
        return;
    }
    QStringList arguments;

    arguments << operation << service;

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

