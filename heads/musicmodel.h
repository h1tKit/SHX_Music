#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QUrl>
#include <QImage>
#include <QVector>
#include <QFutureWatcher>

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
        IsLoveRole,
        LyricPathRole,
    };
    Q_ENUM(MusicRoles); //QML 中通过类名.枚举值访问枚举

    explicit MusicModel(QObject *parent = nullptr);
    Q_INVOKABLE void loadFromFileAsync(const QString &filePath, const QString &fileLovePath);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void removeMusic(int index);
    Q_INVOKABLE void removeMusics(QVariantList &indexList);
    Q_INVOKABLE void clearMusic();
    Q_INVOKABLE void updateMusic(int index, const QVariantMap &data);
    Q_INVOKABLE QModelIndex createModelIndex(int row, int column = 0) const;
    Q_INVOKABLE void copyModel(MusicModel *copy);
    Q_INVOKABLE void insertMusic(int index, const QString &filePath);
    Q_INVOKABLE void insertMusics(int index, QStringList &filePaths);
    Q_INVOKABLE QString getMuiscPath(int index); //写回txt写路径回去
    Q_INVOKABLE int getCount() const;
    Q_INVOKABLE void changeIsLove(int index);

signals:
    void musicAdd();
    void musicRemove(int index);
    void loadingStarted();
    void loadingFinished();

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
        bool isLove;
        QString lyricPath;
    };

    MusicItem loadFromFile(const QString &filePath, const QString &fileLovePath);
    QList<MusicItem> m_musicList;
    int count = 0;
    QFutureWatcher<MusicItem> *m_watcher;

private slots:
    void onMusicLoaded(const MusicItem &item);
};
