#pragma once
#include <QObject>
#include <QString>
#include <QStringList>

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
    Q_INVOKABLE void DeletePathToTxt(const QString &filePath, QVariantList deleteIndex);

signals:
    void pathListChanged();

private:
    QStringList m_pathList;
};
