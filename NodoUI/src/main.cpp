#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <Qt>
#include <QFontDatabase>
#include "NodoUISystemParser.h"
#include "NodoConfigParser.h"
#include "NodoFeedsControl.h"
#include "NodoSystemControl.h"
#include "NodoSystemStatusParser.h"
#include "NodoTranslator.h"
#include "NodoPriceTicker.h"
#include "MoneroLWS.h"
#include "NodoNetworkManager.h"
#include "NodoSyncInfo.h"
#include "MoneroPay.h"
#include "NodoDBusController.h"
#include "qglobal.h"
#include "qlist.h"
#include "qobject.h"
#include "src/NodoLogView.h"


static QString loadFont(const QString &fontPath) {
    const int font = QFontDatabase::addApplicationFont(fontPath);
    if (font < 0) {
        qDebug() << "Couldn't load font " << fontPath;
        return QString();
    }
    return QFontDatabase::applicationFontFamilies(font).value(0);
}

int main(int argc, char *argv[]) {
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "--disable-logging");

    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qputenv("QML2_IMPORT_PATH", "qrc:/style/assets/NodoKeyboard");
    engine.addImportPath( ":/" );
    engine.addImportPath("qrc:/style/assets/NodoKeyboard");
    qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH", QByteArray("qrc:layout/assets/NodoKeyboard/QtQuick/VirtualKeyboard/layouts"));

    const QString base = loadFont(":/NodoSystem/InterDisplay.ttf");
    const QString noto = loadFont(":/NodoSystem/NotoSans-Regular.ttf");
    const QString hebr = loadFont(":/NodoSystem/NotoRashiHebrew-Regular.ttf");
    const QString arab = loadFont(":/NodoSystem/NotoNaskhArabic-Regular.ttf");
    const QString cjk = loadFont(":/NodoSystem/NotoSansCJK-Regular.ttc");

    QApplication::setFont(QFont({base, noto, arab, hebr, cjk}));
    NodoUISystemParser *uiSystemParser = new NodoUISystemParser();
    NodoDBusController *dbusController = new NodoDBusController();
    NodoConfigParser *configParser = new NodoConfigParser();

    NodoNetworkManager *networkManager = new NodoNetworkManager(dbusController);
    MoneroLWS *moneroLWS = new MoneroLWS(dbusController);
    NodoSystemStatusParser *systemStatusParser = new NodoSystemStatusParser(configParser);
    NodoSystemControl *systemControl = new NodoSystemControl(uiSystemParser, configParser, dbusController);
    NodoSyncInfo *syncInfo = new NodoSyncInfo(systemStatusParser);
    Translator *translator = new Translator(configParser, &engine);
    MoneroPay *moneroPay = new MoneroPay(configParser);
    NodoPriceTicker *priceTicker = new NodoPriceTicker(configParser, networkManager, systemControl);
    NodoFeedsControl *feedsControl = new NodoFeedsControl(networkManager, systemControl);
    LogViewModel *logViewModel = new LogViewModel();
    logViewModel->setUnit("monerod.service");

    engine.rootContext()->setContextProperty("moneroLWS", moneroLWS);
    engine.rootContext()->setContextProperty("priceTicker", priceTicker);
    engine.rootContext()->setContextProperty("translator", translator);
    engine.rootContext()->setContextProperty("nodoConfig", configParser);
    engine.rootContext()->setContextProperty("nodoControl", systemControl);
    engine.rootContext()->setContextProperty("feedsControl", feedsControl);
    engine.rootContext()->setContextProperty("nodoSystemStatus", systemStatusParser);
    engine.rootContext()->setContextProperty("networkManager", networkManager);
    engine.rootContext()->setContextProperty("moneroPay", moneroPay);
    engine.rootContext()->setContextProperty("syncInfo", syncInfo);
    engine.rootContext()->setContextProperty("logViewModel", logViewModel);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
