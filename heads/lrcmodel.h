#ifndef LRCMODEL_H
#define LRCMODEL_H

#include <QAbstractListModel>
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>
#include <QDebug>
#include <QUrl>
#include <QVariantMap> // 新增：用于返回键值对

class LrcModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(
        QString musicFilePath READ musicFilePath WRITE setMusicFilePath NOTIFY musicFilePathChanged)
    Q_PROPERTY(
        int count READ count NOTIFY countChanged)

public:
    enum LrcRoles { TimeRole = Qt::UserRole + 1, LyricRole };

    explicit LrcModel(QObject *parent = nullptr);

    // 基本模型接口
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 自定义功能
    QString musicFilePath() const;
    void setMusicFilePath(const QString &path);
    int count() const;

    // 新增：类似ListModel的get(i)方法
    Q_INVOKABLE QVariantMap get(int index) const;

signals:
    void musicFilePathChanged();
    void lrcParsed();
    void countChanged();

private:
    struct LyricItem
    {
        qreal time;    // 歌词时间点（秒）
        QString lyric; // 歌词文本
    };

    QString m_musicFilePath;
    QList<LyricItem> m_lyrics;

    void parseLrcFile(const QString &lrcFilePath);
};

#endif // LRCMODEL_H
