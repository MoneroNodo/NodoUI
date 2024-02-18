#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <Qt>

#include "NodoConfigParser.h"
#include "NodoFeedParser.h"
#include "NodoSystemControl.h"

int main(int argc, char *argv[]) {
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

	QApplication app(argc, argv);
	QQmlApplicationEngine engine;
	app.setOverrideCursor(Qt::BlankCursor);

	NodoConfigParser *configParser = new NodoConfigParser();
	NodoSystemControl *systemControl = new NodoSystemControl(configParser);
	NodoFeedParser *feedParser = new NodoFeedParser(configParser);


	engine.rootContext()->setContextProperty("nodoControl", systemControl);
	engine.rootContext()->setContextProperty("feedParser", feedParser);

	engine.addImportPath( ":/" );
	engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

	if (engine.rootObjects().isEmpty())
		return -1;
	return app.exec();
}









