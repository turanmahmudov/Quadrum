#ifndef UPLOADER_H
#define UPLOADER_H

#include <QObject>

class QNetworkAccessManager;

class Uploader : public QObject
{
    Q_OBJECT
public:
    explicit Uploader(QObject *parent = 0);

    Q_PROPERTY(QString fileName READ fileName WRITE uploadImage NOTIFY fileNameChanged)
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString link READ link NOTIFY finished)

    QString fileName() const;
    bool busy() const;
    QString error() const;
    QString link() const;

public slots:
    void uploadImage(const QString &fileName, const QString &token, const QString &checkinId);


signals:
    void fileNameChanged();
    void busyChanged();
    void errorChanged();

    void finished();

private slots:
    void uploadFinished();

private:
    QNetworkAccessManager *m_manager;

    QString m_fileName;
    bool m_busy;
    QString m_error;
    QString m_link;
};

#endif // UPLOADER_H
