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

#ifndef EVENTS_H
#define EVENTS_H

#include <QtCore/QList>
#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QUrl>
#include <QtCore/QUrlQuery>
#include <QtCore/QStandardPaths>
#include <QtCore/QDir>
#include <QtNetwork/QAbstractNetworkCache>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkConfigurationManager>
#include <QtNetwork/QNetworkDiskCache>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#define ACCEPT_HEADER "text/event-stream"
#define USER_AGENT "FALK Display"
#define MAX_RETRIES 3

namespace Network {
    class Manager : public QObject {
        Q_OBJECT
    public:
        static Manager *getInstance();

    signals:
        void eventData(QString message);
        void disconnected();
        void paused(bool state);
        void position(int position);

    public slots:
        void setServer(const QUrl &url);

    private slots:
        void streamFinished(QNetworkReply *reply);
        void streamReceived();

    private:
        qint16 m_retries;
        QNetworkReply *m_reply;
        QNetworkAccessManager *m_QNAM;
        static Manager *m_instance;
        explicit Manager(QObject *parent = nullptr);
        QNetworkRequest prepareRequest(const QUrl &url);
        QNetworkAccessManager *QNAM() const;
        void setQNAM(QNetworkAccessManager *value);
        static Manager *manager();
        static void setManager(const Manager *manager);

        bool _paused;
        int _position;
    };
}

#endif // EVENTS_H