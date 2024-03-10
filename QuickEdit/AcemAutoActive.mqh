//+------------------------------------------------------------------+
//|                                               AcemAutoActive.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link      "https://www.mql5.com"
#property version   "1.00"

#property strict

#include <Acem/Common/AcemBase.mqh>

class CAcemAutoActive : public CAcemBase
{
private:

public:
    CAcemAutoActive();
    ~CAcemAutoActive();

    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemAutoActive::CAcemAutoActive()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemAutoActive::~CAcemAutoActive()
{
}
//+------------------------------------------------------------------+

bool CAcemAutoActive::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    ChartSetInteger(ChartID(), CHART_BRING_TO_TOP, true);

    return true;
}
