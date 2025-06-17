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

void MusicPathOperations::AddPathToTxt(
    const QString &filePath, QStringList &newFiles)
{
    // 读取现有路径
    QStringList currentPaths = ReadPathFromFile(filePath);

    // 合并并去重（保留原有顺序，新增路径追加到末尾)
    for (const QString &path : newFiles) {
        if (!path.isEmpty() && !currentPaths.contains(path)) {
            currentPaths.append(path);
        }
    }

    // 写入文件（无空白行）
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        for (const QString &path : currentPaths) {
            out << path << "\n"; // 每行一个路径
        }
        file.close();

        // 更新属性并发送信号
        m_pathList = currentPaths;
        emit pathListChanged();
    }
}

void MusicPathOperations::DeletePathTotxt(
    const QString &filePath, QStringList &deleteFiles)
{
    // 读取现有路径
    QStringList currentPaths = ReadPathFromFile(filePath);

    // 过滤掉需要删除的路径
    QStringList filteredPaths;
    for (const QString &path : currentPaths) {
        if (!path.isEmpty() && !deleteFiles.contains(path)) {
            filteredPaths.append(path);
        }
    }

    // 写入文件（无空白行）
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        for (const QString &path : filteredPaths) {
            out << path << "\n"; // 每行一个路径
        }
        file.close();

        // 更新属性并发送信号
        m_pathList = filteredPaths;
        emit pathListChanged();
    }
}
