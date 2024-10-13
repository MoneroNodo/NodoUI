#include "ServiceManagerThread.h"

ServiceManagerThread::ServiceManagerThread(QObject *parent)
    : QObject{parent}
{

}

ServiceManagerThread::~ServiceManagerThread()
{
    qDebug() << "Destroyed task for " << m_service << m_operation << this << QThread::currentThread();
}

void ServiceManagerThread::setServiceAndOperation(QString serviceName, QString operation)
{
    m_service = serviceName;
    m_operation = operation;
}

const static QString operations[] = {"start", "stop", "restart", "enable", "disable"};
const static QString services[] = {"block-explorer", "monerod", "monero-lws", "xmrig", "sshd" , "p2pool", "webui", "moneropay"};

void ServiceManagerThread::run()
{
    QString program = "/usr/bin/systemctl";

    bool valid = false;
    for (uint i = 0; i < 5; i++)
    {
        if (m_operation == operations[i])
        {
            valid = true;
            break;
        }
    }
    if (!valid)
    {
        qDebug() << "illegal operation: " << m_operation;
        QString message = QString(m_service).append(":").append(m_operation).append(":").append("0");
        emit serviceStatusReady(message);
        return;
    }


    QStringList service_list = m_service.split(' ');
    for (QString s : service_list)
    {
        valid = false;
        for (int i = 0; i < 5; i++)
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
            emit serviceStatusReady("illegal service.");
            return;
        }
    }

    QStringList arguments;

    arguments << m_operation << service_list;

    QProcess process;
    process.start(program, arguments);
    if(!process.waitForStarted())
    {
        qDebug() << QString("failed to ").append(m_operation).append(" service").append(". Exiting...");
        QString message = QString(m_service).append(":").append(m_operation).append(":").append("0");
        emit serviceStatusReady(message);

        return;
    }

    if(!process.waitForFinished())
    {
        qDebug() << QString("failed to ").append(m_operation).append(" service ").append(". Exiting...");
        QString message = QString(m_service).append(":").append(m_operation).append(":").append("0");
        emit serviceStatusReady(message);

        return;
    }

    qDebug() << m_service << m_operation << " success";
    QString message = QString(m_service).append(":").append(m_operation).append(":").append("1");
    emit serviceStatusReady(message);
}
