#ifndef POWERKEYTHREAD_H
#define POWERKEYTHREAD_H

#include <QObject>
#include <QDebug>
#include <QProcess>
#include <QTimer>
#include <QFile>
#include <QTimer>
#include <QFileInfo>
#include <QSocketNotifier>

#include <stdlib.h>
#include <linux/input.h>
#include <fcntl.h>
#include <unistd.h>

class PowerKeyThread : public QObject {
    Q_OBJECT

public:
    explicit PowerKeyThread(QObject *parent = Q_NULLPTR);
    void startListening(void);
    int getRemainingTime(void);

private:
    QString m_eventFileName = "/dev/input/event1";
    QFile *m_sockfd;
    QSocketNotifier *m_socketNotifier;
    QTimer *m_timer;

private slots:
    void powerKeyListener(void);
    void doWork(void);

signals:
    void poweroffRequested(void);
    void buttonPressDetected(void);
    void buttonReleaseDetected(void);
};


#endif // POWERKEYTHREAD_H
