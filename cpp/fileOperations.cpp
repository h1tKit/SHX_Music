// fileoperations.cpp
#include "./heads/fileOperations.h"
#include <QMessageBox>

FileOperations::FileOperations(
    QObject* parent)
    : QObject(parent)
{}

QWidget* FileOperations::getParentWidget() const
{
    // 从QML上下文获取引擎
    QQmlEngine* engine = qmlEngine(const_cast<FileOperations*>(this));
    if (engine) {
        // 尝试转换为QQmlApplicationEngine
        QQmlApplicationEngine* appEngine = qobject_cast<QQmlApplicationEngine*>(engine);
        if (appEngine) {
            QList<QObject*> rootObjects = appEngine->rootObjects();
            if (!rootObjects.isEmpty()) {
                // 尝试将根对象转换为QWidget
                QWidget* rootWidget = qobject_cast<QWidget*>(rootObjects.first());
                if (rootWidget) {
                    return rootWidget;
                }

                // 如果根对象是QWindow，创建窗口容器
                QWindow* rootWindow = qobject_cast<QWindow*>(rootObjects.first());
                if (rootWindow && rootWindow->isVisible()) {
                    QWidget* container = QWidget::createWindowContainer(rootWindow);
                    container->setVisible(false);
                    return container;
                }
            }
        }
    }

    // 备用方案：从顶层窗口获取
    QList<QWindow*> topLevelWindows = QGuiApplication::topLevelWindows();
    for (QWindow* window : topLevelWindows) {
        if (window && window->isVisible()) {
            QWidget* container = QWidget::createWindowContainer(window);
            container->setVisible(false);
            return container;
        }
    }

    return nullptr; // 无法获取有效父窗口
}

QStringList FileOperations::selectMusicFiles()
{
    QWidget* parentWidget = getParentWidget();
    QStringList musicPaths;

    if (parentWidget) {
        musicPaths = QFileDialog::getOpenFileNames(
            parentWidget,
            "选择音乐文件",
            QDir::homePath(),
            "音乐文件 (*.mp3 *.wav *.flac *.m4a *.ogg *.wma);;所有文件 (*)");
    } else {
        qDebug() << "警告: 无法获取父窗口，使用nullptr作为父组件";
        musicPaths = QFileDialog::getOpenFileNames(
            nullptr,
            "选择音乐文件",
            QDir::homePath(),
            "音乐文件 (*.mp3 *.wav *.flac *.m4a *.ogg *.wma);;所有文件 (*)");
    }

    return musicPaths;
}

QStringList FileOperations::selectMusicFromFolder(
    const QString& folderPath)
{
    QWidget* parentWidget = getParentWidget();
    QStringList musicFiles;

    // 选择文件夹
    QString folder = folderPath;
    if (folder.isEmpty()) {
        folder = QFileDialog::getExistingDirectory(parentWidget, "选择音乐文件夹", QDir::homePath());
    }

    if (!folder.isEmpty()) {
        QDir dir(folder);
        if (dir.exists()) {
            // 筛选音乐文件
            QStringList filters = {"*.mp3", "*.wav", "*.flac", "*.m4a", "*.ogg", "*.wma"};
            musicFiles = dir.entryList(filters, QDir::Files | QDir::Readable);

            // 转换为绝对路径
            for (int i = 0; i < musicFiles.size(); i++) {
                musicFiles[i] = dir.absoluteFilePath(musicFiles[i]);
            }

            // 如果没有找到音乐文件
            if (musicFiles.isEmpty() && parentWidget) {
                QMessageBox::information(parentWidget, "提示", "所选文件夹中没有找到音乐文件。");
            }
        }
    }

    return musicFiles;
}
