/*
original source code can be found here: https://stackoverflow.com/questions/10910193/how-to-authenticate-username-password-using-pam-w-o-root-privileges
*/

#include "UserAuthentication.h"

struct pam_response *reply;

UserAuthentication::UserAuthentication(QObject *parent)
    : QObject{parent}
{
}

UserAuthentication::~UserAuthentication()
{
}

int function_conversation(int num_msg, const struct pam_message **msg, struct pam_response **resp, void *appdata_ptr)
{
    Q_UNUSED(num_msg);
    Q_UNUSED(msg);
    Q_UNUSED(appdata_ptr);

    *resp = reply;
    return PAM_SUCCESS;
}

void UserAuthentication::setUsernamePassword(QString newPassword)
{
    m_newPassword = newPassword;
}

void UserAuthentication::run()
{
    QProcess sh;
    QString tmp = QString("echo \"").append(m_username).append(":").append(m_newPassword).append("\"  | chpasswd");
    sh.start( "sh", { "-c", tmp});
    sh.waitForFinished( -1 );

    if(0 != sh.exitCode())
    {
        emit authenticationStatusReady(-1);
        return;
    }
    emit authenticationStatusReady(0);
}
