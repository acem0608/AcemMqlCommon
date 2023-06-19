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
#include <Acem/Common/AcemUtility.mqh>

#define ACEM_SYNC_BASE_LINE_NAME "AcemSyncBaseLine"

class CAcemSyncChartPos : public CAcemBase
{
protected:
    datetime m_baseTime;
    int m_baseXPos;
//    int m_baseOffset;
    int m_baseIndex;
    ENUM_TIMEFRAMES m_period;

    int getOffsetIndex(int offset);
    void outputParm();

public:
    CAcemSyncChartPos();
    ~CAcemSyncChartPos();

    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);

    void init();
    void deinit(const int reason);
    void shitChartToBaseLine();
    void shitChartToBaseLineOtherChart(long chartId, datetime currentTime);
    void moveBaseLineToBasePos(long chartId);
    void syncOtherChart();
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
    long chartId = ChartID();
    ChartSetInteger(chartId, CHART_AUTOSCROLL, false);
    if (ObjectFind(chartId, ACEM_SYNC_BASE_LINE_NAME) < 0) {
        int baseOffset = WindowBarsPerChart() / 2;
        m_baseIndex = getOffsetIndex(baseOffset);
        m_baseXPos = convIndexToPosX(chartId, m_baseIndex);
        m_baseTime = convIndexToTime(chartId, m_baseIndex);
        //現在のチャートの中心にラインを追加
        ObjectCreate(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJ_VLINE, 0, m_baseTime, 0, 0);

        long targetId;
        datetime baseTime = 0;
        for (targetId = ChartFirst();targetId != -1; targetId = ChartNext(targetId)) {
           if (targetId == ChartID()) {
               continue;
           }

           // 基準線がないのは対象外
           if (ObjectFind(targetId, ACEM_SYNC_BASE_LINE_NAME) < 0) {
               continue;
           }
           baseTime = ObjectGetInteger(targetId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME);
           break;
        }

        if (baseTime != 0) {
            // 他のチャートに基準線がある場合はそれに時間を合わせる画面移動
            ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME, baseTime);
            m_baseTime = baseTime;
            datetime currentTime = ObjectGetInteger(ChartID(), ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME);
            int currentIndex = convTimeToIndex(chartId, currentTime);
            int shift = m_baseIndex - currentIndex;
            //m_baseXPos = convTimeToPosX(chartId, currentTime);
            ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME, m_baseTime);
            ChartNavigate(chartId, CHART_CURRENT_POS, shift);
            ChartRedraw(chartId);
        }
        //初期化処理
        m_period = ChartPeriod(chartId);

        ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_READONLY, false);
        ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_HIDDEN, false);
        ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_SELECTABLE, true);
    }
}

void CAcemSyncChartPos::deinit(const int reason)
{
    switch(reason) {
    case REASON_PROGRAM:
    case REASON_REMOVE:
        {
            ObjectDelete(ChartID(), ACEM_SYNC_BASE_LINE_NAME);
        }
        break;
    default:
        {
            outputParm();
        }
        break;
    }
}

bool CAcemSyncChartPos::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    if (sparam == ACEM_SYNC_BASE_LINE_NAME) {
        long chartId = ChartID();
        if (ChartGetInteger(chartId,  CHART_BRING_TO_TOP)) {
            m_baseTime = (datetime)ObjectGet(ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME1);
            m_baseXPos = convTimeToPosX(chartId, m_baseTime);
        } else {
            //shitChartToBaseLine();
        }
    }
    return true;
}

bool CAcemSyncChartPos::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    if (sparam == ACEM_SYNC_BASE_LINE_NAME) {
        if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
            shitChartToBaseLine();
        }
    }
    return true;
}

bool CAcemSyncChartPos::OnChartChange(int id, long lparam, double dparam, string sparam)
{
    if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
        moveBaseLineToBasePos(ChartID());
        syncOtherChart();
    } else {
        moveBaseLineToBasePos(ChartID());
    }
    return true;
}

 // 基準線の位置がX座標の位置になるようにチャートをシフトする
void CAcemSyncChartPos::shitChartToBaseLine()
{
    long chartId = ChartID();
    datetime currentTime = (datetime)ObjectGetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME);
    int currentIndex = convTimeToIndex(chartId, currentTime);
    int shift = m_baseIndex - currentIndex;
    m_baseXPos = convTimeToPosX(chartId, currentTime);
    ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME, m_baseTime);
    ChartNavigate(chartId, CHART_CURRENT_POS, -shift);
    ChartRedraw(chartId);
}

void CAcemSyncChartPos::shitChartToBaseLineOtherChart(long chartId, datetime currentTime)
{
    datetime baseTime = (datetime)ObjectGetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME);
    int baseIndex = convTimeToIndex(chartId, baseTime);
    int shift = baseIndex - convTimeToIndex(chartId, currentTime);
    ChartNavigate(chartId, CHART_CURRENT_POS, shift);
    ChartRedraw(chartId);
}

// 基準線をX座標の位置となるように時間を設定する。
void CAcemSyncChartPos::moveBaseLineToBasePos(long chartId)
{
    m_baseTime = convPosXToTime(chartId, m_baseXPos);
    m_baseIndex = convPosXToIndex(chartId, m_baseXPos);
    ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME, m_baseTime);
    ChartRedraw(chartId);
}

int CAcemSyncChartPos::getOffsetIndex(int offset)
{
    int leftIndex = WindowFirstVisibleBar();
    int offsetIndex = leftIndex - offset;

    return offsetIndex;
}

void CAcemSyncChartPos::syncOtherChart()
{
   long targetId;
   for (targetId = ChartFirst();targetId != -1; targetId = ChartNext(targetId)) {
       if (targetId == ChartID()) {
           continue;
       }

       if (ChartSymbol(ChartID()) != ChartSymbol(targetId)) {
           continue;
       }
       
       // 基準線がないのは対象外
       if (ObjectFind(targetId, ACEM_SYNC_BASE_LINE_NAME) < 0) {
           continue;
       }
       
       shitChartToBaseLineOtherChart(targetId, m_baseTime);
       ChartRedraw(targetId);
   }
}

void CAcemSyncChartPos::outputParm(void)
{
}
