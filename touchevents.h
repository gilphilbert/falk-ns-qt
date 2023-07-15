#ifndef TOUCHEVENTS_H
#define TOUCHEVENTS_H

#include <QObject>
#include <QGuiApplication>

class TouchEvents : public QObject {
    Q_OBJECT
public:
    explicit TouchEvents(QObject *parent = 0);

    static TouchEvents* instance();

protected:
    bool eventFilter(QObject* watched, QEvent* event);

signals:
    void touchDetected();

};

#endif // TOUCHEVENTS_H
