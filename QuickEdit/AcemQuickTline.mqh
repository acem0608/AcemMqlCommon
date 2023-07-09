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

input string tline_dmy1 = "";//-- トレンドラインの設定 --
input eInputKeyCode KEY_TLINE = ACEM_KEYCODE_T; //　　トレンドラインの入力キー
input color TLINE_COLOR = 0x00FFFFFF;//　　色
input ENUM_LINE_STYLE TLINE_STYLE = STYLE_SOLID;//　　線種
input eLineWidth TLINE_WIDTH = LINE_WIDTH_1;//　　線幅
input bool TLINE_BACK = false;//　　背景として表示
#ifdef __MQL5__
input bool TLINE_RAY_LEFT = false;//　　左に延長
#endif
input bool TLINE_RAY_RIGHT = false;//　　右に延長

class CAcemQuickTline : public CAcemQuickEditBase
{
private:
    long m_tlineIndex;
    CChartObjectTrend m_Tline;
    CChartObjectTrend* m_pTline;

    virtual bool setDefalutProp(string objName);
public:
    CAcemQuickTline();
    ~CAcemQuickTline();
    
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);

    bool init(bool bDel);
    virtual bool isEditing();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickTline::CAcemQuickTline() : CAcemQuickEditBase("Trend Line ")
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
    if (m_pTline == NULL)
    {
        if (lparam == KEY_TLINE)
        {
            init(true);
            m_pTline = GetPointer(m_Tline);
            string objName = getNewObjName();
            if (m_Tline.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price))
            {
                setDefalutProp(objName);
            }
        } else if (lparam == ACEM_KEYCODE_ESC) {
            init(true);
        }
    } else if (lparam == ACEM_KEYCODE_ESC) {
        init(true);
    }
    
    return true;
}
bool CAcemQuickTline::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    CAcemQuickEditBase::OnMouseMove(id, lparam, dparam, sparam);

    if (m_pTline != NULL) {
        m_Tline.SetPoint(1, m_time, m_price);
        ChartRedraw(ChartID());
    }
    return true;
}

bool CAcemQuickTline::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    if (m_pTline != NULL) {
        string objName = m_Tline.Name();
        EventChartCustom(ChartID(), 0, 0, 0.0, ACEM_SYNC_OTHER_CHART_ADD + objName);
        m_pTline = NULL;
    }
        
    return true;
}

bool CAcemQuickTline::setDefalutProp(string objName)
{
    CAcemQuickEditBase::setDefalutProp(objName);
    ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, TLINE_COLOR);
    ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, TLINE_STYLE);
    ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, TLINE_WIDTH);
    ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, TLINE_BACK);
    ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_RIGHT, TLINE_RAY_RIGHT);
#ifdef __MQL5__
   ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_LEFT, TLINE_RAY_LEFT);
#endif
    return true;
}

bool CAcemQuickTline::isEditing()
{
   if (m_pTline == NULL) {
      return false;
  }

    return true;
}

