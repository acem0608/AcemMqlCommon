//+------------------------------------------------------------------+
//|                                               AcemQuickHline.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>

input eInputKeyCode KEY_HLINE = ACEM_KEYCODE_H;//水平線

class CAcemQuickHline : public CAcemQuickEditBase
{
private:
    string getNewObjName();
    long m_hlineIndex;

    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
public:
    CAcemQuickHline();
    ~CAcemQuickHline();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickHline::CAcemQuickHline()
{
    m_hlineIndex = 1;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickHline::~CAcemQuickHline()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickHline::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (lparam == KEY_HLINE) {
        string objName = getNewObjName();
        ObjectCreate(ChartID(), objName, OBJ_HLINE, 0, m_time, m_price);
        setDefalutProp(objName);
        ChartRedraw(ChartID());
        m_price = 0.0;
        m_time = 0;
    }
    return true;
}

string CAcemQuickHline::getNewObjName()
{
    string objName;
    do {
        objName = "Horizontal Line " + convettNumToStr05(m_hlineIndex++);
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}