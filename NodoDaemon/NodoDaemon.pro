QT       += core dbus network

DBUS_ADAPTORS += nodo_dbus.xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17 cmdline

TARGET = NodoDaemon

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/main.cpp \
        src/daemon.cpp \
        src/PowerKeyThread.cpp \
        src/RecoveryKeyThread.cpp \

HEADERS += \
    src/daemon.h \
    src/PowerKeyThread.h \
    src/RecoveryKeyThread.h


CONFIG(debug, debug|release) {
    DESTDIR = build
}
CONFIG(release, debug|release) {
    DESTDIR = build
}

OBJECTS_DIR = $$DESTDIR/obj
MOC_DIR = $$DESTDIR/moc
RCC_DIR = $$DESTDIR/qrc
UI_DIR = $$DESTDIR/u

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
