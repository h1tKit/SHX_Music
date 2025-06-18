#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QUrl>
#include <QImage>

class MusicModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum MusicRoles {
        FilePathRole,
        TitleRole,
        ArtistRole,
        AlbumRole,
        YearRole,
        TrackRole,
        GenreRole,
        CoverArtRole,
        DurationRole,
        BitrateRole,
        SampleRateRole,
        ChannelsRole,
    };
    Q_ENUM(MusicRoles); //QML 中通过类名.枚举值访问枚举

    explicit MusicModel(QObject *parent = nullptr);

    // 必须实现的虚函数
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    //Q_INVOKABLE void addMusic();
    Q_INVOKABLE void removeMusic(int index);
    Q_INVOKABLE void clearMusic();
    Q_INVOKABLE void updateMusic(int index, const QVariantMap &data);
    Q_INVOKABLE void loadFromFile(const QString &filePath);
    Q_INVOKABLE QModelIndex createModelIndex(int row, int column = 0);

signals:
    void musicAdd();
    void musicRemove(int index);

private:
    struct MusicItem
    {
        QString filePath;
        QString title;
        QString artist;
        QString album;
        QString genre;
        QImage coverArt;
        int track;
        int duration;
        int year;
        int bitrate;
        int sampleRate;
        int channels;
    };

    QList<MusicItem> m_musicList;
};
