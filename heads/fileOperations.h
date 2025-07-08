#pragma once

#include <QObject>
#include <QStringList>
#include <QQmlEngine>
#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QWindow>
#include <QWidget>
#include <QFileDialog>
#include <QDir>

class FileOperations : public QObject
{
    Q_OBJECT
public:
    explicit FileOperations(QObject *parent = nullptr);

    // 选择多个音乐文件
    Q_INVOKABLE QStringList selectMusicFiles();

    // 选择文件夹中的音乐文件
    Q_INVOKABLE QStringList selectMusicFromFolder(const QString &folderPath = "");

private:
    // 获取QWidget父组件
    QWidget *getParentWidget() const;
};
