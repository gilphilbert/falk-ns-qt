#ifndef POWERMANAGER_H
#define POWERMANAGER_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QJSEngine>
#include <QFileSystemWatcher>


class PowerManager : public QObject
{
    Q_OBJECT
public:
    explicit PowerManager(QObject *parent = 0);

private:
    QFileSystemWatcher * watcher;

    //static bool ac;
    //static int battery;

private slots:
    void fileChanged(const QString & path);

signals:
    void acChanged(bool pluggedIn);
    void batteryChanged(float percent);

};

#endif // POWERMANAGER_H
