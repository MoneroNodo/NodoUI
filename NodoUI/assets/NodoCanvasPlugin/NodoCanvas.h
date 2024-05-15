#ifndef NODOCANVAS_H
#define NODOCANVAS_H

#include <QtQuick>
#include <QString>
#include <QPainter>

class NodoCanvas : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    QML_ELEMENT

public:
    NodoCanvas(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    QColor color() const;
    void setColor(const QColor &color);


private:
    QColor m_color;
    const double m_rectHeight = 8.0;
    const double m_rectWidth = 11.0;
    const int m_cwidth = 300;
    const int m_cheight = 64;

    const double cutCornerSize = 8;
    const double angle = 0.610865;
    const double dy = 11.4252;

    // const double cutAngle = 55;
    // double angle = (90 - cutAngle) * M_PI / 180;
    // double dy = cutCornerSize / qTan(angle);

signals:
    void colorChanged();
};

#endif
