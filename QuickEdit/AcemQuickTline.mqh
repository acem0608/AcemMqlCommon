//+------------------------------------------------------------------+
//|                                               AcemQuickTline.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>
#include <ChartObjects/ChartObjectsLines.mqh>

input eInputKeyCode KEY_TLINE = ACEM_KEYCODE_T; //トレンドライン

class CAcemQuickTline : public CAcemQuickEditBase
{
private:
    long m_tlineIndex;
    CChartObjectTrend m_Tline;
    CChartObjectTrend* m_pTline;

    string getNewObjName();
    long m_hlineIndex;

    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);

    bool init(bool bDel);
public:
    CAcemQuickTline();
    ~CAcemQuickTline();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickTline::CAcemQuickTline()
{
    m_tlineIndex = 0;
    m_pTline = NULL;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickTline::~CAcemQuickTline()
{
}
//+------------------------------------------------------------------+
bool CAcemQuickTline::init(bool bDel)
{
    if (m_pTline != NULL) {
        if (bDel) {
            m_Tline.Delete();
        }
        m_pTline = NULL;
    }
    
    return true;
}

bool CAcemQuickTline::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (lparam == KEY_TLINE)
    {
        if (m_pTline == NULL)
        {
            init(true);
            m_pTline = GetPointer(m_Tline);
            string objName = getNewObjName();
            if (m_Tline.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price))
            {
                setDefalutProp(objName);
            }
        }
    } else if (lparam == ACEM_KEYCODE_ESC) {
        init(true);
    }

    return true;
}
bool CAcemQuickTline::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    if (m_pTline != NULL) {
        m_Tline.SetPoint(1, m_time, m_price);
        ChartRedraw(ChartID());
    }
    return true;
}

bool CAcemQuickTline::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    if (m_pTline != NULL) {
        m_pTline = NULL;
    }
        
    return true;
}

string CAcemQuickTline::getNewObjName()
{
    string objName;
    do {
        objName = "Trend Line " + convettNumToStr05(m_tlineIndex++);
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}
