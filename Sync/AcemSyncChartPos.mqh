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
bool bInit = false;
class CAcemSyncChartPos : public CAcemBase
{
protected:
    CChartObjectVLine m_BaseLine;

    datetime m_baseTime;
    long m_baseXPos;
    int m_baseOffset;
    int m_baseIndex;
    ENUM_TIMEFRAMES m_period;

    int getOffsetIndex(int offset);

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
    int objNum = ObjectsTotal(ChartID());
    if (bInit == false) {
        bInit = true;
    if (ObjectFind(ChartID(), ACEM_SYNC_BASE_LINE_NAME) < 0) {
        //初期化処理
        m_baseOffset = WindowBarsPerChart() / 2;
        m_baseIndex = getOffsetIndex(m_baseOffset);
        m_baseXPos = convIndexToPosX(m_baseIndex);
        m_baseTime = convIndexToTime(m_baseIndex);
        m_period = ChartPeriod(ChartID());
        
        //m_strBaseLineName = ACEM_SYNC_BASE_LINE_PREFIX + IntegerToString(ChartID());
        //m_strBaseLineName = ACEM_SYNC_BASE_LINE_PREFIX;
    
        //中心にラインを追加
        long chartId = ChartID();
        bool bRetc = ObjectCreate(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJ_VLINE, 0, m_baseTime, 0, 0);
        ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_READONLY, false);
        ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_HIDDEN, false);
        ObjectSetInteger(chartId, ACEM_SYNC_BASE_LINE_NAME, OBJPROP_SELECTABLE, true);
    }
    }
}

void CAcemSyncChartPos::deinit()
{
    ObjectDelete(ChartID(), ACEM_SYNC_BASE_LINE_NAME);
}

bool CAcemSyncChartPos::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    if (sparam == ACEM_SYNC_BASE_LINE_NAME) {
        if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
            m_baseTime = ObjectGet(ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME1);
            m_baseXPos = convTimeToPosX(m_baseTime);
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
    if (m_period != ChartPeriod(ChartID())) {
        //  時間軸の変更
        shitChartToBaseLine();
        m_period = ChartPeriod(ChartID());
    } else {
        moveBaseLineToBasePos();
    }
    return true;
}

 // 基準線の位置がX座標の位置になるようにチャートをシフトする
void CAcemSyncChartPos::shitChartToBaseLine()
{
    datetime currentTime = ObjectGet(ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME1);
    int shift = m_baseIndex - convTimeToIndex(currentTime);
    m_baseTime = currentTime;
    m_baseIndex = convTimeToIndex(currentTime);
    m_baseXPos = convTimeToPosX(currentTime);
    ChartNavigate(ChartID(), CHART_CURRENT_POS, -shift);
    ChartRedraw(ChartID());
    
}

// 基準線をX座標の位置となるように時間を設定する。
void CAcemSyncChartPos::moveBaseLineToBasePos()
{
    m_baseTime = convPosXToTime(m_baseXPos);
    m_baseIndex = convPosXToIndex(m_baseXPos);
    ObjectSet(ACEM_SYNC_BASE_LINE_NAME, OBJPROP_TIME1, m_baseTime);
    ChartRedraw(ChartID());
}

int CAcemSyncChartPos::getOffsetIndex(int offset)
{
    int leftIndex = WindowFirstVisibleBar();
    int offsetIndex = leftIndex - offset;

    return offsetIndex;
}

