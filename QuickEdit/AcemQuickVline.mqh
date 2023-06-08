//+------------------------------------------------------------------+
//|                                               AcemQuickVline.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>

input eInputKeyCode KEY_VLINE = ACEM_KEYCODE_V;//垂直線

class CAcemQuickVline : public CAcemQuickEditBase
{
private:
    string getNewObjName();
    long m_vlineIndex;

    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);

public:
    CAcemQuickVline();
    ~CAcemQuickVline();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickVline::CAcemQuickVline()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickVline::~CAcemQuickVline()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickVline::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (lparam == KEY_VLINE)
    {
        string objName = getNewObjName();
        ObjectCreate(ChartID(), objName, OBJ_VLINE, 0, m_time, m_price);
        setDefalutProp(objName);
        ChartRedraw(ChartID());
        m_price = 0.0;
        m_time = 0;
    }
    return true;
}

string CAcemQuickVline::getNewObjName()
{
    string objName;
    do
    {
        objName = "Vertical Line " + convettNumToStr05(m_vlineIndex++);
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}