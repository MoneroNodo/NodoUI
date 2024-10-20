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
    PAYMENT_SATUS_NOT_RECEIVED
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
    bool isfromdb;
} payment_t;

typedef struct {
    QString address;
    qint64 amount;
    QString description;
    QDateTime created_at;
}response_msg_t;

Q_DECLARE_METATYPE(payment_t)

class MoneroPayConnection : public QObject
{
    Q_OBJECT
public:
    explicit MoneroPayConnection(payment_t payment);
    explicit MoneroPayConnection(QObject *parent = Q_NULLPTR);
    ~MoneroPayConnection();

    void requestPayment(void);
    void requestPreviousPayment(void);
    payment_t getPayment(void);
    int getID(void);
    void checkHealth(void);

signals:
    void paymentStatusChanged(void);
    void depositAddressReceived(void);
    void healthResultReady(bool result);

private:
    payment_t m_payment;
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
