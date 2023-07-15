/*

[Unit]
Description=Set backlight writable to everybody
#Before=nodered.service

[Service]
Type=oneshot
User=root
ExecStart=/bin/bash -c "/bin/chmod a+w /sys/class/drm/card1/card1-eDP-1/intel_backlight/brightness"

[Install]
WantedBy=multi-user.target

*/

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QGuiApplication>

#ifndef DPMSCONTROL_H
#define DPMSCONTROL_H

class DisplayController : public QObject {
    Q_OBJECT
public:
    explicit DisplayController(QObject *parent = 0);
    static DisplayController* instance();

public slots:
    static void off();
    static void on();

private:
    static DisplayController *m_instance;
    static QString m_brightness_path;
    static bool m_state;
    static bool m_act;
    static QString m_off_val;
    static QString m_on_val;
};

#endif // DPMSCONTROL_H
