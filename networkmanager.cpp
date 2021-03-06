/*
 *   This file is part of Qt-SSE-Demo.
 *
 *   Qt-SSE-Demo is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Qt-SSE-Demo is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Qt-SSE-Demo.  If not, see <http://www.gnu.org/licenses/>.
 */
#include "networkmanager.h"

Network::Manager *Network::Manager::m_instance = nullptr;

Network::Manager::Manager(QObject *parent): QObject(parent) {
    this->setQNAM(new QNetworkAccessManager(this));

    connect(
        this->QNAM(),
        SIGNAL(finished(QNetworkReply *)),
        this,
        SLOT(streamFinished(QNetworkReply *))
    );

    m_retries = 0;
}


Network::Manager *Network::Manager::getInstance() {
    if (m_instance == nullptr) {
        m_instance = new Manager();
    }
    return m_instance;
}


void Network::Manager::setServer(const QUrl &url) {
    QNetworkRequest request = this->prepareRequest(url);
    m_reply = this->QNAM()->get(request);
    connect(m_reply, SIGNAL(readyRead()), this, SLOT(streamReceived()));
}


void Network::Manager::streamFinished(QNetworkReply *reply) {
    if(m_retries < MAX_RETRIES) {
        m_retries++;
        this->setServer(reply->url());
    }
    else {
        //qCritical() << "Unable to reconnect, max retries reached";
        emit disconnected();
    }
}


void Network::Manager::streamReceived() {
    QString event = QString(m_reply->readAll()).simplified().replace("data: ", "");
    m_retries = 0;
    emit eventData(event);
}


QNetworkRequest Network::Manager::prepareRequest(const QUrl &url) {
    QNetworkRequest request(url);
    request.setRawHeader(QByteArray("Accept"), QByteArray(ACCEPT_HEADER));
    request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, true);
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::AlwaysNetwork); // Events shouldn't be cached
    return request;
}


QNetworkAccessManager *Network::Manager::QNAM() const {
    return m_QNAM;
}


void Network::Manager::setQNAM(QNetworkAccessManager *value) {
    m_QNAM = value;
}
