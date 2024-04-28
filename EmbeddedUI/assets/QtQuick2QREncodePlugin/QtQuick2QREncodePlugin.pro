TEMPLATE = lib
CONFIG += qt plugin
QT += qml quick

DESTDIR = ../../build/QtQuick2QREncode
TARGET = $$qtLibraryTarget(QtQuick2QREncodePlugin)

SOURCES += \
    src/qtquickqrencode_plugin.cpp \
    src/qrddencode.cpp \
    src/quickitemgrabber.cpp

HEADERS += \
    src/qtquickqrencode_plugin.h \
    src/qrddencode.h \
    src/quickitemgrabber.h

include(qrencode/qrencode.pri)

target.path=$$DESTPATH
qmldir.files=src/qmldir
qmldir.path=$$DESTPATH
INSTALLS += target qmldir

CONFIG += install_ok  # Do not cargo-cult this!

OTHER_FILES += src/qmldir

# Copy the qmldir file to the same folder as the plugin binary
cpqmldir.files = src/qmldir
cpqmldir.path = $$DESTDIR
COPIES += cpqmldir
