#ifndef MONEROPAYCONNECTION_H
#define MONEROPAYCONNECTION_H

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDate>
#include <QTimer>

#define SCAN_TIMEOUT_IN_MS 1000

typedef enum {
    PAYMENT_SATUS_NONE,
    PAYMENT_SATUS_RECEIVED,
    PAYMENT_SATUS_PENDING,
    PAYMENT_SATUS_CANCELLED,
} PAYMENT_SATUS;

typedef struct {
    PAYMENT_SATUS paymentStatus;
    qint64 xmrAmountInPico;
    double fiatAmount;
    int fiatIndex;
    QString depositAddress;
    QStringList transactionIDList;
    QDateTime dateTime;
    QString description;
    int id;
    int blockConfirmation;
    bool signalDisabled;
    bool isfromdb;
} T_payment;

typedef struct {
    QString address;
    qint64 amount;
    QString description;
    QDateTime created_at;
}response_msg_t;

Q_DECLARE_METATYPE(T_payment)

class MoneroPayConnection : public QObject
{
    Q_OBJECT
public:
    explicit MoneroPayConnection(T_payment payment);
    explicit MoneroPayConnection(QObject *parent = Q_NULLPTR);
    ~MoneroPayConnection();

    void requestPayment(void);
    void requestPreviousPayment(void);
    T_payment getPayment(void);
    void setSignalDisabled(bool newStat);
    int getID(void);
    void checkHealth(void);


signals:
    void paymentStatusChanged(int id);
    void depositAddressReceived(int id);
    void healthResultReady(bool result);

private:
    T_payment m_payment;
    QNetworkAccessManager *m_networkAccessManager;
    QTimer *m_requestTimer;

    void initialise(void);

    void replyFinished(QNetworkReply *reply);
    response_msg_t parseReceivePost(QByteArray reply);
    void parseReceiveAddress(QByteArray replyMessage);
    void requestPaymentStatus(QString address);

private slots:
    void sendRequest(void);

};
#endif // MONEROPAYCONNECTION_H
