#ifndef FILEDOWNLOADER_H
#define FILEDOWNLOADER_H

#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QtCore>

class FileDownloader : public QObject
{
 Q_OBJECT
 public:
  explicit FileDownloader(QUrl imageUrl, QObject *parent = 0);
  virtual ~FileDownloader();
  QByteArray downloadedData() const;

 signals:
  void downloaded();

 private slots:
  void fileDownloaded(QNetworkReply* pReply);
  //void downloadReadyRead();

  private:
  QNetworkAccessManager m_WebCtrl;
  QByteArray m_DownloadedData;
  QNetworkReply *currentDownload = nullptr;
  QFile output;
  QString filename;

};

#endif // FILEDOWNLOADER_H
