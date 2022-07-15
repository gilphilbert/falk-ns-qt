#ifndef IMAGECACHE_H
#define IMAGECACHE_H

#include <QPixmap>
#include <QImage>
#include <QQuickImageProvider>
#include <QImageReader>

#include "downloader.h"

class CachedImageProvider : public QQuickImageProvider {
public:
    CachedImageProvider(): QQuickImageProvider(QQuickImageProvider::Image) {};
    virtual QImage requestImage ( const QString &id, QSize *size, const QSize &requestedSize );
};

#endif // IMAGECACHE_H
