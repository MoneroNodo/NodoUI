#ifndef DAEMON_H
#define DAEMON_H

#include <QObject>
#include <QtDBus/QDBusConnection>
#include <QTimer>
#include "nodo_embedded_adaptor.h"

class Daemon : public QObject
{
    Q_OBJECT
public:
    Daemon();

public slots:
    void startRecovery(int recoverFS, int rsyncBlockchain);
    void serviceManager(QString operation, QString service);
    void restart(void);
    void shutdown(void);

signals:
    void startRecoveryNotification(const QString &message);
    void serviceManagerNotification(const QString &message);
    void restartNotification(const QString &message);
    void shutdownNotification(const QString &message);

private:
    QStringList m_services = {
        "explorer.service",
        "monero-lws.service",
        "monerod.service",
        "p2pool.service",
        "xmrig.service",
    };
};

#endif // DAEMON_H
