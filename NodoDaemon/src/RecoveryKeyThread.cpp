#include "RecoveryKeyThread.h"

RecoveryKeyThread::RecoveryKeyThread(QObject *parent)
{
    Q_UNUSED(parent);
    qDebug() << "running thread for " << m_eventFileName;

    if(!QFileInfo::exists(BLOCKCHAIN_DEV))
    {
        qDebug() << "1 Blockchain storage not found!";

        blockChainStorageStatus = 1;

        //we need to delete /etc/fstab entries as there is no blockchain disk
        QFile fstabFile(FSTAB_FILE);
        if (fstabFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
            fstabFile.close();
        }

        qDebug() << "1 Erased /etc/fstab entries";

        return;
    }

    createMountPoint();

    if(!QFileInfo::exists(BLOCKCHAIN_PARTITION_PATH))
    {
        qDebug() << "2 Found " << BLOCKCHAIN_PARTITION_PATH << "Creating partition";

        blockChainStorageStatus = 2;

        //there is blockchain disk but there is no partition. Create it
        serviceControl("stop");
        wipeDisk();
        partedProcess();
        createXFSPartition();
        daemonReload();
        mountBlockchainPartition();
        changePermissions();
        createSwap();
        createFstabEntries();
        serviceControl("restart");

        qDebug() << "2 Created " << BLOCKCHAIN_PARTITION_PATH;

        return;
    }

    QString partitionName = getDevicePartitionName();

    if(partitionName == BLOCKCHAIN_DEV_LABEL)
    {
        qDebug() << "3 Found " << BLOCKCHAIN_DEV_LABEL;

        QString UUID = getDeviceUUID();
        QString fstabEntries = readFstabEntries();

        if(fstabEntries.isEmpty() || !fstabEntries.contains(UUID))
        {
            qDebug() << UUID << " not found in /etc/fstab";
            createFstabEntries();
            qDebug() << "3 Created /etc/fstab entries";
            daemonReload();
            mountBlockchainPartition();
            changePermissions();
            qDebug() << "3 done";
        }
    }

    if(!QFileInfo::exists(SWAP_FILE_FULL_PATH))
    {
        qDebug() << "4 Swap file not found in " << SWAP_FILE_FULL_PATH;
        createSwap();
        qDebug() << "4 Created swap file";
    }

    swapon();

    qDebug() << "5 Everything looks normal";
}

QString RecoveryKeyThread::getDevicePartitionName(void)
{
    QString program = "/usr/sbin/blkid";
    QProcess process;
    QStringList arguments;

    arguments << "-s" << "PARTLABEL" << "-o" << "value" << BLOCKCHAIN_PARTITION_PATH;

    process.start(program, arguments);
    process.waitForFinished(-1);

    QString retVal = process.readAll();
    retVal.chop(1);

    return retVal;
}

void RecoveryKeyThread::createFstabEntries(void)
{
    QString UUID = getDeviceUUID();
    QFile fstabFile(FSTAB_FILE);
    if (fstabFile.open(QIODevice::WriteOnly)) {
        QTextStream stream(&fstabFile);
        QString fstabEntry = QString("\nUUID=").append(UUID).append("\t/media/monero\txfs\tdefaults,noatime,nofail,x-systemd.device-timeout=3\t0\t0\n");
        fstabEntry.append(SWAP_FILE_FULL_PATH).append("\tnone\tswap\tdefaults\t0\t0\n");
        stream << fstabEntry;
        fstabFile.close();
    }
}

QString RecoveryKeyThread::readFstabEntries(void)
{
    QString retVal;
    QFile fstabFile(FSTAB_FILE);
    if (fstabFile.open(QIODevice::ReadOnly)) {
        retVal = fstabFile.readAll();
    }

    return retVal;
}

void RecoveryKeyThread::startListening(void)
{
    m_sockfd = new QFile(m_eventFileName);
    if(m_sockfd->open(QFile::ReadOnly))
    {
        qDebug() << m_eventFileName << "opened successfully";

        m_socketNotifier = new QSocketNotifier(m_sockfd->handle(), QSocketNotifier::Read, nullptr);
        connect(m_socketNotifier, SIGNAL(activated(int)), this, SLOT(recoveryKeyListener()));
        m_socketNotifier->setEnabled(true);
    }
    else
    {
        qDebug() << "failed to open" << m_eventFileName;
    }
}

void RecoveryKeyThread::recoveryKeyListener(void)
{
    struct input_event ev;

    int bytes = read(m_sockfd->handle(), &ev, sizeof(struct input_event));

    if (bytes < (int) sizeof(struct input_event)) {
        qDebug() << "something wrong happened";
        return;
    }

    if (EV_KEY == ev.type) {
        qDebug() << "file:" << m_eventFileName << "time:" << ev.time.tv_sec << "value: " << ev.value;

        if(1 == ev.value)
        {
            time_pressed = ev.time;
        }
        else
        {
            double timet1 = time_pressed.tv_sec + (time_pressed.tv_usec/1000000.0);
            double timet2 = ev.time.tv_sec + (ev.time.tv_usec/1000000.0);

            if(timet2 - timet1 > 3.0)
            {
                qDebug() << "factoryResetRequested";
                emit factoryResetRequested();
            }
        }
    }
}

void RecoveryKeyThread::factoryResetApproved(void)
{
    recover();
}

void RecoveryKeyThread::recover(void)
{
    emit factoryResetStarted();
    serviceControl("stop");
    swapoff();
    umountBlockchainPartition();
    wipeDisk();
    partedProcess();
    createXFSPartition();
    daemonReload();
    mountBlockchainPartition();
    changePermissions();
    createSwap();

    QString filename  = QString(BLOCKCHAIN_MOUNT_POINT).append("nodo-dbus");
    QFile file(filename);
    file.open(QIODevice::ReadWrite | QIODevice::Text);
    file.close();

    emit factoryResetCompleted();
    QTimer::singleShot(2000, this, SLOT(finaliseRevocery()));
}

void RecoveryKeyThread::finaliseRevocery(void)
{
    factoryReset();
    restartDevice();
}

void RecoveryKeyThread::restartDevice(void)
{
    QString program = "/usr/bin/systemctl";

    QStringList arguments;
    arguments << "reboot";

    QProcess process;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::umountDisk(void)
{
    QString program = "/usr/bin/umount";
    QProcess process;
    QStringList arguments;

    arguments << "-vf" << BLOCKCHAIN_PARTITION_PATH;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::wipeDisk(void)
{
    QString program = "/usr/sbin/wipefs";
    QProcess process;
    QStringList arguments;

    arguments << "--all" << BLOCKCHAIN_DEV;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::partedProcess(void)
{
    QString program = "/usr/sbin/parted";
    QProcess process;
    QStringList arguments;

    arguments << "--script" << BLOCKCHAIN_DEV << "mklabel" << "gpt" << "mkpart" << "primary" << "1MiB" << "100%" << "name" << "1" << BLOCKCHAIN_DEV_LABEL;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::createXFSPartition(void)
{
    QString program = "/usr/sbin/mkfs.xfs";
    QProcess process;
    QStringList arguments;

    arguments << "-f" << BLOCKCHAIN_PARTITION_PATH;

    process.start(program, arguments);
    process.waitForFinished(-1);
}


QString RecoveryKeyThread::getDeviceUUID(void)
{
    QString program = "/usr/sbin/blkid";
    QProcess process;
    QStringList arguments;

    arguments << "-s" << "UUID" << "-o" << "value" << BLOCKCHAIN_PARTITION_PATH;

    process.start(program, arguments);
    process.waitForFinished(-1);

    QString retVal = process.readAll();
    retVal.chop(1);

    return retVal;
}

void RecoveryKeyThread::createMountPoint(void)
{
    QDir dir(BLOCKCHAIN_MOUNT_POINT);
    if (dir.exists())
    {
        qDebug() << "Found blockchain mount point " << BLOCKCHAIN_MOUNT_POINT;
        return;
    }

    qDebug() << "Blockchain mount point " << BLOCKCHAIN_MOUNT_POINT << " not found";

    QString program = "/usr/bin/mkdir";
    QProcess process;
    QStringList arguments;

    arguments << "-p" << "/media/monero";

    process.start(program, arguments);
    process.waitForFinished(-1);

    qDebug() << "Created " << BLOCKCHAIN_MOUNT_POINT;
}

void RecoveryKeyThread::factoryReset()
{
    QString program = "/usr/local/bin/firstboot";
    QProcess process;

    process.start(program);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::serviceControl(QString command)
{
    const static QStringList services = {"monerod", "monero-lws", "webui"};

    QString program = "/usr/bin/systemctl";

    for(int i = 0; i < services.size(); i++)
    {
        QStringList arguments;
        QProcess process;
        arguments << command << services.at(i);

        process.start(program, arguments);
        process.waitForFinished(-1);
    }
}

void RecoveryKeyThread::daemonReload(void)
{
    QString program = "/usr/bin/systemctl";
    QProcess process;
    QStringList arguments;

    arguments << "daemon-reload";

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::mountBlockchainPartition(void)
{
    QString program = "/usr/bin/mount";
    QStringList arguments;
    QProcess process;

    arguments << BLOCKCHAIN_PARTITION_PATH << "/media/monero";

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::umountBlockchainPartition(void)
{
    QString program = "/usr/bin/umount";
    QStringList arguments;
    QProcess process;

    arguments << BLOCKCHAIN_PARTITION_PATH;

    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::changePermissions(void)
{
    QString program = "/usr/bin/chown";
    QProcess process;
    QStringList arguments;

    arguments << "monero:monero" << "-R" << "/media/monero";
    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::createSwap(void)
{
    QString program = "/usr/bin/dd";
    QProcess process;
    QStringList arguments;
    QString s = QString("of=").append(SWAP_FILE_FULL_PATH);

    arguments << "if=/dev/zero" << s << "bs=1M" << "count=1024" << "conv=sync";
    process.start(program, arguments);
    process.waitForFinished(-1);

    program = "/usr/sbin/mkswap";
    arguments.clear();
    arguments << SWAP_FILE_FULL_PATH;
    process.start(program, arguments);
    process.waitForFinished(-1);

    program = "/usr/bin/chown";
    arguments.clear();
    arguments << "0600" << SWAP_FILE_FULL_PATH;
    process.start(program, arguments);
    process.waitForFinished(-1);

    program = "/usr/sbin/swapon";
    arguments.clear();
    arguments << SWAP_FILE_FULL_PATH;
    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::swapoff(void)
{
    QString program = "/usr/sbin/swapoff";
    QProcess process;
    QStringList arguments;
    arguments << SWAP_FILE_FULL_PATH;
    process.start(program, arguments);
    process.waitForFinished(-1);
}

void RecoveryKeyThread::swapon(void)
{
    QString program = "/usr/sbin/swapon";
    QProcess process;
    QStringList arguments;
    arguments << "-s";
    process.start(program, arguments);
    process.waitForFinished(-1);

    QString retval = process.readAll();

    if(retval.isEmpty())
    {
        qDebug() << "Swap partition not in use. Activating swap!";
        arguments.clear();
        arguments << SWAP_FILE_FULL_PATH;
        process.start(program, arguments);
        process.waitForFinished(-1);
        qDebug() << "Swap activation done";
        return;
    }

    qDebug() << "Swap partition is in use";
}

int RecoveryKeyThread::getBlockchainStorageStatus(void)
{
    return blockChainStorageStatus;
}
