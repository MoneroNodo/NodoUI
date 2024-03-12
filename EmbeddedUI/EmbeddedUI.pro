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
    i18n/EmbeddedUI_af_ZA.ts \
    i18n/EmbeddedUI_am_ET.ts \
    i18n/EmbeddedUI_ar_EG.ts \
    i18n/EmbeddedUI_as_IN.ts \
    i18n/EmbeddedUI_az_AZ.ts \
    i18n/EmbeddedUI_be_BY.ts \
    i18n/EmbeddedUI_bg_BG.ts \
    i18n/EmbeddedUI_bn_BD.ts \
    i18n/EmbeddedUI_bo_CN.ts \
    i18n/EmbeddedUI_br_FR.ts \
    i18n/EmbeddedUI_bs_BA.ts \
    i18n/EmbeddedUI_ca_ES.ts \
    i18n/EmbeddedUI_cs_CZ.ts \
    i18n/EmbeddedUI_cy_GB.ts \
    i18n/EmbeddedUI_da_DK.ts \
    i18n/EmbeddedUI_de_DE.ts \
    i18n/EmbeddedUI_dsb_DE.ts \
    i18n/EmbeddedUI_el_GR.ts \
    i18n/EmbeddedUI_en_US.ts \
    i18n/EmbeddedUI_es_ES.ts \
    i18n/EmbeddedUI_et_EE.ts \
    i18n/EmbeddedUI_eu_ES.ts \
    i18n/EmbeddedUI_fa_IR.ts \
    i18n/EmbeddedUI_fi_FI.ts \
    i18n/EmbeddedUI_fil_PH.ts \
    i18n/EmbeddedUI_fo_FO.ts \
    i18n/EmbeddedUI_fr_FR.ts \
    i18n/EmbeddedUI_fy_NL.ts \
    i18n/EmbeddedUI_ga_IE.ts \
    i18n/EmbeddedUI_gd_GB.ts \
    i18n/EmbeddedUI_gl_ES.ts \
    i18n/EmbeddedUI_gsw_CH.ts \
    i18n/EmbeddedUI_gu_IN.ts \
    i18n/EmbeddedUI_ha_NG.ts \
    i18n/EmbeddedUI_he_IL.ts \
    i18n/EmbeddedUI_hi_IN.ts \
    i18n/EmbeddedUI_hr_HR.ts \
    i18n/EmbeddedUI_hsb_DE.ts \
    i18n/EmbeddedUI_hu_HU.ts \
    i18n/EmbeddedUI_hy_AM.ts \
    i18n/EmbeddedUI_id_ID.ts \
    i18n/EmbeddedUI_ig_NG.ts \
    i18n/EmbeddedUI_ii_CN.ts \
    i18n/EmbeddedUI_is_IS.ts \
    i18n/EmbeddedUI_it_IT.ts \
    i18n/EmbeddedUI_ja_JP.ts \
    i18n/EmbeddedUI_ka_GE.ts \
    i18n/EmbeddedUI_kk_KZ.ts \
    i18n/EmbeddedUI_kl_GL.ts \
    i18n/EmbeddedUI_km_KH.ts \
    i18n/EmbeddedUI_kn_IN.ts \
    i18n/EmbeddedUI_ko_KR.ts \
    i18n/EmbeddedUI_kok_IN.ts \
    i18n/EmbeddedUI_ky_KG.ts \
    i18n/EmbeddedUI_lb_LU.ts \
    i18n/EmbeddedUI_lo_LA.ts \
    i18n/EmbeddedUI_lt_LT.ts \
    i18n/EmbeddedUI_lv_LV.ts \
    i18n/EmbeddedUI_mi_NZ.ts \
    i18n/EmbeddedUI_mk_MK.ts \
    i18n/EmbeddedUI_ml_IN.ts \
    i18n/EmbeddedUI_mn_MN.ts \
    i18n/EmbeddedUI_mr_IN.ts \
    i18n/EmbeddedUI_ms_MY.ts \
    i18n/EmbeddedUI_mt_MT.ts \
    i18n/EmbeddedUI_my_MM.ts \
    i18n/EmbeddedUI_nb_NO.ts \
    i18n/EmbeddedUI_ne_NP.ts \
    i18n/EmbeddedUI_nl_NL.ts \
    i18n/EmbeddedUI_nn_NO.ts \
    i18n/EmbeddedUI_nb_NO.ts \
    i18n/EmbeddedUI_or_IN.ts \
    i18n/EmbeddedUI_pa_IN.ts \
    i18n/EmbeddedUI_pl_PL.ts \
    i18n/EmbeddedUI_ps_AF.ts \
    i18n/EmbeddedUI_pt_BR.ts \
    i18n/EmbeddedUI_qu_PE.ts \
    i18n/EmbeddedUI_rm_CH.ts \
    i18n/EmbeddedUI_ro_RO.ts \
    i18n/EmbeddedUI_ru_RU.ts \
    i18n/EmbeddedUI_rw_RW.ts \
    i18n/EmbeddedUI_sah_RU.ts \
    i18n/EmbeddedUI_se_NO.ts \
    i18n/EmbeddedUI_si_LK.ts \
    i18n/EmbeddedUI_sk_SK.ts \
    i18n/EmbeddedUI_sl_SI.ts \
    i18n/EmbeddedUI_smn_FI.ts \
    i18n/EmbeddedUI_sq_AL.ts \
    i18n/EmbeddedUI_sr_RS.ts \
    i18n/EmbeddedUI_sv_SE.ts \
    i18n/EmbeddedUI_sw_TZ.ts \
    i18n/EmbeddedUI_ta_IN.ts \
    i18n/EmbeddedUI_te_IN.ts \
    i18n/EmbeddedUI_tg_TJ.ts \
    i18n/EmbeddedUI_th_TH.ts \
    i18n/EmbeddedUI_tk_TM.ts \
    i18n/EmbeddedUI_tr_TR.ts \
    i18n/EmbeddedUI_tt_RU.ts \
    i18n/EmbeddedUI_tzm_MA.ts \
    i18n/EmbeddedUI_ug_CN.ts \
    i18n/EmbeddedUI_uk_UA.ts \
    i18n/EmbeddedUI_ur_PK.ts \
    i18n/EmbeddedUI_uz_UZ.ts \
    i18n/EmbeddedUI_vi_VN.ts \
    i18n/EmbeddedUI_wo_SN.ts \
    i18n/EmbeddedUI_xh_ZA.ts \
    i18n/EmbeddedUI_yo_NG.ts \
    i18n/EmbeddedUI_zh_CN.ts \
    i18n/EmbeddedUI_zh_Hant.ts \
    i18n/EmbeddedUI_zh_HK.ts \
    i18n/EmbeddedUI_zh_MO.ts \
    i18n/EmbeddedUI_zh_TW.ts \
    i18n/EmbeddedUI_zu_ZA.ts \

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
