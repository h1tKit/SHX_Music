#include "./heads/musicpathoperations.h"
#include <filesystem>
#include <qdebug.h>
#include <QFile>
#include <QTextStream>

MusicPathOperations::MusicPathOperations(
    QObject *parent)
    : QObject(parent)
{}

bool MusicPathOperations::isTxtFile(
    const QString &filePath)
{
    //声明std::filesystem的命名空间别名fs
    namespace fs = std::filesystem;
    //将QString转换为std::string，并构造文件路径对象
    fs::path path(filePath.toStdString());
    return path.extension() == ".txt";
}

void MusicPathOperations::OperationTxt(
    const QString &filePath)
{
    if (!isTxtFile(filePath)) {
        qWarning() << "File Waring(Not .txt file):" << filePath;
        return;
    }

    m_pathList = ReadPathFromFile(filePath);
    emit pathListChanged();
}

QStringList MusicPathOperations::ReadPathFromFile(
    const QString &filePath)
{
    QStringList pathList;
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "无法打开文件:" << filePath;
        return pathList;
    }

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine().trimmed(); // 去除首尾空白字符
        if (line.isEmpty()) {
            continue;
        }
        pathList.append(line);
    }

    if (in.status() != QTextStream::Ok) {
        qWarning() << "文件读取异常终止";
    }

    file.close();
    return pathList;
}
