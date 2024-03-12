//+------------------------------------------------------------------+
//|                                               AcemSyncCursor.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Acem/Common/AcemBase.mqh>
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Common/AcemUtility.mqh>
#include <Acem/Draw/AcemSyncCursorCanvas.mqh>

#property strict

class CAcemSyncCursor : public CAcemBase
  {
private:
protected:
    CAcemSyncCursorCanvas m_cursor;
public:
    CAcemSyncCursor();
    ~CAcemSyncCursor();
    bool init();
    bool deinit(const int reason);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncCursor::CAcemSyncCursor() : m_cursor(ACEM_SYNC_CURSOR_CANVAS)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncCursor::~CAcemSyncCursor()
{
}
//+------------------------------------------------------------------+

bool CAcemSyncCursor::init()
{
    m_cursor.init();
    ChartRedraw(ChartID());
    return true;
}

bool CAcemSyncCursor::deinit(const int reason)
{
    m_cursor.Destroy();
    return true;
}

bool CAcemSyncCursor::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    long toChartId;
    double price;
    datetime time = 0;
    int subWnd = 0;
    int posX;
    int posY;
    ChartXYToTimePrice(ChartID(), int(lparam), int(dparam), subWnd, time, price);
    for (toChartId = ChartFirst();toChartId != -1; toChartId = ChartNext(toChartId)) {
        if (toChartId == ChartID()) {
            ObjectSetInteger(toChartId, ACEM_SYNC_CURSOR_CANVAS, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ChartRedraw(toChartId);
        } else {
            if (!ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
                ChartSetInteger(ChartID(), CHART_BRING_TO_TOP, true);
            }

            if (ObjectSetInteger(toChartId, ACEM_SYNC_CURSOR_CANVAS, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS)) {
                if (ChartTimePriceToXY(toChartId, 0, time, price, posX, posY)) {
                    if (convTimeToPosX(toChartId, time, false, posX)) {
                        ObjectSetInteger(toChartId, ACEM_SYNC_CURSOR_CANVAS, OBJPROP_XDISTANCE, posX);
                        ObjectSetInteger(toChartId, ACEM_SYNC_CURSOR_CANVAS, OBJPROP_YDISTANCE, posY);
                        ChartRedraw(toChartId);
                    }
                }
            }
        }
    }
    return true;
}