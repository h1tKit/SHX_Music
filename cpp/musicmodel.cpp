#include "./heads/musicmodel.h"
#include "./heads/musicinfo.h"
#include "./heads/musicpathoperations.h"
#include <QVariantMap>
#include <qvariant.h>
#include <QtConcurrent>

MusicModel::MusicModel(
    QObject *parent)
    : QAbstractListModel(parent)
{
    m_watcher = new QFutureWatcher<MusicItem>(this);
    connect(m_watcher, &QFutureWatcher<MusicItem>::finished, this, [this]() {
        if (m_watcher->future().isResultReadyAt(0)) {
            onMusicLoaded(m_watcher->resultAt(0));
        }
        emit loadingFinished();
    });
}

void MusicModel::loadFromFileAsync(
    const QString &filePath, const QString &fileLovePath)
{
    emit loadingStarted();

    // 创建一个新的watcher，而不是使用共享的m_watcher
    QFutureWatcher<MusicItem> *watcher = new QFutureWatcher<MusicItem>(this);

    QFuture<MusicItem> future = QtConcurrent::run(
        [this, filePath, fileLovePath]() { return loadFromFile(filePath, fileLovePath); });

    watcher->setFuture(future);

    // 使用lambda捕获watcher，确保每个任务有自己的回调
    connect(watcher, &QFutureWatcher<MusicItem>::finished, this, [this, watcher]() {
        if (watcher->future().isResultReadyAt(0)) {
            onMusicLoaded(watcher->resultAt(0));
        }
        watcher->deleteLater(); // 任务完成后删除watcher
        emit loadingFinished();
    });
}

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
    case IsLoveRole:
        return item.isLove;
    case LyricPathRole:
        return item.lyricPath;
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
    roles[IsLoveRole] = "isLove";
    roles[LyricPathRole] = "lyricPath";
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

void MusicModel::removeMusics(
    QVariantList &indexList)
{
    if (indexList.count() == 0) {
        return;
    }

    for (int i = 0; i < indexList.count(); i++) {
        removeMusic(i);
    }
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
    if (data.contains("isLove"))
        item.isLove = false;
    if (data.contains("lyricPath"))
        item.lyricPath = "";

    QModelIndex idx = createIndex(index, 0);
    emit dataChanged(idx, idx);
}

MusicModel::MusicItem MusicModel::loadFromFile(
    const QString &filePath, const QString &fileLovePath)
{
    MusicItem item;
    MusicInfo musicInfo;
    MusicPathOperations musicPathOperations;
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
        if (musicPathOperations.IsLoveMusdic(fileLovePath, filePath)) {
            item.isLove = true;
        }
        item.lyricPath = musicPathOperations.SeekLyricPath(filePath);

        if (item.coverArt.isNull()) {
            //item.coverArt.load(":/default_cover.png");
        }
    }

    return item;
}

QModelIndex MusicModel::createModelIndex(
    int row, int column) const
{
    return createIndex(row, column);
}

void MusicModel::copyModel(
    MusicModel *copy)
{
    if (!copy) {
        return;
    }

    beginResetModel();
    m_musicList = copy->m_musicList; // 复制数据
    endResetModel();
    emit musicAdd();
}

void MusicModel::insertMusic(
    int index, const QString &filePath)
{
    MusicItem newItem;
    MusicInfo musicInfo;
    musicInfo.parseFile(filePath);
    MusicPathOperations musicPathOperations;
    QVariantMap metadata = musicInfo.metadata();
    int insertIndex = index + 1;

    beginInsertRows(QModelIndex(), insertIndex, insertIndex);

    if (!metadata.isEmpty()) {
        newItem.filePath = filePath;
        newItem.title = metadata["title"].toString();
        newItem.artist = metadata["artist"].toString();
        newItem.album = metadata["album"].toString();
        newItem.genre = metadata["genre"].toString();
        newItem.coverArt = qvariant_cast<QImage>(metadata["coverArt"]);
        newItem.track = metadata["track"].toInt();
        newItem.duration = metadata["duration"].toInt();
        newItem.year = metadata["year"].toInt();
        newItem.bitrate = metadata["bitrate"].toInt();
        newItem.sampleRate = metadata["sampleRate"].toInt();
        newItem.channels = metadata["channels"].toInt();
        newItem.isLove = false; //默认在播放列表的ISLOVE为FALSE
        newItem.lyricPath = musicPathOperations.SeekLyricPath(filePath);

        if (newItem.coverArt.isNull()) {
            //item.coverArt.load(":/default_cover.png");
        }

        m_musicList.insert(insertIndex, newItem);
    }

    endInsertRows();
    emit musicAdd();
}

void MusicModel::insertMusics(
    int index, QStringList &filePaths)
{
    if (filePaths.isEmpty())
        return;

    if (index < 0 || index > m_musicList.size()) {
        index = m_musicList.size(); // 默认插入到末尾
    }

    int insertIndex = index + 1;

    for (int i = 0; i < filePaths.size(); ++i) {
        insertMusic(insertIndex, filePaths[i]);
        insertIndex++;
    }
}

QString MusicModel::getMuiscPath(
    int index)
{
    if (m_musicList.count() == 0) {
        return "";
    }

    return m_musicList[index].filePath;
}

int MusicModel::getCount() const
{
    return m_musicList.size();
}

void MusicModel::changeIsLove(
    int index)
{
    m_musicList[index].isLove = !m_musicList[index].isLove;
}

void MusicModel::onMusicLoaded(
    const MusicItem &item)
{
    if (!item.filePath.isEmpty()) {
        beginInsertRows(QModelIndex(), m_musicList.count(), m_musicList.count());
        m_musicList.append(item);
        endInsertRows();
        emit musicAdd();
    }
}
