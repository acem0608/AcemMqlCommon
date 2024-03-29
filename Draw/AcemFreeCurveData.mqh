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
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Draw/AcemChartPoint.mqh>

class CAcemFreeCurveData : public CList
{
private:
    color m_lineColor;
    int m_lineWidth;
    string m_strLineDataPrefix;
    eLineDirection m_lineDirection;

public:
    CAcemFreeCurveData();
    ~CAcemFreeCurveData();

    void setColor(color lineColor) {m_lineColor = lineColor;};
    color getLineColor() {return m_lineColor;};
    void setLineWidth(int width) {m_lineWidth = width;};
    int getLineWidth() {return m_lineWidth;};
    void setLineDataPrefix(string strPrefix) {m_strLineDataPrefix = strPrefix;};
    string getLineDataPrefix() {return m_strLineDataPrefix;};
    void setLineDirection(eLineDirection direction) {m_lineDirection = direction;};
    eLineDirection getLineDirection() {return m_lineDirection;};

    void Dump();
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

void CAcemFreeCurveData::Dump()
{
    int currentIndex = m_curr_idx;
    CAcemChartPoint* pPoint;
    datetime time;
    double price;
    for (pPoint = GetFirstNode(); pPoint != NULL; pPoint = GetNextNode()) {
        pPoint.getTimePrice(time, price);
        Print(IntegerToString(m_curr_idx) + " : " + TimeToString(time) + " " + DoubleToString(price));
    }
    GetNodeAtIndex(currentIndex);
}