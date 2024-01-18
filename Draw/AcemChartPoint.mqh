//+------------------------------------------------------------------+
//|                                                 AcemChartPos.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Object.mqh>

class CAcemChartPoint : public CObject
{
private:
    datetime m_time;
    double m_price;

public:
    CAcemChartPoint();
    CAcemChartPoint(datetime time, double price);
    ~CAcemChartPoint();

    void setTime(datetime time) {m_time = time;};
    datetime getTime() {return m_time;};
    void setPrice(double price) {m_price = price;};
    double getPrice() {return m_price;};

    void setTimePrice(datetime time, double price);
    void getTimePrice(datetime& time, double& price);
    
    bool isEqual(CAcemChartPoint* pPoint);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemChartPoint::CAcemChartPoint()
{
}

CAcemChartPoint::CAcemChartPoint(datetime time, double price)
{
    setTimePrice(time, price);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemChartPoint::~CAcemChartPoint()
{
}
//+------------------------------------------------------------------+

void CAcemChartPoint::setTimePrice(datetime time, double price)
{
    m_time = time;
    m_price = price;
}

void CAcemChartPoint::getTimePrice(datetime& time, double& price)
{
    time = m_time;
    price = m_price;
}

bool CAcemChartPoint::isEqual(CAcemChartPoint *pPoint)
{
    datetime time;
    double price;
    pPoint.getTimePrice(time, price);
    
    if (m_time != time || m_price != price) {
        return false;
    }
    
    return true;
}
