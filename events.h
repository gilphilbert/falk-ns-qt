#ifndef EVENTS_H
#define EVENTS_H

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QtCore/QList>
#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QUrl>
#include <QtCore/QUrlQuery>
#include <QtCore/QStandardPaths>
#include <QtCore/QDir>
#include <QtNetwork/QAbstractNetworkCache>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkDiskCache>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#define ACCEPT_HEADER "text/event-stream"
#define USER_AGENT "FALK Display"
#define MAX_RETRIES 3

class Events : public QObject {
    Q_OBJECT
public:
    static Events *getInstance();

public slots:
    void setServer(const QUrl &url);

signals:
    void eventData(QString message);
    void connected();
    void disconnected();
    void paused(bool state);
    void position(int position);
    void elapsed(int position);
    void random(bool random);
    void repeat(int mode);
    void volume(int volume);
    void queue(QJsonArray queue);
    void scanState(QJsonObject state);

private slots:
    void streamFinished(QNetworkReply *reply);
    void streamReceived();

private:
    qint16 m_retries;
    bool m_connected;
    QNetworkReply *m_reply;
    QNetworkAccessManager *m_QNAM;
    static Events *m_instance;
    explicit Events(QObject *parent = nullptr);
    QNetworkRequest prepareRequest(const QUrl &url);
    QNetworkAccessManager *QNAM() const;
    void setQNAM(QNetworkAccessManager *value);
};

#endif // EVENTS_H
