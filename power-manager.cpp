#include "power-manager.h"

//PowerManager *PowerManager::m_instance = nullptr;
//QFileSystemWatcher PowerManager::m_monitor = nullptr;
//bool PowerManager::ac = false;
//int PowerManager::battery = 0;

PowerManager::PowerManager(QObject *parent) : QObject(parent) {

    watcher = new QFileSystemWatcher(this);

    watcher->addPath("/sys/bus/acpi/drivers/ac/ACPI0003\:00/power_supply/AC");
    //QObject::connect(&watcher, SIGNAL(directoryChanged(QString)), this, SLOT(fileChanged(QString)));

    //m_monitor->addPath("/sys/bus/acpi/drivers/ac/ACPI0003:00/power_supply/ACAD/online");
    //m_monitor->addPath("/sys/bus/acpi/drivers/battery/PNP0C0A:00/power_supply/BAT1/charge_now");

    //watcher->addPath("/sys/bus/acpi/drivers/ac/ACPI0003\:00/power_supply/AC/online");
    connect(watcher, SIGNAL(fileChanged(const QString &)), this, SLOT(fileChanged(const QString &)));

}

// This implements the SINGLETON PATTERN (*usually evil*)
// so you can get the instance in C++
//PowerManager* PowerManager::instance() {
//    m_instance = new PowerManager();
//    return m_instance;
//}

void PowerManager::fileChanged(const QString & path) {
    qInfo() << path;
/*
    QFile monitorFile{path};
    if (!monitorFile.open(QIODevice::ReadOnly)) {
        qWarning() << "ERROR: Could not open file: " << path;
        return;
    }
    auto content = monitorFile.readAll();
    if (!content.isEmpty()) {
        qInfo() << "INFO: = " << content.at(0);
    }
*/
}
