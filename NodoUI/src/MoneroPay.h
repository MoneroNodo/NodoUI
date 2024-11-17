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
    Q_INVOKABLE int getDefaultBlockConfirmations(void);

    Q_INVOKABLE qint64 getPaymentAmount(int index);
    Q_INVOKABLE double getFiatAmount(int index);
    Q_INVOKABLE int getPaymentStatus(int index);
    Q_INVOKABLE QDateTime getPaymentTimestamp(int index);
    Q_INVOKABLE QString getPaymentDepositAddress(int index);
    Q_INVOKABLE QString getPaymentTransactionID(int p_index, int t_index);
    Q_INVOKABLE QString getPaymentDescription(int index);
    Q_INVOKABLE void deletePayment(QString address);
    Q_INVOKABLE int transactionIDSize(int index);

    Q_INVOKABLE QString getMoneroPayAddress(void);
    Q_INVOKABLE QString getMoneroPayViewKey(void);
    Q_INVOKABLE void clearDepositAddress(void);
    Q_INVOKABLE void setDepositAddress(QString address, QString viewKey);
    Q_INVOKABLE void xmrRequestPayment(QString xmrAmount, QString fiatAmount, int fiatIndex, QString description, int blockConfirmation);

    Q_INVOKABLE double getLastXMRAmount(void);
    Q_INVOKABLE double getLastFiatAmount(void);
    Q_INVOKABLE QString getLastDescription(void);
    Q_INVOKABLE QString getLastDepositAddress(void);
    Q_INVOKABLE QDateTime getLastTimestamp(void);
    Q_INVOKABLE QString getLastDescriptionHTMLEncoded(void);
    Q_INVOKABLE QString getLastTransactionID(void);

    Q_INVOKABLE void newPaymentRequest(void);
    Q_INVOKABLE void openViewPaymentsScreenRequest(void);

    Q_INVOKABLE QString getDescriptionHTMLEncoded(int index);



private:
    const QString m_mpayFile = "/home/nodo/mpay";
    const QString m_mpayKeyFile = "/home/nodo/mpay.keys";
    bool m_componentEnabled = true;
    int m_paymentID = 0;
    const int m_defaultBlockConfirmations = 10;
    QString m_htmlDecodedDesctiption;

    NodoConfigParser *m_configParser;
    MoneroPayDbManager *m_dbManager;

    payment_t m_lastPayment;
    QList < payment_t > m_displayResults;
    QList < payment_t > m_payments;
    QList <MoneroPayConnection*> m_mpayRequests;
    QList <int> paymentIDList;

    bool m_isClearAllPaymentsRequested = false;

    MoneroPayConnection *m_mpayConnection;

    int getPaymentIndexbyID(int id);
    int getRequestIndexbyID(int id);
    void enableComponent(bool enabled);
    int getPaymentIndexbyAddress(QString address);
    int getRequestIndexbyPaymentID(int ID);

signals:
    void paymentListReady(void);
    void componentEnabledStatusChanged(void);
    void depositAddressCleared(void);
    void paymentReceived(void);
    void depositAddressReceived(void);

    void newPaymentRequested(void);
    void openViewPaymentsScreenRequested(void);

private slots:
    void paymentStatusReceived(void);
    void updateDepositAddress(void);
    void getPreviousPaymentResults(void);
};



#endif // MONEROPAY_H
