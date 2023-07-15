#include "touchevents.h"

TouchEvents::TouchEvents(QObject *parent) : QObject(parent) {}

TouchEvents* TouchEvents::instance() {
    static TouchEvents* inst;
    if (inst == nullptr) {
        inst = new TouchEvents();
        QGuiApplication* app = qGuiApp;
        app->installEventFilter(inst);
    }
    return inst;
}

bool TouchEvents::eventFilter(QObject* watched, QEvent* event) {
    QEvent::Type t = event->type();

    if (t == QEvent::TouchEnd && event->spontaneous())
        emit touchDetected();

    return QObject::eventFilter(watched, event);
}
