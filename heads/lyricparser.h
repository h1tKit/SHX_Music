#pragma once

#include <QObject>
#include <QString>
#include <QMap>

class LyricParser : public QObject
{
    Q_OBJECT

public:
    explicit LyricParser(QObject *parent = nullptr);
    //初始化
    Q_INVOKABLE bool parseFile(const QString &filePath);
    // 根据时间获取当前歌词
    Q_INVOKABLE QString getLyric(qint64 positionMs);
    // 获取当前歌词行号
    Q_INVOKABLE int getCurrentLine(qint64 positionMs);
    // 获取所有歌词
    Q_INVOKABLE QStringList getAllLyrics() const;
    // 获取所有时间戳
    Q_INVOKABLE QList<qint64> getAllTimestamps() const;

private:
    QMap<qint64, QString> m_lyricMap; // 时间戳(毫秒) -> 歌词文本
};
