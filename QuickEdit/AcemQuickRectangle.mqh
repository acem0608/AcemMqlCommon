//+------------------------------------------------------------------+
//|                                           AcemQuickRectangle.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>
#include <ChartObjects/ChartObjectsShapes.mqh>

input string rect_dmy1 = "";//-- 矩形の設定 --
input eInputKeyCode KEY_RECT = ACEM_KEYCODE_B; //　　矩形の入力キー
input color RECT_COLOR = clrYellow;//　　色
input ENUM_LINE_STYLE RECT_STYLE = STYLE_SOLID;//　　線種
input eLineWidth RECT_WIDTH = LINE_WIDTH_1;//　　線幅
input bool RECT_BACK = false;//　　背景として表示

class CAcemQuickRectangle : public CAcemQuickEditBase
{
private:
    CChartObjectRectangle m_Rect;
    CChartObjectRectangle* m_pRect;

    virtual bool setDefalutProp(string objName);
public:
    CAcemQuickRectangle();
    ~CAcemQuickRectangle();

    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);

    bool init(bool bDel);
    virtual bool isEditing();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickRectangle::CAcemQuickRectangle() : CAcemQuickEditBase("Rectangle ")
{
    m_pRect = NULL;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickRectangle::~CAcemQuickRectangle()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickRectangle::init(bool bDel)
{
    if (m_pRect != NULL) {
        if (bDel) {
            string objName = m_Rect.Name();
            ObjectDelete(ChartID(), objName);
            m_Rect.Delete();
        }
        m_pRect = NULL;
    }
    
    return true;
}

bool CAcemQuickRectangle::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (m_pRect == NULL)
    {
        if (lparam == KEY_RECT)
        {
            init(true);
            m_pRect = GetPointer(m_Rect);
            string objName = DUMMY_RECT_NAME;
            if (m_Rect.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price))
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
bool CAcemQuickRectangle::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    CAcemQuickEditBase::OnMouseMove(id, lparam, dparam, sparam);

    if (m_pRect != NULL) {
        m_Rect.SetPoint(1, m_time, m_price);
        ChartRedraw(ChartID());
    }
    return true;
}

bool CAcemQuickRectangle::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    if (m_pRect != NULL) {
        string objName = getNewObjName();
        cloneObject(ChartID(), DUMMY_RECT_NAME, ChartID(), objName);
        //EventChartCustom(ChartID(), 0, 0, 0.0, ACEM_SYNC_OTHER_CHART_ADD + objName);
        init(true);
    }
        
    return true;
}

bool CAcemQuickRectangle::setDefalutProp(string objName)
{
    CAcemQuickEditBase::setDefalutProp(objName);

    ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, RECT_COLOR);
    ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, RECT_STYLE);
    ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, RECT_WIDTH);
    ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, RECT_BACK);

    return true;
}

bool CAcemQuickRectangle::isEditing()
{
   if (m_pRect == NULL) {
      return false;
  }

    return true;
}
