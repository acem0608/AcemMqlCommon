//+------------------------------------------------------------------+
//|                                             AcemSyncChartPos.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <ChartObjects/ChartObjectsLines.mqh>
#include <Acem/Common/AcemBase.mqh>

class CAcemSyncChartPos : public CAcemBase
{
protected:
    CChartObjectVLine m_BaseLine;
    string m_strBaseLineName;

    datetime m_baseTime;
    long m_BaseXPos;

public:
    CAcemSyncChartPos();
    ~CAcemSyncChartPos();

    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);

    void init();
    void deinit();
    void shitChartToBaseLine();
    void moveBaseLineToBasePos();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncChartPos::CAcemSyncChartPos()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncChartPos::~CAcemSyncChartPos()
{
}
//+------------------------------------------------------------------+
void CAcemSyncChartPos::init()
{
    //初期化処理

    //中心にラインを追加
}

void CAcemSyncChartPos::deinit()
{
    //
}

bool CAcemSyncChartPos::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemSyncChartPos::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemSyncChartPos::OnChartChange(int id, long lparam, double dparam, string sparam)
{
    return true;
}

 // 基準線の位置がX座標の位置になるようにチャートをシフトする
 void CAcemSyncChartPos::shitChartToBaseLine()
 {
 }
 
 // 基準線をX座標の位置となるように時間を設定する。
 void CAcemSyncChartPos::moveBaseLineToBasePos()
 {
 }
