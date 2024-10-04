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
    GATHERING_IP_FAILED,
    NO_NETWORK_DEVICE,
    CABLE_DISCONNECTED,
    SOMETHING_IS_WRONG,
    NEW_PIN_IS_SET,
    RESTARTING_BLOCK_EXPLORER_FAILED,
    PASSWORD_DOESNT_MEET_REQUIREMENTS,
    PASSWORDS_DONT_MATCH,

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
                                tr("No Error"),
                                tr("Restarting tor service failed!"),
                                tr("Restarting monerod service failed!"),
                                tr("Connection to Network Manager service failed!"),
                                tr("Connection to Nodonm service failed!"),
                                tr("IP couldn't be read!"),
                                tr("No network device found!"),
                                tr("Cable disconnected!"),
                                tr("Something is wrong!"),
                                tr("New PIN is set successfully!"),
                                tr("Failed to change Block Explorer Service!"),
                                tr("Password doesn't meet requirements."),
                                tr("Passwords do not match.")
    };
};



#endif // NODONOTIFICATIONMESSAGES_H
