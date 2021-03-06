#ifndef AIMAGECACHE_H
#define AIMAGECACHE_H

#include <QPixmap>
#include <QImage>
#include <QQuickImageProvider>
#include <QImageReader>
#include <QtCore>

#include <QNetworkRequest>
#include <QNetworkReply>

class AsyncImageResponse : public QQuickImageResponse {
    Q_OBJECT
public:
    explicit AsyncImageResponse(const QUrl &id, QSize const& requestedSize);
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
    bool fromLocal = false;
};

class AsyncImageCache : public QQuickAsyncImageProvider {
    public:
    QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requestedSize) override;
};

#endif // AIMAGECACHE_H
