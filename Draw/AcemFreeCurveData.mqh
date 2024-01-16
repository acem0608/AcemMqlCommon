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

class CAcemFreeCurveData : public CList
{
private:
    color m_lineColor;
    int m_lineWidth;
//    CList m_listPoint;

public:
    CAcemFreeCurveData();
    ~CAcemFreeCurveData();

    void setColor(color lineColor) {m_lineColor = lineColor;};
    color getLineColor() {return m_lineColor;};
    void setLineWidth(int width) {m_lineWidth = width;};
    int getLineWidth() {return m_lineWidth;};
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveData::CAcemFreeCurveData()
{
    FreeMode(true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveData::~CAcemFreeCurveData()
{
    Clear();
}
//+------------------------------------------------------------------+
