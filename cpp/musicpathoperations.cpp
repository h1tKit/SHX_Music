#include "./heads/musicpathoperations.h"
#include <filesystem>
#include <qdebug.h>
#include <QFile>
#include <QTextStream>
#include <qvariant.h>

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

bool MusicPathOperations::IsLoveMusdic(
    const QString &fileLovePath, const QString &filePath)
{
    QFile file(fileLovePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "文件错误:" << fileLovePath;
        return false;
    }

    //查看是不是我的喜欢
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine().trimmed(); // 去除首尾空白字符
        if (filePath == line) {
            return true;
        }
    }

    if (in.status() != QTextStream::Ok) {
        qWarning() << "异常终止";
        return false;
    }

    return false;
}

void MusicPathOperations::writeToTxt(
    const QString &filePath, MusicModel *musicModel)
{
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "无法打开文件用于写入:" << filePath;
        return;
    }

    QTextStream out(&file);
    for (int i = 0; i < musicModel->getCount(); i++) {
        out << musicModel->getMuiscPath(i) << "\n";
    }

    file.close();
}

void MusicPathOperations::DeletePathsTxt(
    const QString &filePath, QVariantList deleteIndex)
{
    QList<int> indexes;
    for (const QVariant &index : deleteIndex) {
        if (index.canConvert<int>()) {
            indexes.append(index.toInt());
        }
    }

    //读取原始文件内容
    QFile inputFile(filePath);
    if (!inputFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for reading:" << filePath;
        return;
    }

    QTextStream in(&inputFile);
    QStringList lines;
    while (!in.atEnd()) {
        lines.append(in.readLine());
    }
    inputFile.close();

    //过滤要删除的行（注意行号从0开始）
    QStringList newLines;
    for (int i = 0; i < lines.count(); ++i) {
        if (!deleteIndex.contains(i)) { // 保留不在删除列表中的行
            newLines.append(lines.at(i));
        }
    }

    // 写回文件
    QFile outputFile(filePath);
    if (!outputFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for writing:" << filePath;
        return;
    }

    QTextStream out(&outputFile);
    for (const QString &line : newLines) {
        out << line << "\n";
    }
    outputFile.close();

    // 4. 更新内存中的路径列表
    m_pathList = newLines;
    emit pathListChanged();
}

void MusicPathOperations::DeletePathTxt(
    const QString &filePath, int deleteIndex)
{
    QFile inputFile(filePath);
    if (!inputFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for reading:" << filePath;
        return;
    }

    QTextStream in(&inputFile);
    //QString content;
    int currentLine = 0;

    QStringList newLines;
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (currentLine != deleteIndex) {
            //content.append(line + "\n");
            newLines.append(line + "\n");
        }
        currentLine++;
    }
    inputFile.close();

    QFile outputFile(filePath);
    if (!outputFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "无法写入文件:" << filePath;
        return;
    }

    QTextStream out(&outputFile);
    for (const QString &line : newLines) {
        out << line << "\n";
    }
    outputFile.close();

    m_pathList = newLines;
    emit pathListChanged();
}

QString MusicPathOperations::SeekLyricPath(
    const QString &filePath)
{
    int lastDotIndex = filePath.lastIndexOf('.');
    return (filePath.left(lastDotIndex) + "lrc");
}
