#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./heads/musicpathoperations.h"
#include "./heads/musicinfo.h"
#include "./heads/musicmodel.h"
#include "./heads/fileOperations.h"

int main(
    int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    MusicInfo musicInfo;
    MusicPathOperations mpo;
    FileOperations fileOperaTions;

    qmlRegisterType<MusicModel>("MyModel", 1, 0, "MusicModel");
    qmlRegisterType<MusicModel>("MyModel", 1, 0, "FileOperations");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("MusicInfo", &musicInfo);
    engine.rootContext()->setContextProperty("MusicPathOperations", &mpo);
    //engine.rootContext()->setContextProperty("FileOperaTions", &fileOperaTions);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SHXM", "Main");

    return app.exec();
}
