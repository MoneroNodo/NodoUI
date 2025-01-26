#ifndef RECOVERYKEYTHREAD_H
#define RECOVERYKEYTHREAD_H


#include <QObject>
#include <QDebug>
#include <QProcess>
#include <QTimer>
#include <QFile>
#include <QDir>
#include <QTimer>
#include <QFileInfo>
#include <QThread>
#include <QSocketNotifier>

#include <stdlib.h>
#include <linux/input.h>
#include <fcntl.h>
#include <unistd.h>

#define BLOCKCHAIN_DEV "/dev/nvme0n1"
#define BLOCKCHAIN_PARTITION_PATH BLOCKCHAIN_DEV "p1"
#define BLOCKCHAIN_FS_TYPE "xfs"
#define BLOCKCHAIN_DEV_LABEL "NODO_BLOCKCHAIN"
#define BLOCKCHAIN_MOUNT_POINT "/media/monero/"
#define SWAP_FILE_FULL_PATH BLOCKCHAIN_MOUNT_POINT "swap"

#define FSTAB_FILE "/etc/fstab"

class RecoveryKeyThread : public QObject {
    Q_OBJECT

public:
    explicit RecoveryKeyThread(QObject *parent = Q_NULLPTR);
    void startListening(void);
    void recover(void);


public slots:
    int getBlockchainStorageStatus(void);
    void factoryResetApproved(void);

private:
    QString m_eventFileName = "/dev/input/event3";
    int blockChainStorageStatus = 0;
    struct timeval time_pressed;
    QFile *m_sockfd;
    QSocketNotifier *m_socketNotifier;


    void restartDevice(void);
    void umountDisk(void);
    void wipeDisk(void);
    void partedProcess(void);
    void createXFSPartition(void);
    QString getDeviceUUID(void);
    void createMountPoint(void);
    void factoryReset();
    void serviceControl(QString command);
    void daemonReload(void);
    void mountBlockchainPartition(void);
    void umountBlockchainPartition(void);
    void changePermissions(void);
    void createSwap(void);
    void createFstabEntries(void);
    QString getDevicePartitionName(void);
    QString readFstabEntries(void);
    void swapoff(void);
    void swapon(void);

private slots:
    void recoveryKeyListener(void);
    void finalizeRecovery(void);

signals:
    void factoryResetRequested(void);
    void factoryResetStarted(void);
    void factoryResetCompleted(void);
};

#endif // RECOVERYKEYTHREAD_H
