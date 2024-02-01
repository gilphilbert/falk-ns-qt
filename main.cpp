#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtPlugin>

#include "events.h"
#include "imagecache.h"
#include "touchevents.h"
#include "displaycontroller.h"
#include "powerstatus.h"


int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setOrganizationName("FALK");
    app.setOrganizationDomain("falk.com");
    app.setApplicationName("FALK NS Console");

    QQmlApplicationEngine engine;

    int rotate = 0;
    if (!qgetenv("FALK_CS_ROTATE").isEmpty()) {
        rotate = qgetenv("FALK_CS_ROTATE").toInt();
    }
    engine.rootContext()->setContextProperty("rotate", rotate);

    Events *events= Events::getInstance();
    engine.rootContext()->setContextProperty("sse", events);

    DisplayController *display = DisplayController::instance();
    engine.rootContext()->setContextProperty("display", display);

    PowerStatus *power_status = new PowerStatus();
    engine.rootContext()->setContextProperty("power", power_status);

    engine.addImageProvider("AsyncImage", new AsyncImageCache());

    TouchEvents *touchEvents = TouchEvents::instance();
    engine.rootContext()->setContextProperty("touchEvents", touchEvents);

    if (! QDir("art").exists() ) {
        QDir().mkdir("art");
    }

    const QUrl url(QStringLiteral("qrc:/Player.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    app.exec();
    return 0;
}
