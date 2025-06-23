#include "./heads/lyricparser.h"
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>

LyricParser::LyricParser(
    QObject *parent)
{}

bool LyricParser::parseFile(
    const QString &filePath)
{
    m_lyricMap.clear();

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return false;
    }

    QTextStream in(&file);
    QRegularExpression regex("\\[(\\d+):(\\d+(?:\\.\\d+)?)]\\s*([^\\[]*)");

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        QRegularExpressionMatch match = regex.match(line);
        if (match.hasMatch()) {
            int minutes = match.captured(1).toInt();
            double seconds = match.captured(2).toDouble();
            QString lyric = match.captured(3).trimmed();

            qint64 timestamp = minutes * 60 * 1000 + static_cast<qint64>(seconds * 1000);

            if (!lyric.isEmpty()) {
                m_lyricMap.insert(timestamp, lyric);
            }
        }
    }

    file.close();
    return !m_lyricMap.isEmpty();
}

QString LyricParser::getLyric(
    qint64 positionMs)
{
    if (!m_lyricMap.isEmpty())
        return "无歌词";

    auto it = m_lyricMap.upperBound(positionMs);
    if (it != m_lyricMap.begin()) {
        it--;
        return it.value();
    }
    return "";
}

int LyricParser::getCurrentLine(
    qint64 positionMs)
{
    if (m_lyricMap.isEmpty())
        return -1;

    auto it = m_lyricMap.upperBound(positionMs);
    return std::distance(m_lyricMap.begin(), it) - 1;
}

QStringList LyricParser::getAllLyrics() const
{
    return m_lyricMap.values();
}

QList<qint64> LyricParser::getAllTimestamps() const
{
    return m_lyricMap.keys();
}
