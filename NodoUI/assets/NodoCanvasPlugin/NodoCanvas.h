#ifndef NODOCANVAS_H
#define NODOCANVAS_H

#include <QtQuick>
#include <QString>
#include <QPainter>

class NodoCanvas : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QColor borderColor READ borderColor WRITE setBorderColor NOTIFY borderColorChanged)
    QML_ELEMENT

public:
    NodoCanvas(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    QColor color() const;
    QColor borderColor() const;
    void setColor(const QColor &color);
    void setBorderColor(const QColor &borderColor);

private:
    QColor m_color;
    QColor m_borderColor;
    const double m_rectHeight = 15.0;
    const double m_rectWidth = 15.0;
    const int m_cwidth = 300;
    const int m_cheight = 64;

    const double cutCornerSize = 15;
    const double angle = 0.785398;
    const double dy = 15.0;

    // const double cutAngle = 55;
    // double angle = (90 - cutAngle) * M_PI / 180;
    // double dy = cutCornerSize / qTan(angle);

signals:
    void colorChanged();
    void borderColorChanged();
};

#endif
