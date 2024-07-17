#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <Qt>

#include "NodoEmbeddedUIConfigParser.h"
#include "NodoConfigParser.h"
#include "NodoFeedParser.h"
#include "NodoSystemControl.h"
#include "NodoSystemStatusParser.h"
#include "NodoTranslator.h"
#include "NodoPriceTicker.h"
#include "MoneroLWS.h"
#include "NodoNetworkManager.h"
#include "NodoSyncInfo.h"

int main(int argc, char *argv[]) {
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    NodoNetworkManager *networkManager = new NodoNetworkManager();
    NodoEmbeddedUIConfigParser *embeddedConfigParser = new NodoEmbeddedUIConfigParser();
    NodoConfigParser *configParser = new NodoConfigParser();
    MoneroLWS *moneroLWS = new MoneroLWS(configParser);
    NodoSystemStatusParser *systemStatusParser = new NodoSystemStatusParser(configParser);
    NodoSystemControl *systemControl = new NodoSystemControl(embeddedConfigParser, configParser);
    NodoFeedParser *feedParser = new NodoFeedParser(embeddedConfigParser);
    NodoSyncInfo *syncInfo = new NodoSyncInfo();

    Translator *translator = new Translator(configParser, &engine);
    NodoPriceTicker *priceTicker = new NodoPriceTicker(configParser, networkManager);


    engine.rootContext()->setContextProperty("moneroLWS", moneroLWS);
    engine.rootContext()->setContextProperty("priceTicker", priceTicker);
    engine.rootContext()->setContextProperty("translator", translator);
    engine.rootContext()->setContextProperty("nodoConfig", configParser);
    engine.rootContext()->setContextProperty("nodoControl", systemControl);
    engine.rootContext()->setContextProperty("feedParser", feedParser);
    engine.rootContext()->setContextProperty("nodoSystemStatus", systemStatusParser);
    engine.rootContext()->setContextProperty("networkManager", networkManager);
    engine.rootContext()->setContextProperty("syncInfo", syncInfo);

    engine.addImportPath( ":/" );
    engine.addImportPath( "qrc:/modules" );
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}









