#include "./heads/musicmodel.h"
#include "./heads/musicinfo.h"
#include <QVariantMap>
#include <qvariant.h>

MusicModel::MusicModel(
    QObject *parent)
{}

int MusicModel::rowCount(
    const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_musicList.count();
}

QVariant MusicModel::data(
    const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_musicList.count()) {
        return QVariant();
    }

    const MusicItem &item = m_musicList.at(index.row());

    switch (role) {
    case FilePathRole:
        return item.filePath;
    case TitleRole:
        return item.title;
    case ArtistRole:
        return item.artist;
    case AlbumRole:
        return item.album;
    case YearRole:
        return item.year;
    case TrackRole:
        return item.track;
    case GenreRole:
        return item.genre;
    case CoverArtRole:
        return QVariant::fromValue(item.coverArt);
    case DurationRole:
        return item.duration;
    case BitrateRole:
        return item.bitrate;
    case SampleRateRole:
        return item.sampleRate;
    case ChannelsRole:
        return item.channels;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> MusicModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FilePathRole] = "filePath";
    roles[TitleRole] = "title";
    roles[ArtistRole] = "artist";
    roles[AlbumRole] = "album";
    roles[YearRole] = "year";
    roles[TrackRole] = "track";
    roles[GenreRole] = "genre";
    roles[CoverArtRole] = "coverArt";
    roles[DurationRole] = "duration";
    roles[BitrateRole] = "bitrate";
    roles[SampleRateRole] = "sampleRate";
    roles[ChannelsRole] = "channels";
    return roles;
}

void MusicModel::removeMusic(
    int index)
{
    if (index < 0 || index >= m_musicList.count())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_musicList.removeAt(index);
    endRemoveRows();

    emit musicRemove(index);
}

void MusicModel::clearMusic()
{
    beginResetModel();
    m_musicList.clear();
    endResetModel();
}

void MusicModel::updateMusic(
    int index, const QVariantMap &data)
{
    if (index < 0 || index >= m_musicList.count())
        return;

    MusicItem &item = m_musicList[index];

    if (data.contains("filePath"))
        item.filePath = data["filePath"].toString();
    if (data.contains("title"))
        item.title = data["title"].toString();
    if (data.contains("artist"))
        item.artist = data["artist"].toString();
    if (data.contains("album"))
        item.album = data["album"].toString();
    if (data.contains("year"))
        item.year = data["year"].toInt();
    if (data.contains("track"))
        item.track = data["track"].toInt();
    if (data.contains("genre"))
        item.genre = data["genre"].toString();
    if (data.contains("coverArt"))
        item.coverArt = qvariant_cast<QImage>(data["coverArt"]);
    if (data.contains("duration"))
        item.duration = data["duration"].toInt();
    if (data.contains("bitrate"))
        item.bitrate = data["bitrate"].toInt();
    if (data.contains("sampleRate"))
        item.sampleRate = data["sampleRate"].toInt();
    if (data.contains("channels"))
        item.channels = data["channels"].toInt();

    QModelIndex idx = createIndex(index, 0);
    emit dataChanged(idx, idx);
}

void MusicModel::loadFromFile(
    const QString &filePath)
{
    beginInsertRows(QModelIndex(), m_musicList.count(), m_musicList.count());

    MusicItem item;
    MusicInfo musicInfo;
    musicInfo.parseFile(filePath);
    QVariantMap metadata = musicInfo.metadata();

    if (!metadata.isEmpty()) {
        item.filePath = filePath;
        item.title = metadata["title"].toString();
        item.artist = metadata["artist"].toString();
        item.album = metadata["album"].toString();
        item.genre = metadata["genre"].toString();
        item.coverArt = qvariant_cast<QImage>(metadata["coverArt"]);
        item.track = metadata["track"].toInt();
        item.duration = metadata["duration"].toInt();
        item.year = metadata["year"].toInt();
        item.bitrate = metadata["bitrate"].toInt();
        item.sampleRate = metadata["sampleRate"].toInt();
        item.channels = metadata["channels"].toInt();

        if (item.coverArt.isNull()) {
            //item.coverArt.load(":/default_cover.png");
        }

        m_musicList.append(item);
    }

    endInsertRows();
    emit musicAdd();
}

QModelIndex MusicModel::createModelIndex(
    int row, int column)
{
    return createIndex(row, column);
}

int MusicModel::getCount()
{
    return count;
}

void MusicModel::setCount()
{
    count++;
}

void MusicModel::clearCount()
{
    count = 0;
}
