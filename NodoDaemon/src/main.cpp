#include <QCoreApplication>
#include <QObject>
#include "daemon.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    Daemon *daemon = new Daemon();

    return a.exec();
}
