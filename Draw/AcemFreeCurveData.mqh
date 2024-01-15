//+------------------------------------------------------------------+
//|                                                 AcemLineData.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Object.mqh>
#include <Arrays/List.mqh>
#include <Acem/Draw/AcemChartPoint.mqh>

class CAcemFreeCurveData : public CObject
{
private:
    color m_lineColor;
    int m_lineWidth;
    CList m_listPoint;

public:
    CAcemFreeCurveData();
    ~CAcemFreeCurveData();

    void setColor(color lineColor) {m_lineColor = lineColor;};
    color getLineColor() {return m_lineColor;};
    void setLineWidth(int width) {m_lineWidth = width;};
    int getLineWidth() {return m_lineWidth;};

    void addPoint(CAcemChartPoint* pPoint);
    CAcemChartPoint* getFirstPoint();
    CAcemChartPoint* nextPoint();
    CAcemChartPoint* getLastPoint();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveData::CAcemFreeCurveData()
{
    m_listPoint.FreeMode(true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveData::~CAcemFreeCurveData()
{
    m_listPoint.Clear();
}
//+------------------------------------------------------------------+

void CAcemFreeCurveData::addPoint(CAcemChartPoint *pPoint)
{
    m_listPoint.Add(pPoint);
}

CAcemChartPoint* CAcemFreeCurveData::getFirstPoint()
{
    return ((CAcemChartPoint*)m_listPoint.GetFirstNode());
}

CAcemChartPoint* CAcemFreeCurveData::nextPoint()
{
    return ((CAcemChartPoint*)m_listPoint.GetNextNode());
}

CAcemChartPoint* CAcemFreeCurveData::getLastPoint()
{
    return ((CAcemChartPoint*)m_listPoint.GetLastNode());
}
