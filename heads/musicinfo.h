#pragma once

#include <QObject>
#include <QString>
#include <QImage>
#include <QMap>
#include <QString>
#include <QVariant>

class MusicInfo : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap metadata READ metadata NOTIFY metadataChanged);

public:
    explicit MusicInfo(QObject *parent = nullptr);
    bool isSupportedFormat(const QString &filePath);
    Q_INVOKABLE void parseFile(const QString &filePath);

    // 从 MP3 文件读取元数据
    QVariantMap readMP3Metadata(const QString &filePath);
    // 从 FLAC 文件读取元数据
    QVariantMap readFLACMetadata(const QString &filePath);
    // 从 OGG 文件读取元数据
    QVariantMap readOGGMetadata(const QString &filePath);
    // 从 WAV 文件读取元数据
    QVariantMap readWAVMetadata(const QString &filePath);

    QVariantMap metadata() const { return m_metadata; }

signals:
    void metadataChanged();

private:
    QVariantMap m_metadata; // 存储所有元数据
    QImage m_coverArt;      // 封面图片
};
