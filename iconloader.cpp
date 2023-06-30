#include "iconloader.h"

QImage IconLoader::requestImage ( const QString &id, QSize *size, const QSize &requestedSize ) {
    QImage _img(200, 200, QImage::Format_ARGB32);
    _img.fill(Qt::transparent);

    QStringList id_parts = id.split( "/" );
    QString filename = id_parts.value( 0 );
    QString color = id_parts.length() > 1 ? id_parts.value(1) : QString("#ffffff");

    QFile file(":icons/" + filename + ".svg");
    if(!file.open(QFile::ReadOnly | QFile::Text)){
        qDebug() << "Cannot read file" << file.errorString();
        return _img;
    }

    QDomDocument document;
    if (!document.setContent(&file)) {
        qDebug() << "failed to parse file";
        file.close();
        return _img;
    }
    file.close();

    QDomNodeList roots = document.elementsByTagName("svg");
    if (roots.size() < 1) {
       qDebug() << "Cannot find root";
       return _img;
    }
    QDomElement root = roots.at(0).toElement();
    root.setAttribute("stroke", color);

    QSvgRenderer svg(document.toByteArray());

    QPainter painter(&_img);

    svg.render(&painter);

    return _img;
}
