#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtPlugin>

#include "events.h"
#include "aimagecache.h"
#include "mouseeventspy.h"

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setOrganizationName("FALK");
    app.setOrganizationDomain("falk.com");
    app.setApplicationName("FALK NS Console");

    QQmlApplicationEngine engine;

    Network::Manager *manager = Network::Manager::getInstance();
    engine.rootContext()->setContextProperty("sse", manager);

    engine.addImageProvider("AsyncImage", new AsyncImageCache());

    MouseEventSpy *mouseSpy = MouseEventSpy::instance();
    engine.rootContext()->setContextProperty("mouseSpy", mouseSpy);

    if (! QDir("art").exists() ) {
        QDir().mkdir("art");
    }

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    app.exec();
    return 0;
}
