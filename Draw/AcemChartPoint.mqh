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
    ~CAcemChartPoint();

    void setTime(datetime time) {m_time = time;};
    datetime getTime() {return m_time;};
    void setPrice(double price) {m_price = price;};
    double getPrice() {return m_price;};

    void setTimePrice(datetime time, double price);
    void getTimePrice(datetime& time, double& price);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemChartPoint::CAcemChartPoint()
{
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
