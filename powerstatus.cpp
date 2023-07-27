#include "powerstatus.h"

QTimer *timer;
int battery_max = 0;
bool ac = 0;
double battery_percent = 0;

QString ac_path = "";
QString batt_path = "";
QString batt_max_path = "";

PowerStatus::PowerStatus(QObject *parent) : QObject(parent) {}

void PowerStatus::init() {

    QStringList ac_paths = {
        "/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/AC/online", //laptop
        "/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online", //surface
        "/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/AC0/online" //zenbook
    };

    QStringList batt_full_paths = {
        "/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT0/charge_full", //laptop
        "/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_full", //surface
        "/sys/bus/acpi/drivers/battery/PNP0C0A:03/power_supply/BAT0/energy_full" //zenbook
    };

    QStringList batt_now_paths = {
        "/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT0/charge_now", //laptop
        "/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_now", //surface
        "/sys/bus/acpi/drivers/battery/PNP0C0A:03/power_supply/BAT0/energy_now" //zenbook
    };

    for ( const auto& i : ac_paths ) {
        if (QFile::exists(i)) {
            ac_path = i;
        }
    }

    for ( const auto& i : batt_full_paths ) {
        if (QFile::exists(i)) {
            batt_max_path = i;
        }
    }

    for ( const auto& i : batt_now_paths ) {
        if (QFile::exists(i)) {
            batt_path = i;
        }
    }

    if (batt_path != "") {
        timer = new QTimer(this);
        connect(timer, SIGNAL(timeout()), this, SLOT(scan()));
        timer->start(5000);
    }
}

void PowerStatus::scan() {
    int _ac = 0;
    int _battery_now = 0;

    QFile _file_ac(ac_path);
    if (_file_ac.open(QIODevice::ReadOnly)) {
        _ac = _file_ac.readAll().toInt();
    }
    _file_ac.close();

    QFile _file_max(batt_max_path);
    if (_file_max.open(QIODevice::ReadOnly)) {
        battery_max = _file_max.readAll().toInt();
    }
    _file_max.close();

    QFile _file_cn(batt_path);
    if (_file_cn.open(QIODevice::ReadOnly)) {
        _battery_now = _file_cn.readAll().toInt();
    }
    _file_cn.close();

    if (_ac != ac) {
        ac = _ac;
        emit acChanged(ac);
    }

    if (_battery_now > 0 && battery_max > 0) {
        double _battery_percent = (static_cast<double>(_battery_now) / static_cast<double>(battery_max)) * 100.0;

        if (_battery_percent != battery_percent) {
            battery_percent = _battery_percent;
            emit batteryChanged(battery_percent);
        }
    }
}

void PowerStatus::reboot() {
    QProcess *process = new QProcess();
    process->start("systemctl", QStringList() << "reboot");
}
