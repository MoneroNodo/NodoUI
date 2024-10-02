#include "NodoCanvas.h"
#include <QDebug>

NodoCanvas::NodoCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    m_color = Qt::gray;
    m_borderColor = "#141414";

    QSizeF itemSize(m_cwidth, m_cheight);
    this->setSize(itemSize);
}

void NodoCanvas::paint(QPainter *painter)
{
    QPen pen;
    pen.setWidth(2);
    pen.setColor(m_borderColor);
    painter->setPen(pen);
    QBrush brush((QColor(m_color)));
    painter->setBrush(brush);
    painter->setRenderHint(QPainter::Antialiasing);
    QSizeF itemSize = this->size();

    int width = itemSize.width();
    int height = itemSize.height();

#if 0
    QPointF points[8] = {
        QPointF(0, dy),
        QPointF(0, height - dy),
        QPointF(cutCornerSize, height),
        QPointF(width - cutCornerSize, height),
        QPointF(width, height - dy),
        QPointF(width, dy),
        QPointF(width - cutCornerSize, 0),
        QPointF(cutCornerSize, 0),
    };
#else
    QPointF points[8] = {
        QPointF(0.0, m_rectHeight),
        QPointF(m_rectWidth, 0.0),
        QPointF(width - m_rectWidth, 0.0),
        QPointF(width, m_rectHeight),
        QPointF(width, height - m_rectHeight),
        QPointF(width - m_rectWidth, height),
        QPointF(m_rectWidth, height),
        QPointF(0.0, height - m_rectHeight),
    };
#endif
    painter->drawConvexPolygon(points, 8);
}

QColor NodoCanvas::color() const
{
    return m_color;    
}

QColor NodoCanvas::borderColor() const
{
    return m_borderColor;
}

void NodoCanvas::setBorderColor(const QColor &borderColor)
{
    m_borderColor = borderColor;
    update();
}

void NodoCanvas::setColor(const QColor &color)
{
    m_color = color;
    update();
}

