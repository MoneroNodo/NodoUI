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

void UserAuthentication::setUsernamePassword(QString oldPassword, QString newPassword)
{
    m_oldPassword = oldPassword;
    m_newPassword = newPassword;
}

void UserAuthentication::run()
{
    const struct pam_conv local_conversation = { function_conversation, NULL };
    pam_handle_t *local_auth_handle = NULL; // this gets set by pam_start

    int retval;

    // local_auth_handle gets set based on the service
    retval = pam_start("common-auth", m_username.toLocal8Bit(), &local_conversation, &local_auth_handle);

    if (retval != PAM_SUCCESS)
    {
        emit authenticationStatusReady(-2);
        return;
    }

    reply = (struct pam_response *)malloc(sizeof(struct pam_response));

    // *** Get the password by any method, or maybe it was passed into this function.
    int buffSize = m_oldPassword.size();
    char *p1 = (char*)malloc(buffSize+1);

    memset(p1, 0x00, buffSize+1);
    memcpy(p1, m_oldPassword.toLocal8Bit(), buffSize);
    reply[0].resp = p1;
    reply[0].resp_retcode = 0;

    retval = pam_authenticate(local_auth_handle, 0);

    if (retval != PAM_SUCCESS)
    {
        emit authenticationStatusReady(-2);
        return;
    }
    retval = pam_end(local_auth_handle, retval);

    if (retval != PAM_SUCCESS)
    {
        emit authenticationStatusReady(-2);
        return;
    }

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
