#include "./heads/searchmusic.h"
#include <QTimer>

SearchMusic::SearchMusic(
    QObject *parent)
    : QObject(parent)
{
    m_searchTimer = new QTimer(this);
    m_searchTimer->setSingleShot(true);
    connect(m_searchTimer, &QTimer::timeout, this, &SearchMusic::performSearch);
}

void SearchMusic::setsourceModel(
    MusicModel *sourceModel)
{
    m_sourceModel = sourceModel;
}

void SearchMusic::seekMusic(
    const QString &KeyWord)
{
    m_currentKeyword = KeyWord;

    // 如果关键词为空，立即清空结果
    if (KeyWord.isEmpty()) {
        m_resultModel->clearMusic();
        return;
    }

    // 启动定时器，延迟执行实际搜索
    m_searchTimer->start(300);
}

void SearchMusic::performSearch()
{
    if (!m_sourceModel || !m_resultModel)
        return;

    // 清空之前的搜索结果
    m_resultModel->clearMusic();

    // 如果关键词为空，直接返回
    if (m_currentKeyword.isEmpty())
        return;

    // 执行搜索
    for (int i = 0; i < m_sourceModel->getCount(); i++) {
        QModelIndex index = m_sourceModel->createModelIndex(i);

        // 获取标题和艺术家信息
        QString title = m_sourceModel->data(index, MusicModel::TitleRole).toString();
        QString artist = m_sourceModel->data(index, MusicModel::ArtistRole).toString();

        // 不区分大小写的模糊匹配
        if (title.contains(m_currentKeyword, Qt::CaseInsensitive)
            || artist.contains(m_currentKeyword, Qt::CaseInsensitive)) {
            // 获取匹配项的文件路径
            QString filePath = m_sourceModel->data(index, MusicModel::FilePathRole).toString();

            // 添加到结果模型
            m_resultModel->insertMusic(m_resultModel->getCount(), filePath);
        }
    }
}
