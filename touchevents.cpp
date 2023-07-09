#include "touchevents.h"
#include <QQmlEngine>
#include <QJSEngine>
#include <QEvent>

MouseEventSpy::MouseEventSpy(QObject *parent) : QObject(parent)
{
    //qDebug() << "created Instance";
}

// This implements the SINGLETON PATTERN (*usually evil*)
// so you can get the instance in C++
MouseEventSpy* MouseEventSpy::instance()
{
    static MouseEventSpy* inst;
    if (inst == nullptr)
    {
        // If no instance has been created yet, creat a new and install it as event filter.
        // Uppon first use of the instance, it will automatically
        // install itself in the QGuiApplication
        inst = new MouseEventSpy();
        QGuiApplication* app = qGuiApp;
        app->installEventFilter(inst);
    }
    return inst;
}

// This is the method is necessary for 'installEventFilter'
bool MouseEventSpy::eventFilter(QObject* watched, QEvent* event)
{
    QEvent::Type t = event->type();
    if (t == QEvent::TouchEnd && event->spontaneous()) // Take only mouse events from outside of Qt
        emit mouseEventDetected();
    return QObject::eventFilter(watched, event);
}
