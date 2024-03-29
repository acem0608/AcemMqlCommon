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
input eInputKeyCode KEY_CONTIONOUS_LINE = ACEM_KEYCODE_R; //　　入力キー
input color CONTIONOUS_LINE_COLOR = 0x00FFFFFF;//　　色
input ENUM_LINE_STYLE CONTIONOUS_LINE_STYLE = STYLE_SOLID;//　　線種
input eLineWidth CONTIONOUS_LINE_WIDTH = LINE_WIDTH_1;//　　線幅

class CAcemContinuousLine : public CAcemQuickEditBase
{
private:
    CChartObjectTrend m_Tline;
    CChartObjectTrend* m_pTline;
    int m_groupIndex;
    string m_delObjName;

    virtual bool setDefalutProp(string objName);
    virtual string getNewGroupObjName();
    virtual string getNewObjName();

public:
    CAcemContinuousLine();
    ~CAcemContinuousLine();
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDelete(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);

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
            m_delObjName = m_Tline.Name();
            ObjectDelete(ChartID(), m_delObjName);
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
    ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_RIGHT, false);

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
        if (lparam == KEY_CONTIONOUS_LINE)
        {
            init(true);
            m_pTline = GetPointer(m_Tline);
            string objName = DUMMY_TRENDLINE_NAME;
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
        string objName;
        if (m_objNameIndex == 0) {
            objName = getNewGroupObjName();
        } else {
            objName = getNewObjName();
        }
        cloneObject(ChartID(), DUMMY_TRENDLINE_NAME, ChartID(), objName);
//        EventChartCustom(ChartID(), 0, 0, 0.0, ACEM_SYNC_OTHER_CHART_ADD + objName);
        ObjectSetInteger(ChartID(), objName, OBJPROP_SELECTED, false);
        init(true);
        m_pTline = NULL;

        m_pTline = GetPointer(m_Tline);
        objName = DUMMY_TRENDLINE_NAME;
        if (m_Tline.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price))
        {
            setDefalutProp(objName);
        }
    }

    return true;
}

bool CAcemContinuousLine::OnObjectDelete(int id, long lparam, double dparam, string sparam)
{
    if (m_delObjName == sparam) {
        return true;
    }
    if (StringFind(sparam, m_objNamePrefix + ACEM_IDENTIFER + " " + IntegerToString(ChartID())) != 0) {
        return true;
    }
    string split_result[];
    int splitNum = StringSplit(sparam, '@', split_result);
    if (splitNum != 2) {
        return true;
    }
    
    int objectTotalNum = ObjectsTotal(ChartID());
    int index;
    string objectName;
    int deleteNum = 0;

    // 選択されているオブジェクト数を取得
    for (index = 0; index < objectTotalNum; index++)
    {
        objectName = ObjectName(ChartID(), index);
        if (StringFind(objectName, split_result[0]) == 0) {
            ObjectDelete(ChartID(), objectName);
        }
    }
    ChartRedraw(ChartID());

    return true;
}

bool CAcemContinuousLine::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    if (StringFind(sparam, m_objNamePrefix + ACEM_IDENTIFER + " " + IntegerToString(ChartID())) != 0) {
        return true;
    }
    string split_result[];
    int splitNum = StringSplit(sparam, '@', split_result);
    if (splitNum != 2) {
        return true;
    }
    
    int editNum = (int)StringToInteger(split_result[1]);

    int preNum = editNum - 1;
    string preObjName = split_result[0] + "@"  + IntegerToString(preNum, 3, '0');
    if (ObjectFind(ChartID(), preObjName) == 0) {
        double price;
        long time;
        if (ObjectGetDouble(ChartID(), sparam, OBJPROP_PRICE, 0, price)) {
            ObjectSetDouble(ChartID(), preObjName, OBJPROP_PRICE, 1, price);
        }
        if (ObjectGetInteger(ChartID(), sparam, OBJPROP_TIME, 0, time)) {
            ObjectSetInteger(ChartID(), preObjName, OBJPROP_TIME, 1, time);
        }
    }

    int nextNum = editNum + 1;
    string nextObjName = split_result[0] + "@"  + IntegerToString(nextNum, 3, '0');
    if (ObjectFind(ChartID(), nextObjName) == 0) {
        double price;
        long time;
        if (ObjectGetDouble(ChartID(), sparam, OBJPROP_PRICE, 1, price)) {
            ObjectSetDouble(ChartID(), nextObjName, OBJPROP_PRICE, 0, price);
        }
        if (ObjectGetInteger(ChartID(), sparam, OBJPROP_TIME, 1, time)) {
            ObjectSetInteger(ChartID(), nextObjName, OBJPROP_TIME, 0, time);
        }
    }
    
    ChartRedraw(ChartID());
    
    return true;
}

bool CAcemContinuousLine::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    if (StringFind(sparam, m_objNamePrefix + ACEM_IDENTIFER + " " + IntegerToString(ChartID())) != 0) {
        return true;
    }
    string split_result[];
    int splitNum = StringSplit(sparam, '@', split_result);
    if (splitNum != 2) {
        return true;
    }
    
    int objectTotalNum = ObjectsTotal(ChartID());
    int index;
    string objectName;
    int deleteNum = 0;

    long objColor;
    bool bColor = ObjectGetInteger(ChartID(), sparam, OBJPROP_COLOR, 0, objColor);
    
    long objLineStyle;
    bool bLineStyle = ObjectGetInteger(ChartID(), sparam, OBJPROP_STYLE, 0, objLineStyle);
    
    long  objLineWidth;
    bool  bLineWidth = ObjectGetInteger(ChartID(), sparam, OBJPROP_WIDTH, 0, objLineWidth);
    
    for (index = 0; index < objectTotalNum; index++)
    {
        objectName = ObjectName(ChartID(), index);
        if (objectName == sparam) {
            continue;
        }

        if (StringFind(objectName, split_result[0]) == 0) {
            if (bColor) {
                ObjectSetInteger(ChartID(), objectName, OBJPROP_COLOR, 0, objColor);
            }
            if (bLineStyle) {
                ObjectSetInteger(ChartID(), objectName, OBJPROP_STYLE, objLineStyle);
            }
            
            if (bLineWidth) {
                ObjectSetInteger(ChartID(), objectName, OBJPROP_WIDTH, objLineWidth);
            }
        }
    }
    ChartRedraw(ChartID());
    
    return true;
}

string CAcemContinuousLine::getNewGroupObjName()
{
    //Continous Line #グループ番号 @連続線のインデックス ACEM_IDENTIFER チャートID
    string objName;
    do {
        m_groupIndex++;
        m_objNameIndex = 1;
        objName = m_objNamePrefix + ACEM_IDENTIFER + " " + IntegerToString(ChartID()) + " #" + IntegerToString(m_groupIndex, 3, '0') + " @" + IntegerToString(1, 3, '0');
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}

string CAcemContinuousLine::getNewObjName()
{
    //Continous Line #グループ番号 @連続線のインデックス ACEM_IDENTIFER チャートID
    string objName;
    do {
        objName = m_objNamePrefix + ACEM_IDENTIFER + " " + IntegerToString(ChartID()) + " #" + IntegerToString(m_groupIndex, 3, '0') + " @" + IntegerToString(m_objNameIndex, 3, '0');
        m_objNameIndex++;
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}
