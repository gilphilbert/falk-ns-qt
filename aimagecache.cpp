#include "aimagecache.h"

AsyncImageResponse::AsyncImageResponse(const QUrl &id, QSize const& requestedSize) {
    QUrl url = QUrl(id);

    QImageReader reader("art/" + url.fileName());
    QImage _img(200, 200, QImage::Format_ARGB32);
    if (reader.read(&_img)) {
        m_resultImage = _img;
        fromLocal = true;
        emit finished();
        return;
    }

    QNetworkRequest request(id);
    m_reply = m_imageLoader.get(request);
    m_requestedSize = requestedSize;

    filename = id.fileName();

    connect(m_reply, &QNetworkReply::finished, this, &AsyncImageResponse::onResponseFinished);
}

void AsyncImageResponse::onResponseFinished() {
    QByteArray myImageData = m_reply->readAll();

    m_resultImage = QImage::fromData(myImageData);

    if (m_requestedSize.isValid()) {
        m_resultImage = m_resultImage.scaled(m_requestedSize);
    }

    output.setFileName("art/" + filename);
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
