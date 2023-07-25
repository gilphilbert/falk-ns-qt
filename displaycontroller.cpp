#include "displaycontroller.h"

DisplayController *DisplayController::m_instance = nullptr;
QString DisplayController::m_brightness_path = "";
bool DisplayController::m_state = false;
bool DisplayController::m_act = false;

QString DisplayController::m_off_val = "off";
QString DisplayController::m_on_val = "on";

DisplayController::DisplayController(QObject *parent) : QObject(parent) {
    QByteArray _ba_path = qgetenv("FALK_DISPLAY_SYSFS");
    QStringList components = QString(_ba_path.constData()).split(':');

    m_brightness_path = components.value(0);
    //qInfo() << m_brightness_path;

    if (components.length() == 3) {
        m_off_val = components.value(1);
        m_on_val = components.value(2);
    }

    if (m_brightness_path != "" && QFile::exists(m_brightness_path)) { //need to check that it's writeable, too
        m_act = true;
        on();
        //found a control file, turn the display on
    } else {
        qInfo() << "Display control file not provided or doesn't exist";
    }
}

DisplayController* DisplayController::instance() {
    m_instance = new DisplayController();
    return m_instance;
}

void DisplayController::on() {
    if (m_state) {
        //qInfo() << "Already on";
        return;
    }

    if (!m_act) {
        //qInfo() << "No control file, skipping";
        return;
    }

    //qInfo() << "turning on :: " << m_on_val;
    //QFile file("/sys/class/drm/card1/card1-eDP-1/intel_backlight/brightness");
    QFile file(m_brightness_path);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate | QIODevice::Unbuffered)) {
        //qInfo() << "Can't open file";
        return;
     }

    file.write(QString("1500").toUtf8());
    file.close();

    m_state = true;
}


void DisplayController::off() {
    if (!m_state) {
        //qInfo() << "Already off";
        return;
    }

    if (!m_act) {
        //qInfo() << "No control file, skipping";
        return;
    }

    //qInfo() << "turning off :: " << m_off_val;
    QFile file(m_brightness_path);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate | QIODevice::Unbuffered)) {
       qInfo() << "Can't open file";
       return;
    }

    file.write(QString("0").toUtf8());
    file.close();

    m_state = false;
}
