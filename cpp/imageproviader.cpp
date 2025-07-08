#include "./heads/imageproviader.h"

ImageProviader::ImageProviader(
    QObject *parent)
{}

QImage ImageProviader::image() const
{
    return m_image;
}

void ImageProviader::setIamge(
    const QImage &newImage)
{
    if (m_image == newImage)
        return;
    m_image = newImage;
    emit imageChanged();
}
