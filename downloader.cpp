#include "downloader.h"

FileDownloader::FileDownloader(QUrl imageUrl, QObject *parent) : QObject(parent) {
    connect(&m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (fileDownloaded(QNetworkReply*)));

    fprintf(stderr, "URL:: %s", imageUrl.toEncoded().constData());

    filename = imageUrl.fileName();
    fprintf(stderr, "Filename:: %s", filename.toStdString().c_str());

    QNetworkRequest request(imageUrl);
    currentDownload = m_WebCtrl.get(request);

    //output.setFileName(filename);
    //if (!output.open(QIODevice::WriteOnly)) {
    //    return;
    //}
    //connect(currentDownload, &QNetworkReply::readyRead, this, &FileDownloader::downloadReadyRead);
}

FileDownloader::~FileDownloader() { }

void FileDownloader::fileDownloaded(QNetworkReply* pReply) {
    // define the filename from the given URL

    output.setFileName("art/" + filename);
    if (!output.open(QIODevice::WriteOnly)) {
        return;
    }
    output.write(pReply->readAll());
    output.close();

    m_DownloadedData = pReply->readAll();
    pReply->deleteLater();
    //emit a signal
    emit downloaded();
}

QByteArray FileDownloader::downloadedData() const {
    return m_DownloadedData;
}

/*
void FileDownloader::downloadReadyRead() {
    output.write(currentDownload->readAll());
}
*/
