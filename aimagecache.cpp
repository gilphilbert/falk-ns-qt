#include "aimagecache.h"

AsyncImageResponse::AsyncImageResponse(const QString &id, QSize const& requestedSize) {

    QSettings settings(QSettings::UserScope);
    QString host = QString(settings.value("host").toByteArray().constData());

    filename = id.right(id.length() - 1);
    QImageReader reader(filename);
    QImage _img(200, 200, QImage::Format_ARGB32);
    if (reader.read(&_img)) {
        m_resultImage = _img;
        fromLocal = true;
        emit finished();
        return;
    }

    QUrl url = "http://" + host + id + "?size=200";
    QNetworkRequest request(url);
    m_reply = m_imageLoader.get(request);
    m_requestedSize = requestedSize;

    connect(m_reply, &QNetworkReply::finished, this, &AsyncImageResponse::onResponseFinished);
}

void AsyncImageResponse::onResponseFinished() {
    QByteArray myImageData = m_reply->readAll();

    m_resultImage = QImage::fromData(myImageData);

    if (m_requestedSize.isValid()) {
        m_resultImage = m_resultImage.scaled(m_requestedSize);
    }

    output.setFileName(filename);
    if (output.open(QIODevice::WriteOnly)) {
        output.write(myImageData);
        output.close();
    }

    emit finished();
}

QQuickTextureFactory *AsyncImageResponse::textureFactory() const {
    return QQuickTextureFactory::textureFactoryForImage(m_resultImage);
}

QQuickImageResponse* AsyncImageCache::requestImageResponse(const QString &id, const QSize &requestedSize) {

    return new AsyncImageResponse(id, requestedSize);
}
