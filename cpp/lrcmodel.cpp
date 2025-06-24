#include "./heads/lrcmodel.h"

LrcModel::LrcModel(
    QObject *parent)
    : QAbstractListModel(parent)
{}

int LrcModel::rowCount(
    const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_lyrics.count();
}

int LrcModel::count() const
{
    return m_lyrics.count();
}

// 新增：实现类似ListModel的get(i)方法
QVariantMap LrcModel::get(
    int index) const
{
    QVariantMap result;

    if (index < 0 || index >= m_lyrics.count()) {
        return result; // 返回空Map表示无效索引
    }

    const LyricItem &item = m_lyrics.at(index);
    result["time"] = item.time;
    result["lyric"] = item.lyric;

    return result;
}

QVariant LrcModel::data(
    const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_lyrics.count())
        return QVariant();

    const LyricItem &item = m_lyrics.at(index.row());

    switch (role) {
    case TimeRole:
        return item.time;
    case LyricRole:
        return item.lyric;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LrcModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TimeRole] = "time";
    roles[LyricRole] = "lyric";
    return roles;
}

QString LrcModel::musicFilePath() const
{
    return m_musicFilePath;
}

void LrcModel::setMusicFilePath(
    const QString &path)
{
    if (m_musicFilePath == path)
        return;

    m_musicFilePath = path;
    emit musicFilePathChanged();

    // 从音乐文件路径生成LRC文件路径
    QString lrcFilePath = m_musicFilePath;
    int dotIndex = lrcFilePath.lastIndexOf('.');
    if (dotIndex != -1) {
        lrcFilePath = lrcFilePath.left(dotIndex) + ".lrc";
        parseLrcFile(lrcFilePath);
    }
}

void LrcModel::parseLrcFile(
    const QString &lrcFilePath)
{
    beginResetModel();
    m_lyrics.clear();
    emit countChanged();

    QFile file(lrcFilePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "无法打开LRC文件:" << lrcFilePath;
        endResetModel();
        return;
    }

    QTextStream in(&file);
    in.setEncoding(QStringConverter::Utf8);

    QRegularExpression timeRegExp("\\[(\\d+):(\\d+(\\.\\d+)?)\\]");

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();

        if (line.isEmpty())
            continue;

        QRegularExpressionMatchIterator matches = timeRegExp.globalMatch(line);
        QString lyricText = line;
        while (matches.hasNext()) {
            QRegularExpressionMatch match = matches.next();
            lyricText.remove(match.capturedStart(), match.capturedLength());
        }
        lyricText = lyricText.trimmed();

        if (lyricText.isEmpty())
            continue;

        matches = timeRegExp.globalMatch(line);
        while (matches.hasNext()) {
            QRegularExpressionMatch match = matches.next();
            int minutes = match.captured(1).toInt();
            double seconds = match.captured(2).toDouble();
            double totalSeconds = minutes * 60 + seconds;

            LyricItem item;
            item.time = totalSeconds;
            item.lyric = lyricText;
            m_lyrics.append(item);
        }
    }

    file.close();
    std::sort(m_lyrics.begin(), m_lyrics.end(), [](const LyricItem &a, const LyricItem &b) {
        return a.time < b.time;
    });

    endResetModel();
    emit countChanged();
    emit lrcParsed();
}
