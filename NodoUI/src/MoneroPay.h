#ifndef MONEROPAY_H
#define MONEROPAY_H

#include <QObject>
#include <QList>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>

#include "NodoConfigParser.h"
#include "MoneroPayConnection.h"
#include "MoneroPayDbManager.h"

class MoneroPay : public QObject
{
    Q_OBJECT
public:
    explicit MoneroPay(NodoConfigParser *configParser = Q_NULLPTR);

    Q_INVOKABLE bool isComponentEnabled(void);
    Q_INVOKABLE void clearAllPayments(void);

    Q_INVOKABLE int getPaymentCount(void);
    Q_INVOKABLE void updateRequested(void);
    Q_INVOKABLE int getDefaultBlockConfirmations(void);

    Q_INVOKABLE qint64 getPaymentAmount(int index);
    Q_INVOKABLE double getFiatAmount(int index);
    Q_INVOKABLE int getPaymentStatus(int index);
    Q_INVOKABLE QDateTime getPaymentTimestamp(int index);
    Q_INVOKABLE QString getPaymentDepositAddress(int index);
    Q_INVOKABLE QString getPaymentTransactionID(int p_index, int t_index);
    Q_INVOKABLE QString getPaymentDescription(int index);
    Q_INVOKABLE void deletePayment(int index);
    Q_INVOKABLE int transactionIDSize(int index);
    Q_INVOKABLE void cancelPayment(int index);
    Q_INVOKABLE void cancelPayment(QString address);

    Q_INVOKABLE QString getMoneroPayAddress(void);
    Q_INVOKABLE QString getMoneroPayViewKey(void);
    Q_INVOKABLE void clearDepositAddress(void);
    Q_INVOKABLE void setDepositAddress(QString address, QString viewKey);
    Q_INVOKABLE void xmrRequestPayment(QString xmrAmount, QString fiatAmount, int fiatIndex, QString description, int blockConfirmation);
    Q_INVOKABLE double getReceivedAmount(void);
    Q_INVOKABLE QDateTime getReceivedTimestamp(void);
    Q_INVOKABLE QString getReceivedDepositAddress(void);
    Q_INVOKABLE QString getReceivedTransactionID(void);
    Q_INVOKABLE QString getReceivedDescription(void);
    Q_INVOKABLE QString getReceivedDescriptionHTMLEncoded(void);
    Q_INVOKABLE QDateTime getTime(void);

    Q_INVOKABLE int getLastPaymentID(void);


private:
    const QString m_mpayFile = "/home/nodo/mpay";
    const QString m_mpayKeyFile = "/home/nodo/mpay.keys";
    bool m_componentEnabled = true;
    bool isUpdateRequested = false;
    int m_paymentID = 0;
    const int m_defaultBlockConfirmations = 10;
    QString m_htmlDecodedDesctiption;

    NodoConfigParser *m_configParser;
    MoneroPayDbManager *m_dbManager;

    T_payment m_lastPayment;
    QList < T_payment > m_paymentResults;
    QList < T_payment > m_displayResults;
    QList <MoneroPayConnection*> m_paymentRequests;
    QList <int> paymentIDList;

    MoneroPayConnection *m_mpayConnection;

    int getActivePaymentIndex(int id);
    void enableComponent(bool enabled);
    int getPaymentIndexbyAddress(QString address);

signals:
    void paymentListReady(void);
    void componentEnabledStatusChanged(void);
    void depositAdressCleared(void);
    void paymentReceived(void);
    void paymentUpdated(void);
    void depositAddressReceived(void);

private slots:
    void paymentStatusReceived(int id);
    void updateDepositAddress(int id);
    void getPreviousPaymentResults(void);
    void healthResultReceived(bool result);
};



#endif // MONEROPAY_H
