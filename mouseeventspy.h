#ifndef MOUSEEVENTSPY_H
#define MOUSEEVENTSPY_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QJSEngine>
#include <QGuiApplication>


class MouseEventSpy : public QObject
{
    Q_OBJECT
public:
    explicit MouseEventSpy(QObject *parent = 0);

    static MouseEventSpy* instance();

protected:
    bool eventFilter(QObject* watched, QEvent* event);

signals:
    void mouseEventDetected(/*Pass meaningfull information to QML?*/);

};

#endif // MOUSEEVENTSPY_H
