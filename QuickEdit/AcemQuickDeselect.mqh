//+------------------------------------------------------------------+
//|                                            AcemQuickDeselect.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>

input string deselect_dmy1 = "";                    //-- 選択解除の設定 --
input eInputKeyCode KEY_DESELECT = ACEM_KEYCODE_ESC; // 　　選択解除の入力キー

class CAcemQuickDeselect : public CAcemQuickEditBase
{
private:

public:
    CAcemQuickDeselect();
    ~CAcemQuickDeselect();
    
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickDeselect::CAcemQuickDeselect()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickDeselect::~CAcemQuickDeselect()
{
}
//+------------------------------------------------------------------+
bool CAcemQuickDeselect::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (lparam == KEY_DESELECT)
    {
        // 選択されているオブジェクトを削除
        int objectTotalNum = ObjectsTotal(ChartID());
        int index;
        string objectName;
        int deleteNum = 0;

        // 選択されているオブジェクト数を取得
        for (index = 0; index < objectTotalNum; index++)
        {
            objectName = ObjectName(ChartID(), index);
            if (ObjectGetInteger(ChartID(), objectName, OBJPROP_SELECTED) == true)
            {
                ObjectSetInteger(ChartID(), objectName, OBJPROP_SELECTED, false);
            }
        }
        ChartRedraw(ChartID());
    }
    return true;
}