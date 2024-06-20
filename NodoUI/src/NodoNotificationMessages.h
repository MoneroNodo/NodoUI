#ifndef NODONOTIFICATIONMESSAGES_H
#define NODONOTIFICATIONMESSAGES_H
#include <QStringList>


#include <QObject>


typedef enum {
    NO_ERROR,
    RESTARTING_TOR_FAILED,
    RESTARTING_MONERO_FAILED,
    CONNECTION_TO_NODO_DBUS_FAILED,
    CONNECTION_TO_NODONM_DBUS_FAILED,
    GATHERING_IP_FAILED
} m_messageIDs;

class NodoNotifier : public QObject
{
    Q_OBJECT
public:
    NodoNotifier(QObject *parent = nullptr){Q_UNUSED(parent)};

    QString getMessageText(m_messageIDs m_id){
        return m_messageList.at(m_id);
    }

private:
    QStringList m_messageList = {
                                 "No Error",
                                 "Restarting tor service failed!",
                                 "Restarting monerod service failed!",
                                 "Connection to Nodo service failed!",
                                 "Connection to Nodonm service failed!",
                                 "IP couldn't be read!"
    };
};



#endif // NODONOTIFICATIONMESSAGES_H
