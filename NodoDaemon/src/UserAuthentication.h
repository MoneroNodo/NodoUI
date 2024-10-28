#ifndef USERAUTHENTICATION_H
#define USERAUTHENTICATION_H

#include <QObject>
#include <QRunnable>
#include <QThread>
#include <QProcess>
#include <QDebug>

#include <security/pam_appl.h>

class UserAuthentication : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit UserAuthentication(QObject *parent = nullptr);
    ~UserAuthentication();

    void run() Q_DECL_OVERRIDE;
    void setUsernamePassword(QString oldPassword, QString newPassword);

private:
    QString m_username = "nodo";
    QString m_oldPassword;
    QString m_newPassword;

signals:
    void authenticationStatusReady(int);
};

#endif // USERAUTHENTICATION_H
