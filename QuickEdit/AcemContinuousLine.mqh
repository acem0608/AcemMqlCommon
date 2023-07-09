//+------------------------------------------------------------------+
//|                                            AcemContnuousLine.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>
#include <ChartObjects/ChartObjectsLines.mqh>

input string contiLine_dmy1 = "";//-- 連続線の設定 --
input eInputKeyCode KEY_CONTIONOUS_LINE = ACEM_KEYCODE_S; //　　入力キー
input color CONTIONOUS_LINE_COLOR = 0x00FFFFFF;//　　色
input ENUM_LINE_STYLE CONTIONOUS_LINE_STYLE = STYLE_SOLID;//　　線種
input eLineWidth CONTIONOUS_LINE_WIDTH = LINE_WIDTH_1;//　　線幅

class CAcemContinuousLine : public CAcemQuickEditBase
{
private:
    CChartObjectTrend m_Tline;
    CChartObjectTrend* m_pTline;
    int m_groupIndex;
    
    virtual bool setDefalutProp(string objName);
    virtual string getNewGroupObjName();
    virtual string getNewObjName();

public:
    CAcemContinuousLine();
    ~CAcemContinuousLine();
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);

    bool init(bool bDel);
    virtual bool isEditing();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemContinuousLine::CAcemContinuousLine() : CAcemQuickEditBase("Continous Line ")
{
    m_groupIndex = 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemContinuousLine::~CAcemContinuousLine()
{
}
//+------------------------------------------------------------------+

bool CAcemContinuousLine::init(bool bDel)
{
    if (m_pTline != NULL) {
        if (bDel) {
            m_Tline.Delete();
            ChartRedraw(ChartID());
        }
        m_pTline = NULL;
    }
    
    return true;
}

bool CAcemContinuousLine::setDefalutProp(string objName)
{
    CAcemQuickEditBase::setDefalutProp(objName);
    ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, CONTIONOUS_LINE_COLOR);
    ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, CONTIONOUS_LINE_STYLE);
    ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, CONTIONOUS_LINE_WIDTH);
//    ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, CONTIONOUS_LINE_BACK);
//    ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_RIGHT, CONTIONOUS_LINE_RAY_RIGHT);
//#ifdef __MQL5__
//   ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_LEFT, TLINE_RAY_LEFT);
//#endif
    return true;
}

bool CAcemContinuousLine::isEditing()
{
   if (m_pTline == NULL) {
      return false;
  }

    return true;
}


bool CAcemContinuousLine::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (m_pTline == NULL)
    {
        if (lparam == ACEM_KEYCODE_S)
        {
            init(true);
            m_pTline = GetPointer(m_Tline);
            string objName = getNewGroupObjName();
            if (m_Tline.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price))
            {
                setDefalutProp(objName);
            }
        } else if (lparam == ACEM_KEYCODE_ESC) {
            init(true);
            m_objNameIndex = 0;
        }
    } else if (lparam == ACEM_KEYCODE_ESC) {
        init(true);
        m_objNameIndex = 0;
    }
    
    return true;
}
bool CAcemContinuousLine::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    CAcemQuickEditBase::OnMouseMove(id, lparam, dparam, sparam);

    if (m_pTline != NULL) {
        m_Tline.SetPoint(1, m_time, m_price);
        ChartRedraw(ChartID());
    }
    return true;
}

bool CAcemContinuousLine::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    if (m_pTline != NULL) {
        string objName = m_Tline.Name();
        EventChartCustom(ChartID(), 0, 0, 0.0, ACEM_SYNC_OTHER_CHART_ADD + objName);
        m_pTline = NULL;

        m_pTline = GetPointer(m_Tline);
        objName = getNewObjName();
        if (m_Tline.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price))
        {
            setDefalutProp(objName);
        }
    }

    return true;
}

string CAcemContinuousLine::getNewGroupObjName()
{
    //Continous Line #グループ番号 @連続線のインデックス ACEM_IDENTIFER チャートID
    string objName;
    do {
        m_groupIndex++;
        objName = m_objNamePrefix + "#" + IntegerToString(m_groupIndex, 3, '0') + " @" + IntegerToString(1, 3, '0') + " " + ACEM_IDENTIFER + " " + IntegerToString(ChartID());
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}

string CAcemContinuousLine::getNewObjName()
{
    //Continous Line #グループ番号 @連続線のインデックス ACEM_IDENTIFER チャートID
    string objName;
    do {
        m_objNameIndex++;
        objName = m_objNamePrefix + "#" + IntegerToString(m_groupIndex, 3, '0') + " @" + IntegerToString(m_objNameIndex, 3, '0') + " " + ACEM_IDENTIFER + " " + IntegerToString(ChartID());
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}
