#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./heads/musicpathoperations.h"
#include "./heads/musicinfo.h"
#include "./heads/musicmodel.h"

int main(
    int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    MusicInfo musicInfo;
    MusicPathOperations mpo;
    MusicModel musicModel;

    qmlRegisterType<MusicModel>("MyModel", 1, 0, "MusicModel");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("MusicInfo", &musicInfo);
    engine.rootContext()->setContextProperty("MusicPathOperations", &mpo);
    // engine.rootContext()->setContextProperty("musicModel", &musicModel);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SHXM", "Main");

    return app.exec();
}
