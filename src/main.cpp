#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <Qt>

#include "NodoEmbeddedUIConfigParser.h"
#include "NodoConfigParser.h"
#include "NodoFeedParser.h"
#include "NodoSystemControl.h"
#include "NodoSystemStatusParser.h"

int main(int argc, char *argv[]) {
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

	QApplication app(argc, argv);
	QQmlApplicationEngine engine;
	app.setOverrideCursor(Qt::BlankCursor);

	NodoEmbeddedUIConfigParser *embeddedConfigParser = new NodoEmbeddedUIConfigParser();
	NodoConfigParser *configParser = new NodoConfigParser();
	NodoSystemControl *systemControl = new NodoSystemControl(embeddedConfigParser);
	NodoFeedParser *feedParser = new NodoFeedParser(embeddedConfigParser);
	NodoSystemStatusParser *systemStatusParser = new NodoSystemStatusParser();

	engine.rootContext()->setContextProperty("nodoConfig", configParser);
	engine.rootContext()->setContextProperty("nodoControl", systemControl);
	engine.rootContext()->setContextProperty("feedParser", feedParser);
	engine.rootContext()->setContextProperty("nodoSystemStatus", systemStatusParser);

	engine.addImportPath( ":/" );
	engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

	if (engine.rootObjects().isEmpty())
		return -1;
	return app.exec();
}









