#include <QCoreApplication>
#include <QObject>
#include "NodoDbusNetworkManager.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    NodoNetworkManager *nm = new NodoNetworkManager();

    return a.exec();
}
