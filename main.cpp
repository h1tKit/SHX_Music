#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "./heads/musicpathoperations.h"
#include "./heads/musicinfo.h"

int main(
    int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    MusicInfo musicInfo;
    MusicPathOperations mpo;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("musicInfo", &musicInfo);
    engine.rootContext()->setContextProperty("musicPathOperations", &mpo);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SHXM", "Main");

    return app.exec();
}
