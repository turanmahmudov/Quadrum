#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include "uploader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //qmlRegisterType<Uploader>("Foursquare", 1, 0, "Uploader");

    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}

