#ifndef NODODBUSCONTROLLER_H
#define NODODBUSCONTROLLER_H

#include <QObject>
#include <QTimer>

#include "nodo_embedded_interface.h"


class NodoDBusController : public QObject
{
    Q_OBJECT
public:
    explicit NodoDBusController(QObject *parent = nullptr);
    bool isConnected(void);
    void startRecovery(int recoverFS, int rsyncBlockchain);
    void serviceManager(QString operation, QString service);
    void restart(void);
    void shutdown(void);
    void setBacklightLevel(int backlightLevel);
    int getBacklightLevel(void);


protected:
    void timerEvent(QTimerEvent *event);

private slots:
    void updateTextEdit(QString message);

private:
    com::moneronodo::embeddedInterface *nodo;
    bool m_connectionStatus;

signals:
    void connectionStatusChanged();
};

#endif // NODODBUSCONTROLLER_H
