#ifndef POWERSTATUS_H
#define POWERSTATUS_H

#include <QFile>
#include <QTimer>
#include <QDebug>
#include <QProcess>

class PowerStatus: public QObject
{
    Q_OBJECT
public:
    explicit PowerStatus(QObject *parent = 0);

public slots:
    void init();
    void scan();

    void reboot();

private:
    QTimer *timer;

    int battery_max;
    bool ac;
    int battery_percent;

    QString ac_path;
    QString batt_path;
    QString batt_max_path;

signals:
    void acChanged(bool pluggedIn);
    void batteryChanged(int percent);

};

#endif // POWERSTATUS_H
