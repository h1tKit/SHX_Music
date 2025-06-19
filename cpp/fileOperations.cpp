#include "./heads/fileOperations.h"
#include <QFileInfoList>
#include <QFileDialog>
#include <QMessageBox>

FileOperations::FileOperations(
    QWidget *parentWidget, QObject *parent)
    : QObject(parent)
    , m_parentWidget(parentWidget)
{}

QStringList FileOperations::selectMultipleFiles()
{
    QStringList musicPaths
        = QFileDialog::getOpenFileNames(m_parentWidget,
                                        "选择音乐文件",   // 对话框标题
                                        QDir::homePath(), // 默认打开目录（用户主目录）
                                        "音乐文件 (*.mp3 *.wav *.ogg *.flac)" // 文件过滤器
        );

    if (musicPaths.isEmpty()) {
        qDebug() << "User cancle";
        return m_selectedFiles;
    }

    m_selectedFiles = musicPaths;

    return m_selectedFiles;
}

QStringList FileOperations::selectFolder(
    const QString &destination)
{
    QFileDialog dialog(nullptr);
    dialog.setFileMode(QFileDialog::Directory);
    dialog.setOption(QFileDialog::ShowDirsOnly, false);

    //初始目录
    if (!destination.isEmpty()) {
        dialog.setDirectory(destination);
    }

    dialog.setNameFilters({"音频文件 (*.mp3 *.wav *.flac *.ogg)", "所有文件 (*)"});

    QStringList fileList;

    if (dialog.exec()) {
        QString selectDir = dialog.selectedFiles().first();
        QDir dir(selectDir);

        QStringList nameFilters = {"*.mp3 *.wav *.flac *.ogg"};
        fileList = dir.entryList(nameFilters, QDir::Files | QDir::Readable);

        for (int i = 0; i < fileList.size(); i++) {
            fileList[i] = dir.absoluteFilePath(fileList[i]);
        }

        if (fileList.isEmpty()) {
            QMessageBox::information(nullptr, "提示", "所选文件夹中没有找到音乐文件。");
        }
    }

    return fileList;
}
