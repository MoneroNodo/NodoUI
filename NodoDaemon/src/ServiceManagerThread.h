#ifndef SERVICEMANAGERTHREAD_H
#define SERVICEMANAGERTHREAD_H

#include <QObject>
#include <QObject>
#include <QDebug>
#include <QRunnable>
#include <QThread>
#include <QProcess>

class ServiceManagerThread : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit ServiceManagerThread(QObject *parent = nullptr);
    ~ServiceManagerThread();

public:
    void run() Q_DECL_OVERRIDE;
    void setServiceAndOperation(QString serviceName, QString operation);

private:
    QString m_service;
    QString m_operation;

signals:
    void serviceStatusReady(const QString &message);
};

#endif // SERVICEMANAGERTHREAD_H
