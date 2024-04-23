TEMPLATE = lib
CONFIG += plugin qmltypes
QT += qml quick

QML_IMPORT_NAME = NodoCanvas
QML_IMPORT_MAJOR_VERSION = 1

DESTDIR = ../../build/$$QML_IMPORT_NAME
TARGET = $$qtLibraryTarget(NodoCanvasPlugin)

HEADERS += NodoCanvas.h \
           NodoCanvasPlugin.h

SOURCES += NodoCanvas.cpp

target.path=$$DESTPATH
qmldir.files=$$PWD/qmldir
qmldir.path=$$DESTPATH
INSTALLS += target qmldir

CONFIG += install_ok  # Do not cargo-cult this!

OTHER_FILES += qmldir

# Copy the qmldir file to the same folder as the plugin binary
cpqmldir.files = qmldir
cpqmldir.path = $$DESTDIR
COPIES += cpqmldir
