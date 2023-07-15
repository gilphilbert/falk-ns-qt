#include "imagecache.h"

AsyncImageResponse::AsyncImageResponse(const QString &id, QSize const& requestedSize) {

    QSettings settings(QSettings::UserScope);
    QString host = QString(settings.value("host").toByteArray().constData());

    // find out if the image is large or blurred
    bool blur = id.startsWith("blur");
    bool large = id.startsWith("lrge");

    cacheImage = true;
    filename = id;

    if (blur || large) {
        // if we're sourcing a large image, we won't cache it
        filename.remove(0, 5);
        cacheImage = false;
    }

    if (filename == "") {
        QImage _img(200, 200, QImage::Format_ARGB32);
        _img.fill("#ffffff");
        m_resultImage = _img;
        emit finished();
        return;
    }

    if (!blur && !large){
        // otherwise, let's see if we have it in cache
        filename = id;
        QImageReader reader(filename);
        QImage _img(200, 200, QImage::Format_ARGB32);
        if (reader.read(&_img)) {
            m_resultImage = _img;
            emit finished();
            return;
        }
        // it's not in cache, let's make sure we cache it this time
    }

    // construct the url
    QUrl url = "http://" + host + "/" + filename + ((blur || large) ? "?size=600" : "?size=200") + ((blur) ? "&blur=true" : "");
    //create request
    QNetworkRequest request(url);
    //issue request
    m_reply = m_imageLoader.get(request);
    m_requestedSize = requestedSize;

    //connect callback
    connect(m_reply, &QNetworkReply::finished, this, &AsyncImageResponse::onResponseFinished);
}

void AsyncImageResponse::onResponseFinished() {
    //get the data
    QByteArray myImageData = m_reply->readAll();

    //create a QImage
    m_resultImage = QImage::fromData(myImageData);

    //if it's a valid image, scale
    if (m_requestedSize.isValid()) {
        m_resultImage = m_resultImage.scaled(m_requestedSize);
    }

    //cache the returned image
    if (cacheImage) {
        output.setFileName(filename);
        if (output.open(QIODevice::WriteOnly)) {
            output.write(myImageData);
            output.close();
        }
    }

    //emit that the job is done
    emit finished();
}

QQuickTextureFactory *AsyncImageResponse::textureFactory() const {
    //return the image
    return QQuickTextureFactory::textureFactoryForImage(m_resultImage);
}

QQuickImageResponse* AsyncImageCache::requestImageResponse(const QString &id, const QSize &requestedSize) {
    return new AsyncImageResponse(id, requestedSize);
}
