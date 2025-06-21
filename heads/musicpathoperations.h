#pragma once
#include <QObject>
#include <QString>
#include <QStringList>
#include "musicmodel.h"

class MusicPathOperations : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
        QStringList pathList READ pathList NOTIFY pathListChanged)

public:
    explicit MusicPathOperations(QObject *parent = nullptr);
    bool isTxtFile(const QString &filePath);
    Q_INVOKABLE void OperationTxt(const QString &filePath);
    QStringList ReadPathFromFile(const QString &filePath);
    QStringList pathList() const { return m_pathList; }
    void AddPathToTxt(const QString &filePath, QStringList &newFiles);
    void extracted(QStringList &deleteFiles, QStringList &currentPaths, QStringList &filteredPaths);
    bool IsLoveMusdic(const QString &fileLovePath, const QString &filePath);
    Q_INVOKABLE void WriteToTxt(const QString &filePath, MusicModel &musicModel);
    Q_INVOKABLE void DeletePathsTxt(const QString &filePath, QVariantList deleteIndex);
    Q_INVOKABLE void DeletePathTxt(const QString &filePath, int deleteIndex);

signals:
    void pathListChanged();

private:
    QStringList m_pathList;
};
