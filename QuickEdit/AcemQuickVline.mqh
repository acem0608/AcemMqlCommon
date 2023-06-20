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

input string vline_dmy1 = "";//-- 垂直線の設定 --
input eInputKeyCode KEY_VLINE = ACEM_KEYCODE_V;//　　垂直線の入力キー
input color VLINE_COLOR = 0x00FFFFFF;//　　色
input ENUM_LINE_STYLE VLINE_STYLE = STYLE_SOLID;//　　線種
input eLineWidth VLINE_WIDTH = LINE_WIDTH_1;//　　線幅
input bool VLINE_BACK = false;//　　背景として表示

class CAcemQuickVline : public CAcemQuickEditBase
{
private:
    long m_vlineIndex;

    virtual bool setDefalutProp(string objName);

public:
    CAcemQuickVline();
    ~CAcemQuickVline();

    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickVline::CAcemQuickVline() : CAcemQuickEditBase("Vertical Line ")
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

bool CAcemQuickVline::setDefalutProp(string objName)
{
    CAcemQuickEditBase::setDefalutProp(objName);
    ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, VLINE_COLOR);
    ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, VLINE_STYLE);
    ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, VLINE_WIDTH);
    ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, VLINE_BACK);
    return true;
}