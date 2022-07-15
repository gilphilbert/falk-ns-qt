#include "imagecache.h"

//void loadImage() {
 //QPixmap buttonImage;
 //buttonImage.loadFromData(m_pImgCtrl->downloadedData());
//}

QImage CachedImageProvider::requestImage ( const QString &id, QSize *size, const QSize &requestedSize ) {
    QImage _img(200, 200, QImage::Format_ARGB32);

    QUrl url = QUrl(id);

    QImageReader reader("art/" + url.fileName());
    if (reader.read(&_img)) {
        return _img;
    }

    FileDownloader * m_pImgCtrl = new FileDownloader(id + "?size=200");
    //connect(m_pImgCtrl, SIGNAL (downloaded()), this, SLOT (loadImage()));

    reader.setFileName(QString("art/placeholder.jpg"));
    reader.read(&_img);

    return _img;
}
