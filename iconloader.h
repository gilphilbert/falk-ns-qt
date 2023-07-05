#ifndef ICONLOADER_H
#define ICONLOADER_H

//#include <QPixmap>
#include <QImage>
#include <QQuickImageProvider>
//#include <QImageReader>
#include <QSvgRenderer>
#include <QDomDocument>
#include <QDomNodeList>

#include <QPainter>


#include "downloader.h"

class IconLoader : public QQuickImageProvider {
public:
    IconLoader(): QQuickImageProvider(QQuickImageProvider::Pixmap) {}
    //virtual QImage requestImage ( const QString &id, QSize *size, const QSize &requestedSize );
    QPixmap requestPixmap ( const QString &id, QSize *size, const QSize &requestedSize );

};

#endif // ICONLOADER_H
