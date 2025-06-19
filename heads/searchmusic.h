#pragma once

#include <QObject>
#include <QMultiMap>
#include "./heads/musicmodel.h"

class SearchMusic : public QObject
{
    Q_OBJECT
public:
    explicit SearchMusic(QObject *parent = nullptr);
    Q_INVOKABLE void setsourceModel(MusicModel *sourceModel);
    Q_INVOKABLE void seekMusic(const QString &KeyWord);

private slots:
    void performSearch();

private:
    MusicModel *m_sourceModel;
    MusicModel *m_resultModel;
    QString m_currentKeyword;
    QTimer *m_searchTimer;
};
