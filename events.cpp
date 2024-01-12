#include "events.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>

Events *Events::m_instance = nullptr;

Events::Events(QObject *parent): QObject(parent) {
    this->setQNAM(new QNetworkAccessManager(this));

    connect(
        this->QNAM(),
        SIGNAL(finished(QNetworkReply *)),
        this,
        SLOT(streamFinished(QNetworkReply *))
        );

    m_retries = 0;
}


Events *Events::getInstance() {
    if (m_instance == nullptr) {
        m_instance = new Events();
    }
    return m_instance;
}


void Events::setServer(const QUrl &url) {
    QNetworkRequest request = this->prepareRequest(url);
    m_reply = this->QNAM()->get(request);
    connect(m_reply, SIGNAL(readyRead()), this, SLOT(streamReceived()));
}

void Events::streamFinished(QNetworkReply *reply) {
    if(m_retries < MAX_RETRIES) {
        m_retries++;
        this->setServer(reply->url());
    }
    else {
        //qCritical() << "Unable to reconnect, max retries reached";
        emit disconnected();
    }
}


void Events::streamReceived() {
    QString event = QString(m_reply->readAll()).simplified().replace("data: ", "");
    m_retries = 0;

    QStringList eventList;
    eventList = event.split("event: ");
    for (int i = 0; i < eventList.size(); i++) {
        QString _evt = eventList.at(i);

        int _spacePos = _evt.indexOf(" ");
        QString _evtName = _evt.left(_spacePos).trimmed();

        if (_evtName.length() > 0) {
            QString discard = _evt.remove(0, _spacePos).trimmed();

            if (_evtName == "status") {
                QByteArray json_bytes = _evt.toLocal8Bit();
                auto json_doc = QJsonDocument::fromJson(json_bytes);
                QJsonObject object = json_doc.object();

                bool _paused = object.value("paused").toBool();
                emit paused(_paused);

                int _position = object.value("position").toInt();
                emit position(_position);

                int _elapsed = object.value("elapsed").toInt();
                emit elapsed(_elapsed);

                //int _repeat = object.value("repeat").toInt();
                //emit repeat(_repeat);

                int _random = object.value("random").toInt();
                emit random(_random);

                int _volume = object.value("volume").toInt();
                emit volume(_volume);

            }  else if (_evtName == "queue") {
                QByteArray json_bytes = _evt.toLocal8Bit();
                auto json_doc = QJsonDocument::fromJson(json_bytes);
                QJsonObject object = json_doc.object();

                QJsonArray _queue = object["queue"].toArray();
                emit queue(_queue);
            }
        }
    }

}


QNetworkRequest Events::prepareRequest(const QUrl &url) {
    QNetworkRequest request(url);
    request.setRawHeader(QByteArray("Accept"), QByteArray(ACCEPT_HEADER));
    request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, true);
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::AlwaysNetwork); // Events shouldn't be cached
    return request;
}


QNetworkAccessManager *Events::QNAM() const {
    return m_QNAM;
}


void Events::setQNAM(QNetworkAccessManager *value) {
    m_QNAM = value;
}
