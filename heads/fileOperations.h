#pragma once
#include <QWidget>
#include <QObject>
#include <QFile>
#include <QSet>
#include <QDir>

class FileOperations : public QObject
{
    Q_OBJECT
public:
    explicit FileOperations(QWidget *parentWidget = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE QStringList selectMultipleFiles();
    Q_INVOKABLE QStringList selectFolder(const QString &destination); //参数是默认打开的目录

private:
    QWidget *m_parentWidget;
    QStringList m_selectedFiles;
};
