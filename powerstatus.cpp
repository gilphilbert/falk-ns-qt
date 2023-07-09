#include "powerstatus.h"

#include <QDebug>


QTimer *timer;
int battery_now = 0;
int battery_max = 0;
bool ac = 0;

PowerStatus::PowerStatus(QObject *parent) : QObject(parent) {}

void PowerStatus::init() {
    // AC Surface Go:       /sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online
    // Battery Surface Go:  /sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1

    // AC Elitebook: /sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/AC/online
    // Battery Elitebook: /sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT0/charge_full

    QStringList ac_paths = {
        "/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/AC/online", //laptop
        "/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online", //surface
    };

    QStringList batt_paths = {
        "/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT0/", //laptop
        "/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/", //surface
    };


    if (!QFile::exists("/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online")) {
        qInfo() << "AC status file missing";
    } else {
        QFile _file("/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online");
        if (_file.open(QIODevice::ReadOnly)) {
            ac = _file.readAll().toInt();
            qInfo() << "[INFO] AC connection: " << ac;
        } else {
            qWarning() << "[WARN] Could not open file to monitor AC ";
        }
    }

    if (!QFile::exists("/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_full")) {
        qInfo() << "Charge full file missing";
    } else {
        QFile _file("/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_full");
        if (_file.open(QIODevice::ReadOnly)) {
            battery_max = _file.readAll().toInt();
            qInfo() << "[INFO] Battery max: " << battery_max;
        } else {
            qWarning() << "[WARN] Could not open file to observe battery max ";
        }
    }

    if (!QFile::exists("/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_now")) {
        qInfo() << "Charge now file missing";
    } else {
        QFile _file("/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_now");
        if (_file.open(QIODevice::ReadOnly)) {
            battery_now = _file.readAll().toInt();
            qInfo() << "[INFO] Battery now: " << battery_now;
        } else {
            qWarning() << "[WARN] Could not open file to monitor battery ";
        }
    }

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(scan()));
    timer->start(5000);

    emit acChanged(ac);
    emit batteryChanged(battery_now / battery_max * 100);
}

void PowerStatus::scan() {
    int _ac = 0;
    int _battery_now = 0;

    QFile _file_ac("/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online");
    if (_file_ac.open(QIODevice::ReadOnly)) {
        _ac = _file_ac.readAll().toInt();
    }
    _file_ac.close();

    QFile _file_cn("/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_now");
    if (_file_cn.open(QIODevice::ReadOnly)) {
        _battery_now = _file_cn.readAll().toInt();
    }
    _file_cn.close();


    //qInfo() << "[INFO] AC connection: " << _ac;

    if (_ac != ac) {
        ac = _ac;
        emit acChanged(ac);
    }

    if (_battery_now != battery_now) {
        battery_now = _battery_now;
        double battery_percent = (double(battery_now) / double(battery_max)) * 100.0;

        emit batteryChanged(battery_percent);
    }
}
