//+------------------------------------------------------------------+
//|                                              AcemQuickDelete.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>

input eInputKeyCode KEY_DELETE = ACEM_KEYCODE_D;//削除

class CAcemQuickDelete : public CAcemQuickEditBase
{
private:
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
public:
  CAcemQuickDelete();
  ~CAcemQuickDelete();

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickDelete::CAcemQuickDelete()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickDelete::~CAcemQuickDelete()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickDelete::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
  if (lparam == KEY_DELETE)
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
        deleteNum++;
      }
    }

    // 選択されているオブジェクトの名前を配列に格納
    string aStrDeleteObjeName[];
    ArrayResize(aStrDeleteObjeName, deleteNum);
    int deleteIndex = 0;
    for (index = 0; index < objectTotalNum; index++)
    {
      objectName = ObjectName(ChartID(), index);
      if (ObjectGetInteger(ChartID(), objectName, OBJPROP_SELECTED) == true)
      {
        aStrDeleteObjeName[deleteIndex++] = objectName;
      }
    }

    // 配列に格納されたオブジェクトの削除
    for (index = 0; index < deleteNum; index++)
    {
      ObjectDelete(ChartID(), aStrDeleteObjeName[index]);
    }
    ChartRedraw(ChartID());
  }
  return true;
}
