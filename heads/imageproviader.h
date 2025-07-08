#pragma once

#include <QObject>
#include <QImage>

class ImageProviader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QImage image READ image NOTIFY imageChanged);

public:
    explicit ImageProviader(QObject *parent = nullptr);

    QImage image() const;
    void setIamge(const QImage &newImage);

signals:
    void imageChanged();

private:
    QImage m_image;
};
