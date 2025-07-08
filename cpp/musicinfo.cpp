#include "./heads/musicinfo.h"
#include <qfileinfo.h>
#include <taglib/fileref.h>
#include <taglib/mpegfile.h>
#include <taglib/tag.h>
#include <taglib/flacfile.h>   // FLAC 支持
#include <taglib/mp4file.h>    // MP4/M4A 支持
#include <taglib/oggfile.h>    // OGG 支持
#include <taglib/vorbisfile.h> // OGG Vorbis 支持
#include <taglib/wavfile.h>    // WAV 支持
#include <taglib/attachedpictureframe.h>
#include <QString>

MusicInfo::MusicInfo(
    QObject *parent)
    : QObject(parent)
{}

void MusicInfo::parseFile(
    const QString &filePath)
{
    QVariantMap metadata;

    if (!QFile::exists(filePath)) {
        qDebug() << "File does not exist: " << filePath;
        return;
    }

    if (!isSupportedFormat(filePath)) {
        qDebug() << "Unsupported file format: " << filePath;
        return;
    }

    QFileInfo fileinfo(filePath);
    QString suffix = fileinfo.suffix().toLower();

    if (suffix == "mp3") {
        metadata = readMP3Metadata(filePath);
    } else if (suffix == "flac") {
        metadata = readFLACMetadata(filePath);
    } else if (suffix == "ogg") {
        metadata = readOGGMetadata(filePath);
    } else if (suffix == "wav") {
        metadata = readWAVMetadata(filePath);
    }

    m_metadata = metadata;
    emit metadataChanged();
}

bool MusicInfo::isSupportedFormat(
    const QString &filePath)
{
    QFileInfo fileinfo(filePath);
    QString suffix = fileinfo.suffix().toLower();

    return suffix == "mp3" || suffix == "wav" || suffix == "ogg" || suffix == "flac";
}

//mp3
QVariantMap MusicInfo::readMP3Metadata(
    const QString &filePath)
{
    QVariantMap metadata;
    // 创建一个 TagLib 的 MPEG::File 对象（用于操作 MP3 文件）
    // 将 Qt 的 QString 路径转换为 UTF-8 编码的 QByteArray
    TagLib::MPEG::File file(filePath.toUtf8().constData());

    //检查文件是否有效且包含标签（如 ID3v1/ID3v2）
    if (file.isValid() && file.tag()) {
        //获取文件的 ID3v2 标签对象
        TagLib::ID3v2::Tag *id3v2Tag = file.ID3v2Tag();
        if (id3v2Tag) {
            metadata["title"] = QString::fromStdString(id3v2Tag->title().to8Bit(true));
            metadata["artist"] = QString::fromStdString(id3v2Tag->artist().to8Bit(true));
            metadata["album"] = QString::fromStdString(id3v2Tag->album().to8Bit(true)); //专辑名称
            metadata["year"] = id3v2Tag->year();
            if (metadata["title"].toString().isEmpty()) {
                metadata["title"] = filePath.split('/').last();
            }
            if (metadata["artist"].toString().isEmpty()) {
                metadata["artist"] = "未知歌手";
            }
            if (metadata["album"].toString().isEmpty()) {
                metadata["album"] = "未知专辑";
            }
            if (metadata["year"].toString().isEmpty()) {
                metadata["year"] = "未知年份";
            }
            metadata["track"] = id3v2Tag->track();                                      //音轨编号
            metadata["genre"] = QString::fromStdString(id3v2Tag->genre().to8Bit(true)); //音乐流派

            //获取专辑图片
            // MP3 文件，封面图片通常存储在 ID3v2 标签的 APIC 帧中
            TagLib::ID3v2::FrameList frames = id3v2Tag->frameList("APIC");
            if (!frames.isEmpty()) {
                TagLib::ID3v2::AttachedPictureFrame *coverFrame
                    = static_cast<TagLib::ID3v2::AttachedPictureFrame *>(frames.front());

                // 获取封面图片数据
                TagLib::ByteVector imageData = coverFrame->picture();

                QImage image;
                image.loadFromData((const uchar *) imageData.data(), imageData.size());
                metadata["coverArt"] = image;
            }

            //获取音频信息
            if (file.audioProperties()) {
                TagLib::AudioProperties *properties = file.audioProperties();
                metadata["duration"] = properties->lengthInSeconds(); //音频时长（秒）
                metadata["bitrate"] = properties->bitrate();          //比特率（kbps）
                metadata["sampleRate"] = properties->sampleRate();    //采样率（Hz）
                metadata["channels"] = properties->channels();        //声道数
            }
        }
    }

    return metadata;
}

//flac
QVariantMap MusicInfo::readFLACMetadata(
    const QString &filePath)
{
    QVariantMap metadata;
    TagLib::FLAC::File file(filePath.toUtf8().constData());

    if (file.isValid() && file.tag()) {
        TagLib::Tag *tag = file.tag();
        metadata["title"] = QString::fromStdString(tag->title().to8Bit(true));
        metadata["artist"] = QString::fromStdString(tag->artist().to8Bit(true));
        metadata["album"] = QString::fromStdString(tag->album().to8Bit(true));
        metadata["year"] = tag->year();
        metadata["track"] = tag->track();
        metadata["genre"] = QString::fromStdString(tag->genre().to8Bit(true));
        if (metadata["title"].toString().isEmpty()) {
            metadata["title"] = filePath.split('/').last();
        }
        if (metadata["artist"].toString().isEmpty()) {
            metadata["artist"] = "未知歌手";
        }
        if (metadata["album"].toString().isEmpty()) {
            metadata["album"] = "未知专辑";
        }
        if (metadata["year"].toString().isEmpty()) {
            metadata["year"] = "未知年份";
        }

        const TagLib::List<TagLib::FLAC::Picture *> pictures = file.pictureList();
        for (auto *picture : pictures) {
            if (picture->type() == TagLib::FLAC::Picture::FrontCover) {
                // 将图片数据转换为 QImage
                QImage cover;
                cover.loadFromData(reinterpret_cast<const uchar *>(picture->data().data()),
                                   picture->data().size());

                if (!cover.isNull()) {
                    metadata["coverArt"] = cover; // 存储到元数据
                    break;                        // 找到封面后退出循环
                } else {
                    metadata["coverArt"] = "";
                }
            }
        }
        if (file.audioProperties()) {
            TagLib::AudioProperties *properties = file.audioProperties();
            metadata["duration"] = properties->lengthInSeconds();
            metadata["bitrate"] = properties->bitrate();
            metadata["sampleRate"] = properties->sampleRate();
            metadata["channels"] = properties->channels();
        }
    }

    return metadata;
}

//ogg
QVariantMap MusicInfo::readOGGMetadata(
    const QString &filePath)
{
    QVariantMap metadata;
    TagLib::Ogg::Vorbis::File file(filePath.toUtf8().constData());

    if (file.isValid() && file.tag()) {
        TagLib::Ogg::XiphComment *tag = file.tag();
        metadata["title"] = QString::fromStdString(tag->title().to8Bit(true));
        metadata["artist"] = QString::fromStdString(tag->artist().to8Bit(true));
        metadata["album"] = QString::fromStdString(tag->album().to8Bit(true));
        metadata["year"] = tag->year();
        metadata["track"] = tag->track();
        metadata["genre"] = QString::fromStdString(tag->genre().to8Bit(true));
        if (metadata["title"].toString().isEmpty()) {
            metadata["title"] = filePath.split('/').last();
        }

        if (metadata["artist"].toString().isEmpty()) {
            metadata["artist"] = "未知歌手";
        }
        if (metadata["album"].toString().isEmpty()) {
            metadata["album"] = "未知专辑";
        }
        if (metadata["year"].toString().isEmpty()) {
            metadata["year"] = "未知年份";
        }

        // 2. 获取专辑图片（封面）
        // OGG 使用 XiphComment 的 FLAC 格式图片
        if (file.tag()) {
            TagLib::Ogg::XiphComment *tag = file.tag();
            const TagLib::List<TagLib::FLAC::Picture *> pictures = tag->pictureList();

            for (auto *picture : pictures) {
                if (picture->type() == TagLib::FLAC::Picture::FrontCover) {
                    // 将图片数据转换为 QImage
                    QImage cover;
                    cover.loadFromData(reinterpret_cast<const uchar *>(picture->data().data()),
                                       picture->data().size());

                    if (!cover.isNull()) {
                        metadata["coverArt"] = cover; // 存储到元数据
                        break;                        // 找到封面后退出循环
                    } else {
                        metadata["coverArt"] = "";
                    }
                }
            }
        }

        if (file.audioProperties()) {
            TagLib::AudioProperties *properties = file.audioProperties();
            metadata["duration"] = properties->lengthInSeconds();
            metadata["bitrate"] = properties->bitrate();
            metadata["sampleRate"] = properties->sampleRate();
            metadata["channels"] = properties->channels();
        }
    }
    return metadata;
}

//wav
QVariantMap MusicInfo::readWAVMetadata(
    const QString &filePath)
{
    QVariantMap metadata;
    TagLib::RIFF::WAV::File file(filePath.toUtf8().constData());

    if (file.isValid() && file.tag()) {
        TagLib::Tag *tag = file.tag();
        metadata["title"] = QString::fromStdString(tag->title().to8Bit(true));
        metadata["artist"] = QString::fromStdString(tag->artist().to8Bit(true));
        metadata["album"] = QString::fromStdString(tag->album().to8Bit(true));
        metadata["year"] = tag->year();
        metadata["track"] = tag->track();
        metadata["genre"] = QString::fromStdString(tag->genre().to8Bit(true));
        if (metadata["title"].toString().isEmpty()) {
            metadata["title"] = filePath.split('/').last();
        }
        if (metadata["artist"].toString().isEmpty()) {
            metadata["artist"] = "未知歌手";
        }
        if (metadata["album"].toString().isEmpty()) {
            metadata["album"] = "未知专辑";
        }
        if (metadata["year"].toString().isEmpty()) {
            metadata["year"] = "未知年份";
        }

        metadata["coverArt"] = "";

        if (file.audioProperties()) {
            TagLib::AudioProperties *properties = file.audioProperties();
            metadata["duration"] = properties->lengthInSeconds();
            metadata["bitrate"] = properties->bitrate();
            metadata["sampleRate"] = properties->sampleRate();
            metadata["channels"] = properties->channels();
        }
    }

    return metadata;
}
