QT += qml quick core widgets gui dbus
QT += virtualkeyboard
QT += network
TEMPLATE = app
CONFIG += c++17

QT_FOR_CONFIG += virtualkeyboard
#QT += svg
QTPLUGIN += qtvirtualkeyboardplugin


TARGET = NodoUI

DBUS_INTERFACES += nodo_dbus.xml

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/MoneroLWS.cpp \
        src/NetworkManagerCommon.cpp \
        src/NodoConfigParser.cpp \
        src/NodoFeedsControl.cpp \
        src/NodoNetworkManager.cpp \
        src/NodoSyncInfo.cpp \
        src/NodoSystemStatusParser.cpp \
        src/NodoUISystemParser.cpp \
        src/NodoWiredController.cpp \
        src/NodoWirelessController.cpp \
        src/main.cpp \
        src/NodoFeedParser.cpp \
        src/NodoSystemControl.cpp \
        src/pugixml.cpp \
        src/NodoTranslator.cpp \
        src/NodoDBusController.cpp \
        src/NodoPriceTicker.cpp \


HEADERS += \
        src/MoneroLWS.h \
        src/NetworkManagerCommon.h \
        src/NodoConfigParser.h \
        src/NodoFeedsControl.h \
        src/NodoNetworkManager.h \
        src/NodoNotificationMessages.h \
        src/NodoSyncInfo.h \
        src/NodoSystemStatusParser.h \
        src/NodoFeedParser.h \
        src/NodoSystemControl.h \
        src/NodoUISystemParser.h \
        src/NodoWiredController.h \
        src/NodoWirelessController.h \
        src/pugixml.hpp \
        src/pugiconfig.hpp \
        src/NodoTranslator.h \
        src/NodoDBusController.h \
        src/NodoPriceTicker.h \

RESOURCES += qml.qrc

# disable-xcb {
#      CONFIG += disable-desktop
# }
CONFIG += disable-desktop
CONFIG += disable-hunspell
CONFIG += disable-layouts


TRANSLATIONS += \
    i18n/NodoUI_af_ZA.ts \
    i18n/NodoUI_am_ET.ts \
    i18n/NodoUI_ar_EG.ts \
    i18n/NodoUI_as_IN.ts \
    i18n/NodoUI_az_AZ.ts \
    i18n/NodoUI_be_BY.ts \
    i18n/NodoUI_bg_BG.ts \
    i18n/NodoUI_bn_BD.ts \
    i18n/NodoUI_bo_CN.ts \
    i18n/NodoUI_br_FR.ts \
    i18n/NodoUI_bs_BA.ts \
    i18n/NodoUI_ca_ES.ts \
    i18n/NodoUI_cs_CZ.ts \
    i18n/NodoUI_cy_GB.ts \
    i18n/NodoUI_da_DK.ts \
    i18n/NodoUI_de_DE.ts \
    i18n/NodoUI_dsb_DE.ts \
    i18n/NodoUI_el_GR.ts \
    i18n/NodoUI_en_US.ts \
    i18n/NodoUI_es_ES.ts \
    i18n/NodoUI_et_EE.ts \
    i18n/NodoUI_eu_ES.ts \
    i18n/NodoUI_fa_IR.ts \
    i18n/NodoUI_fi_FI.ts \
    i18n/NodoUI_fil_PH.ts \
    i18n/NodoUI_fo_FO.ts \
    i18n/NodoUI_fr_FR.ts \
    i18n/NodoUI_fy_NL.ts \
    i18n/NodoUI_ga_IE.ts \
    i18n/NodoUI_gd_GB.ts \
    i18n/NodoUI_gl_ES.ts \
    i18n/NodoUI_gsw_CH.ts \
    i18n/NodoUI_gu_IN.ts \
    i18n/NodoUI_ha_NG.ts \
    i18n/NodoUI_he_IL.ts \
    i18n/NodoUI_hi_IN.ts \
    i18n/NodoUI_hr_HR.ts \
    i18n/NodoUI_hsb_DE.ts \
    i18n/NodoUI_hu_HU.ts \
    i18n/NodoUI_hy_AM.ts \
    i18n/NodoUI_id_ID.ts \
    i18n/NodoUI_ig_NG.ts \
    i18n/NodoUI_ii_CN.ts \
    i18n/NodoUI_is_IS.ts \
    i18n/NodoUI_it_IT.ts \
    i18n/NodoUI_ja_JP.ts \
    i18n/NodoUI_ka_GE.ts \
    i18n/NodoUI_kk_KZ.ts \
    i18n/NodoUI_kl_GL.ts \
    i18n/NodoUI_km_KH.ts \
    i18n/NodoUI_kn_IN.ts \
    i18n/NodoUI_ko_KR.ts \
    i18n/NodoUI_kok_IN.ts \
    i18n/NodoUI_ky_KG.ts \
    i18n/NodoUI_lb_LU.ts \
    i18n/NodoUI_lo_LA.ts \
    i18n/NodoUI_lt_LT.ts \
    i18n/NodoUI_lv_LV.ts \
    i18n/NodoUI_mi_NZ.ts \
    i18n/NodoUI_mk_MK.ts \
    i18n/NodoUI_ml_IN.ts \
    i18n/NodoUI_mn_MN.ts \
    i18n/NodoUI_mr_IN.ts \
    i18n/NodoUI_ms_MY.ts \
    i18n/NodoUI_mt_MT.ts \
    i18n/NodoUI_my_MM.ts \
    i18n/NodoUI_nb_NO.ts \
    i18n/NodoUI_ne_NP.ts \
    i18n/NodoUI_nl_NL.ts \
    i18n/NodoUI_nn_NO.ts \
    i18n/NodoUI_nb_NO.ts \
    i18n/NodoUI_or_IN.ts \
    i18n/NodoUI_pa_IN.ts \
    i18n/NodoUI_pl_PL.ts \
    i18n/NodoUI_ps_AF.ts \
    i18n/NodoUI_pt_BR.ts \
    i18n/NodoUI_qu_PE.ts \
    i18n/NodoUI_rm_CH.ts \
    i18n/NodoUI_ro_RO.ts \
    i18n/NodoUI_ru_RU.ts \
    i18n/NodoUI_rw_RW.ts \
    i18n/NodoUI_sah_RU.ts \
    i18n/NodoUI_se_NO.ts \
    i18n/NodoUI_si_LK.ts \
    i18n/NodoUI_sk_SK.ts \
    i18n/NodoUI_sl_SI.ts \
    i18n/NodoUI_smn_FI.ts \
    i18n/NodoUI_sq_AL.ts \
    i18n/NodoUI_sr_RS.ts \
    i18n/NodoUI_sv_SE.ts \
    i18n/NodoUI_sw_TZ.ts \
    i18n/NodoUI_ta_IN.ts \
    i18n/NodoUI_te_IN.ts \
    i18n/NodoUI_tg_TJ.ts \
    i18n/NodoUI_th_TH.ts \
    i18n/NodoUI_tk_TM.ts \
    i18n/NodoUI_tr_TR.ts \
    i18n/NodoUI_tt_RU.ts \
    i18n/NodoUI_tzm_MA.ts \
    i18n/NodoUI_ug_CN.ts \
    i18n/NodoUI_uk_UA.ts \
    i18n/NodoUI_ur_PK.ts \
    i18n/NodoUI_uz_UZ.ts \
    i18n/NodoUI_vi_VN.ts \
    i18n/NodoUI_wo_SN.ts \
    i18n/NodoUI_xh_ZA.ts \
    i18n/NodoUI_yo_NG.ts \
    i18n/NodoUI_zh_CN.ts \
    i18n/NodoUI_zh_Hant.ts \
    i18n/NodoUI_zh_HK.ts \
    i18n/NodoUI_zh_MO.ts \
    i18n/NodoUI_zh_TW.ts \
    i18n/NodoUI_zu_ZA.ts \

DISTFILES += \
    i18n/NodoUI_en.qm \
    i18n/NodoUI_en.rs \


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
