#ifndef POWERSTATUS_H
#define POWERSTATUS_H

#include <QFile>
#include <QTimer>

class PowerStatus: public QObject
{
    Q_OBJECT
public:
    explicit PowerStatus(QObject *parent = 0);

public slots:
    void init();
    void scan();

private:
    QTimer *timer;

    int battery_now;
    int battery_max;
    bool ac;

signals:
    void acChanged(bool pluggedIn);
    void batteryChanged(int percent);

};

#endif // POWERSTATUS_H
