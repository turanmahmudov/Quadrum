#include "uploader.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QUrlQuery>
#include <QImage>
#include <QBuffer>
#include <QJsonDocument>

Uploader::Uploader(QObject *parent) :
    QObject(parent),
    m_busy(false)
{
    m_manager = new QNetworkAccessManager(this);
}

QString Uploader::fileName() const
{
    return m_fileName;
}

void Uploader::uploadImage(const QString &fileName)
{
    m_fileName = fileName;
    emit fileNameChanged();

    QImage image(fileName);
    QByteArray imageData;
    QBuffer buffer(&imageData);
    image.save(&buffer, "PNG");


//    QUrlQuery query;
//    query.addQueryItem("image", );

    QUrl url("https://api.imgur.com/3/image");
//    url.setQuery(query);

    QNetworkRequest request(url);
    request.setRawHeader(QByteArray("Authorization"), QString("Client-ID %1").arg(clientId).toLatin1());
    QNetworkReply *reply = m_manager->post(request, imageData.toBase64());

    connect(reply, &QNetworkReply::finished, this, &Uploader::uploadFinished);

    m_busy = true;
    emit busyChanged();
}

bool Uploader::busy() const
{
    return m_busy;
}

QString Uploader::error() const
{
    return m_error;
}

QString Uploader::link() const
{
    return m_link;
}

void Uploader::uploadFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    reply->deleteLater();

    QByteArray data = reply->readAll();

    QJsonParseError error;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(data, &error);

    m_busy = false;
    emit busyChanged();

    if (error.error != QJsonParseError::NoError) {
        m_error = "Network error uploading to imgur";
        emit errorChanged();
        emit finished();
        return;
    }


    /*
    {
        "data":
        {
            "id":"zZEuSyK",
            "title":null,
            "description":null,
            "datetime":1427401729,
            "type":"image\/png",
            "animated":false,
            "width":1152,
            "height":1920,
            "size":472947,
            "views":0,
            "bandwidth":0,
            "vote":null,
            "favorite":false,
            "nsfw":null,
            "section":null,
            "account_url":null,
            "account_id":0,
            "deletehash":"0Izw6lVnVnED0cP",
            "name":"",
            "link":"http:\/\/i.imgur.com\/zZEuSyK.png"
        },
        "success":true,
        "status":200
    }

    */
    QVariantMap responseMap = jsonDoc.toVariant().toMap();
    if (!responseMap.contains("success") || !responseMap.value("success").toBool()) {
        m_error = "Error uploading to imgur.com";
        emit errorChanged();
        emit finished();
        return;
    }

    QVariantMap dataMap = responseMap.value("data").toMap();

    m_link = dataMap.value("link").toString();
    emit finished();

}
