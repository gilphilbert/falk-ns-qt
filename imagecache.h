#ifndef IMAGECACHE_H
#define IMAGECACHE_H

#include <QPixmap>
#include <QImage>
#include <QQuickImageProvider>
#include <QImageReader>
#include <QtCore>

#include <QNetworkRequest>
#include <QNetworkReply>

#include <QSettings>

class AsyncImageResponse : public QQuickImageResponse {
    Q_OBJECT
public:
    explicit AsyncImageResponse(const QString &id, QSize const& requestedSize);
    QQuickTextureFactory *textureFactory() const override;

public slots:
    void onResponseFinished();

protected:
    QNetworkAccessManager m_imageLoader;
    QNetworkReply* m_reply;
    QSize m_requestedSize;
    QImage m_resultImage;
    QFile output;
    QString filename;
    bool cacheImage = true;
};

class AsyncImageCache : public QQuickAsyncImageProvider {
    public:
    QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requestedSize) override;
};

#endif // IMAGECACHE_H
