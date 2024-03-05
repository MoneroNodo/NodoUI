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
    i18n/EmbeddedUI_af.ts \
    i18n/EmbeddedUI_am.ts \
    i18n/EmbeddedUI_ar.ts \
    i18n/EmbeddedUI_as.ts \
    i18n/EmbeddedUI_az.ts \
    i18n/EmbeddedUI_be.ts \
    i18n/EmbeddedUI_bg.ts \
    i18n/EmbeddedUI_bn.ts \
    i18n/EmbeddedUI_bo.ts \
    i18n/EmbeddedUI_br.ts \
    i18n/EmbeddedUI_bs.ts \
    i18n/EmbeddedUI_ca.ts \
    i18n/EmbeddedUI_cs.ts \
    i18n/EmbeddedUI_cy.ts \
    i18n/EmbeddedUI_da.ts \
    i18n/EmbeddedUI_de.ts \
    i18n/EmbeddedUI_dsb.ts \
    i18n/EmbeddedUI_el.ts \
    i18n/EmbeddedUI_en.ts \
    i18n/EmbeddedUI_es.ts \
    i18n/EmbeddedUI_et.ts \
    i18n/EmbeddedUI_eu.ts \
    i18n/EmbeddedUI_fa.ts \
    i18n/EmbeddedUI_fi.ts \
    i18n/EmbeddedUI_fil.ts \
    i18n/EmbeddedUI_fo.ts \
    i18n/EmbeddedUI_fr.ts \
    i18n/EmbeddedUI_fy.ts \
    i18n/EmbeddedUI_ga.ts \
    i18n/EmbeddedUI_gd.ts \
    i18n/EmbeddedUI_gl.ts \
    i18n/EmbeddedUI_gsw.ts \
    i18n/EmbeddedUI_gu.ts \
    i18n/EmbeddedUI_ha.ts \
    i18n/EmbeddedUI_he.ts \
    i18n/EmbeddedUI_hi.ts \
    i18n/EmbeddedUI_hr.ts \
    i18n/EmbeddedUI_hsb.ts \
    i18n/EmbeddedUI_hu.ts \
    i18n/EmbeddedUI_hy.ts \
    i18n/EmbeddedUI_id.ts \
    i18n/EmbeddedUI_ig.ts \
    i18n/EmbeddedUI_ii.ts \
    i18n/EmbeddedUI_is.ts \
    i18n/EmbeddedUI_it.ts \
    i18n/EmbeddedUI_ja.ts \
    i18n/EmbeddedUI_ka.ts \
    i18n/EmbeddedUI_kk.ts \
    i18n/EmbeddedUI_kl.ts \
    i18n/EmbeddedUI_km.ts \
    i18n/EmbeddedUI_kn.ts \
    i18n/EmbeddedUI_ko.ts \
    i18n/EmbeddedUI_kok.ts \
    i18n/EmbeddedUI_ky.ts \
    i18n/EmbeddedUI_lb.ts \
    i18n/EmbeddedUI_lo.ts \
    i18n/EmbeddedUI_lt.ts \
    i18n/EmbeddedUI_lv.ts \
    i18n/EmbeddedUI_mi.ts \
    i18n/EmbeddedUI_mk.ts \
    i18n/EmbeddedUI_ml.ts \
    i18n/EmbeddedUI_mn.ts \
    i18n/EmbeddedUI_mr.ts \
    i18n/EmbeddedUI_ms.ts \
    i18n/EmbeddedUI_mt.ts \
    i18n/EmbeddedUI_my.ts \
    i18n/EmbeddedUI_nb.ts \
    i18n/EmbeddedUI_ne.ts \
    i18n/EmbeddedUI_nl.ts \
    i18n/EmbeddedUI_nn.ts \
    i18n/EmbeddedUI_no.ts \
    i18n/EmbeddedUI_or.ts \
    i18n/EmbeddedUI_pa.ts \
    i18n/EmbeddedUI_pl.ts \
    i18n/EmbeddedUI_ps.ts \
    i18n/EmbeddedUI_pt.ts \
    i18n/EmbeddedUI_qu.ts \
    i18n/EmbeddedUI_rm.ts \
    i18n/EmbeddedUI_ro.ts \
    i18n/EmbeddedUI_ru.ts \
    i18n/EmbeddedUI_rw.ts \
    i18n/EmbeddedUI_sah.ts \
    i18n/EmbeddedUI_se.ts \
    i18n/EmbeddedUI_si.ts \
    i18n/EmbeddedUI_sk.ts \
    i18n/EmbeddedUI_sl.ts \
    i18n/EmbeddedUI_smn.ts \
    i18n/EmbeddedUI_sq.ts \
    i18n/EmbeddedUI_sr.ts \
    i18n/EmbeddedUI_sv.ts \
    i18n/EmbeddedUI_sw.ts \
    i18n/EmbeddedUI_ta.ts \
    i18n/EmbeddedUI_te.ts \
    i18n/EmbeddedUI_tg.ts \
    i18n/EmbeddedUI_th.ts \
    i18n/EmbeddedUI_tk.ts \
    i18n/EmbeddedUI_tr.ts \
    i18n/EmbeddedUI_tt.ts \
    i18n/EmbeddedUI_tzm.ts \
    i18n/EmbeddedUI_ug.ts \
    i18n/EmbeddedUI_uk.ts \
    i18n/EmbeddedUI_ur.ts \
    i18n/EmbeddedUI_uz.ts \
    i18n/EmbeddedUI_vi.ts \
    i18n/EmbeddedUI_wo.ts \
    i18n/EmbeddedUI_xh.ts \
    i18n/EmbeddedUI_yo.ts \
    i18n/EmbeddedUI_zh.ts \
    i18n/EmbeddedUI_zh-Hans.ts \
    i18n/EmbeddedUI_zh-Hant.ts \
    i18n/EmbeddedUI_zu.ts \

DISTFILES += \
    i18n/EmbeddedUI_en.qm \
    i18n/EmbeddedUI_en.rs \


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
