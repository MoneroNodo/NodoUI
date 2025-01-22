#include "PowerKeyThread.h"

PowerKeyThread::PowerKeyThread(QObject *parent)
{
    Q_UNUSED(parent);
}

void PowerKeyThread::startListening(void)
{
    m_sockfd = new QFile(m_eventFileName);
    if(m_sockfd->open(QFile::ReadOnly))
    {
        qDebug() << "running thread for " << m_eventFileName;

        m_socketNotifier = new QSocketNotifier(m_sockfd->handle(), QSocketNotifier::Read, nullptr);
        connect(m_socketNotifier, SIGNAL(activated(int)), this, SLOT(powerKeyListener()));
        m_socketNotifier->setEnabled(true);
        m_timer = new QTimer(this);
        connect(m_timer, SIGNAL(timeout()), this, SLOT(doWork()));
    }
    else
    {
        qDebug() << "failed to open" << m_eventFileName;
    }
}

void PowerKeyThread::doWork(void)
{
    m_timer->stop();
    qDebug() << "factoryResetRequested";
    emit poweroffRequested();
}


void PowerKeyThread::powerKeyListener(void)
{
    struct input_event ev;

    int bytes = read(m_sockfd->handle(), &ev, sizeof(struct input_event));

    if (bytes < (int) sizeof(struct input_event)) {
        qDebug() << "something wrong happened";
        return;
    }

    if (EV_KEY == ev.type) {
        qDebug() << "file:" << m_eventFileName << "time:" << ev.time.tv_sec << "value: " << ev.value;

        if(1 == ev.value)
        {
            m_timer->start(4000);
            emit buttonPressDetected();
        }
        else
        {
            if(m_timer->remainingTime() > 0)
            {
                m_timer->stop();
                emit buttonReleaseDetected();
            }
        }
    }
}

int PowerKeyThread::getRemainingTime(void)
{
    int remaining = m_timer->remainingTime();
    return ceil(remaining/1000.0);
}
