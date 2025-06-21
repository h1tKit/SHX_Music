#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./heads/musicpathoperations.h"
#include "./heads/musicinfo.h"
#include "./heads/musicmodel.h"
#include "./heads/fileOperations.h"
#include "./heads/imageproviader.h"

int main(
    int argc, char *argv[])
{
    qputenv("QT_QPA_PLATFORMTHEME", "xdgdesktopportal");

    QGuiApplication app(argc, argv);

    MusicInfo musicInfo;
    MusicPathOperations mpo;
    FileOperations fileOperaTions;
    ImageProviader imageProviader;

    // QImage image("path/to/your/image.jpg");
    // imageProvider.setImage(image);

    qmlRegisterType<MusicModel>("MyModel", 1, 0, "MusicModel");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("MusicInfo", &musicInfo);
    engine.rootContext()->setContextProperty("MusicPathOperations", &mpo);
    engine.rootContext()->setContextProperty("FileOperaTions", &fileOperaTions);
    engine.rootContext()->setContextProperty("ImageProviader", &imageProviader);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("SHXM", "Main");

    return app.exec();
}

