QT += qml quick core widgets gui dbus
QT += virtualkeyboard
QT += network
TEMPLATE = app
CONFIG += c++17

TARGET = EmbeddedUI

DBUS_INTERFACES += nodo_embedded.xml

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/NodoEmbeddedUIConfigParser.cpp \
        src/NodoConfigParser.cpp \
        src/NodoSystemStatusParser.cpp \
        src/main.cpp \
        src/NodoFeedParser.cpp \
        src/NodoSystemControl.cpp \
        src/pugixml.cpp \
        src/NodoTranslator.cpp \
        src/NodoDBusController.cpp \


HEADERS += \
        src/NodoEmbeddedUIConfigParser.h \
        src/NodoConfigParser.h \
        src/NodoSystemStatusParser.h \
        src/NodoFeedParser.h \
        src/NodoSystemControl.h \
        src/pugixml.hpp \
        src/pugiconfig.hpp \
        src/NodoTranslator.h \
        src/NodoDBusController.h \

RESOURCES += qml.qrc

disable-xcb {
     CONFIG += disable-desktop
}

TRANSLATIONS += \
    i18n/EmbeddedUI_en_GB.ts \
    i18n/EmbeddedUI_en_US.ts \

DISTFILES += \
    i18n/EmbeddedUI_en_GB.qm \
    i18n/EmbeddedUI_en_GB.rs \
    i18n/EmbeddedUI_en_US.qm \
    i18n/EmbeddedUI_en_US.ts \


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/assets
QML2_IMPORT_PATH = $$PWD/assets

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

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

DISTFILES +=
