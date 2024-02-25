//+------------------------------------------------------------------+
//|                                             AcemSyncChartPos.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

//#define _ACEM_DEBUG

#include <ChartObjects/ChartObjectsLines.mqh>
#include <Acem/Common/AcemBase.mqh>
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Common/AcemUtility.mqh>
#include <Acem/Common/AcemDebug.mqh>
#include <Acem/Draw/AcemVlineCanvas.mqh>
#include <Acem/Draw/AcemHideRightCanvas.mqh>

#define ACEM_SYNC_BASE_RATIO_PREFIX "AcemBaseLineRatio"

input string AcemSyncPos = "";                                 //-- 基準線の設定 --
input color ACEM_SYNC_POS_BASE_LINE_COLOR = 0x00FFFFFF;        // 　　色
//input eLineWidth ACEM_SYNC_POS_BASE_LINE_WIDTH = LINE_WIDTH_1; // 　　線幅
input bool IS_HIDE_RIGHT = true;                               // 　　基準線の右側を隠す

class CAcemSyncChartPos : public CAcemBase
{
protected:
    CAcemVlineCanvas m_syncLineCnavas;
    CAcemHideRightCanvas m_hideRightCanvas;
    int m_posX;
    datetime m_syncTime;
    string m_strShowLineName;
    string m_strHideLineNmae;

    int m_wndWidth;
    int m_wndHeight;
    ENUM_TIMEFRAMES m_timeFrame;
    int m_leftIndex;
    int m_chartScale;

    bool m_isNeedRefresh;
    bool m_bFailedMoveBaseLine;
    bool m_bFailedSyncChart;

public:
    CAcemSyncChartPos();
    ~CAcemSyncChartPos();

    void init();
    void deinit(const int reason);

    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnCustomEvent(int id, long lparam, double dparam, string sparam);

    void setHideLineProp();
    void redrawAll();
    
    bool getBaseTime(datetime& baseTime);
    bool syncChart();
    bool isSyncChart(long targetId);
    int getHideWidth();
    bool shiftBaseLineOnGrid();
    bool moveBaseLine(int posX);
    string getBaseTimeString();
    void setBaseTimeLabelString();
    bool setBaseLineTime(datetime newTime);
    void syncOtherChart(datetime newTime);
    void moveSupportObject();

};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncChartPos::CAcemSyncChartPos() : m_syncLineCnavas(ACEM_SYNC_SHOW_BASE_LINE_NAME),
                                         m_hideRightCanvas(ACEM_HIDE_RIGHT_CANVAS)
{
    m_strShowLineName = ACEM_SYNC_SHOW_BASE_LINE_NAME;
    m_strHideLineNmae = ACEM_SYNC_HIDE_BASE_LINE_NAME;
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
debugPrint(__FUNCTION__ + " Start");
    m_isNeedRefresh = true;
    m_bFailedMoveBaseLine = false;
    m_bFailedSyncChart = false;

    m_hideRightCanvas.init();
    if (!IS_HIDE_RIGHT) {
        m_hideRightCanvas.resize(1,1);
    }

    long timeFrameValue;
    if (getParamValue(ChartID(), ACEM_PARAM_TIMEFRAME, timeFrameValue)) {
        m_timeFrame = (ENUM_TIMEFRAMES)timeFrameValue;
    } else {
        m_timeFrame = ChartPeriod(ChartID());
        setParamText(ChartID(), ACEM_PARAM_TIMEFRAME, m_timeFrame);
    }
//    setParamText(ChartID(), ACEM_PARAM_TIMEFRAME, m_timeFrame);

    m_wndWidth = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    m_wndHeight = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    m_leftIndex = WindowFirstVisibleBar();
    m_chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    
    ChartSetInteger(ChartID(), CHART_AUTOSCROLL, false);

    m_syncLineCnavas.init();
    m_syncLineCnavas.fill(ColorToARGB(ACEM_SYNC_POS_BASE_LINE_COLOR, 255));
//    m_syncLineCnavas.Update();
    
    if (ObjectFind(ChartID(), m_strHideLineNmae) < 0) {
        datetime baseTime = datetime(0);
        if (getBaseTime(baseTime)) {
            ObjectCreate(ChartID(), m_strHideLineNmae, OBJ_VLINE, 0, baseTime, 0, 0);
            setHideLineProp();
        }
    }

    if (ObjectFind(ChartID(), ACEM_SYNC_LINE_TIME_LABEL) < 0) {
        ObjectCreate(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_COLOR, clrYellow);    // 色設定
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_BACK, false);           // オブジェクトの背景表示設定
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_SELECTABLE, true);     // オブジェクトの選択可否設定
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_SELECTED, false);      // オブジェクトの選択状態
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_HIDDEN, false);         // オブジェクトリスト表示設定
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_FONTSIZE, 10);                   // フォントサイズ
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_CORNER, CORNER_LEFT_LOWER);  // コーナーアンカー設定
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER); 
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_YDISTANCE, 0);                 // Y座標
    }

    setBaseTimeLabelString();
    moveSupportObject();

    redrawAll();

debugPrint(__FUNCTION__ + " End");
}

void CAcemSyncChartPos::deinit(const int reason)
{
debugPrint(__FUNCTION__ + " Start");
    m_syncLineCnavas.deinit(reason);
    m_hideRightCanvas.deinit(reason);
    switch (reason) {
        case REASON_REMOVE:
            {
                ObjectDelete(ChartID(), m_strHideLineNmae);
                ObjectDelete(ChartID(), ACEM_SYNC_LINE_TIME_LABEL);
                ObjectDelete(ChartID(), ACEM_PARAM_TIMEFRAME);
            }
            break;
        case REASON_PROGRAM:
        case REASON_CHARTCLOSE:
        case REASON_CLOSE:
        case REASON_RECOMPILE:
        case REASON_CHARTCHANGE:
        case REASON_PARAMETERS:
        case REASON_ACCOUNT:
        case REASON_TEMPLATE:
        case REASON_INITFAILED:
        default:
            {
            }
            break;
    }
    ChartRedraw(ChartID());
debugPrint(__FUNCTION__ + " end");
}
bool CAcemSyncChartPos::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    if (sparam == m_strHideLineNmae) {
        syncChart();
    }
    if (sparam == ACEM_SYNC_LINE_TIME_LABEL) {
        string labelText;
        labelText = ObjectGetString(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_TEXT);
        datetime currnetTime = (datetime)ObjectGetInteger(ChartID(), m_strHideLineNmae, OBJPROP_TIME, 0);
        datetime inputTime = StringToTime(labelText);
        if (currnetTime != inputTime) {
            if (setBaseLineTime(inputTime)) {
                return false;
            }
        }
        ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_SELECTED, false);
        
        redrawAll();
    }

    return true;
}

bool CAcemSyncChartPos::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    if (sparam == m_strShowLineName) {
        int posX = (int)ObjectGetInteger(ChartID(), m_strShowLineName, OBJPROP_XDISTANCE);
        if(!shiftOnGridX(ChartID(), posX, posX)) {
        }

        if (moveBaseLine(posX)) {
            ObjectSetInteger(ChartID(), m_strShowLineName, OBJPROP_SELECTED, false);
            syncChart();
            redrawAll();
        }
    }
    
    return true;
}

bool CAcemSyncChartPos::OnChartChange(int id, long lparam, double dparam, string sparam)
{
debugPrint(__FUNCTION__ + " Start");
    // リサイズ
    int width = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    if (width != m_wndWidth || height != m_wndHeight) {
debugPrint(__FUNCTION__ + " Resize start");
        m_wndWidth = width;
        m_wndHeight = height;

        m_syncLineCnavas.resize(false);
        m_syncLineCnavas.fill(ColorToARGB(ACEM_SYNC_POS_BASE_LINE_COLOR, 255));

        if (shiftBaseLineOnGrid()) {
            syncChart();
            redrawAll();
        } else {
            m_bFailedSyncChart = false;
        }

debugPrint(__FUNCTION__ + " Resize end");
        return true;
    }

    // 時間軸変更
    ENUM_TIMEFRAMES timeFrame = ChartPeriod(ChartID());
    if (timeFrame != m_timeFrame) {
debugPrint(__FUNCTION__ + " TimeFrame start");
//        m_timeFrame = timeFrame;
        setParamText(ChartID(), ACEM_PARAM_TIMEFRAME, m_timeFrame);
        if (shiftBaseLineOnGrid()) {
            redrawAll();
            m_timeFrame = timeFrame;
        }
debugPrint(__FUNCTION__ + " TimeFrame end");
        return true;
    }

    // 拡大率変更
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    if (m_chartScale != chartScale) {
debugPrint(__FUNCTION__ + " Scale start");
        m_chartScale = chartScale;
        if (shiftBaseLineOnGrid()) {
            syncChart();
            redrawAll();
        } else {
            m_bFailedSyncChart = false;
        }
debugPrint(__FUNCTION__ + " Scale end");
        return true;
    }
    
    // スクロール
    int leftIndex = WindowFirstVisibleBar();
    if (m_leftIndex != leftIndex && ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
debugPrint(__FUNCTION__ + " Scrolle start");
        m_leftIndex = leftIndex;
        int posX = m_syncLineCnavas.getPosX();
        datetime newTime; 
        if (!convPosXToTime(ChartID(), posX, false, newTime)) {
            return true;
        }
        if (setBaseLineTime(newTime)) {
            syncChart();
            redrawAll();
        } else {
            m_bFailedSyncChart = false;
        }
debugPrint(__FUNCTION__ + " Scrolle end");
        return true;
    }
    
debugPrint(__FUNCTION__ + " end");
    return true;
}

bool CAcemSyncChartPos::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    if (m_bFailedMoveBaseLine) {
    }

    if (m_bFailedMoveBaseLine) {
        if (moveBaseLine(m_posX)) {
            m_bFailedMoveBaseLine = false;
            m_isNeedRefresh = true;
        }
    }
    
    if (m_bFailedSyncChart) {
        if (syncChart()) {
            m_bFailedSyncChart = false;
            m_isNeedRefresh = true;
        }
    }

    if (m_isNeedRefresh) {
        redrawAll();
        m_isNeedRefresh = false;
    }
    
    return true;
}
bool CAcemSyncChartPos::OnCustomEvent(int id, long lparam, double dparam, string sparam)
{
debugPrint(__FUNCTION__ + " start");
    if (ACEM_CMD_SYNC_CHART_POS == sparam) {
        if (!ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
            syncChart();
            redrawAll();
        }
    }

debugPrint(__FUNCTION__ + " end");
    return true;
}

void CAcemSyncChartPos::setHideLineProp()
{
    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_READONLY, false);
    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_HIDDEN, true);
    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_SELECTABLE, true);
    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_COLOR, 0x00FFFFFF);
    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_WIDTH, 1);

    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
}

void CAcemSyncChartPos::redrawAll()
{
    m_hideRightCanvas.Update();
    m_syncLineCnavas.Update();
    ChartRedraw();
}

bool CAcemSyncChartPos::getBaseTime(datetime& baseTime)
{
debugPrint(__FUNCTION__ + " Start");
    long targetId;
    for (targetId = ChartFirst(); targetId != -1; targetId = ChartNext(targetId)) {
        if (!isSyncChart(targetId)) {
            continue;
        }
        baseTime = (datetime)ObjectGetInteger(targetId, ACEM_SYNC_HIDE_BASE_LINE_NAME, OBJPROP_TIME, 0);

        if (baseTime != 0) {
            break;
        }
    }

    if (baseTime == 0) {
        if (ObjectFind(ChartID(), ACEM_SYNC_HIDE_BASE_LINE_NAME) < 0) {
            if (ObjectGetInteger(ChartID(), ACEM_SYNC_HIDE_BASE_LINE_NAME, OBJPROP_TIME, 0, baseTime)) {
                return true;
            }
        } 
    }

    if (baseTime == 0) {
        if (m_syncLineCnavas.getCurrentTime(baseTime)) {
            return true;
        }
    }
    
    if (baseTime == 0) {
       return false;
    }

    return true;
}

bool CAcemSyncChartPos::syncChart()
{
debugPrint(__FUNCTION__ + " Start");
    int basePosX = m_syncLineCnavas.getPosX();
    int basePosIndex; 
    if (!convPosXToIndex(ChartID(), basePosX, basePosIndex)) {
debugPrint(__FUNCTION__ + " false1 End");
        m_bFailedSyncChart = true;
        return false;
    }

    datetime baseTime = (datetime)ObjectGetInteger(ChartID(), ACEM_SYNC_HIDE_BASE_LINE_NAME, OBJPROP_TIME, 0);

    setBaseTimeLabelString();
    int baseTimeIndex;
    if (!convTimeToIndex(ChartID(), baseTime, baseTimeIndex)) {
debugPrint(__FUNCTION__ + " false2 End");
        m_bFailedSyncChart = true;
        return false;
    }

    int shift = basePosIndex - baseTimeIndex;

    ChartNavigate(ChartID(), CHART_CURRENT_POS, shift);
debugPrint(__FUNCTION__ + " true End");
    m_bFailedSyncChart = false;
    return true;
}

bool CAcemSyncChartPos::isSyncChart(long targetId)
{
debugPrint(__FUNCTION__ + " Start");
debugPrint(__FUNCTION__ + " targetId: " + IntegerToString(targetId));
    if (targetId == ChartID()) {
debugPrint(__FUNCTION__ + " targetId End");
        return false;
    }

    // 異なる通貨ペアは対象外
    if (ChartSymbol(ChartID()) != ChartSymbol(targetId)) {
debugPrint(__FUNCTION__ + " ChartSymbol End");
        return false;
    }

    // 基準線がないのは対象外
    if (ObjectFind(targetId, ACEM_SYNC_HIDE_BASE_LINE_NAME) < 0) {
debugPrint(__FUNCTION__ + " ObjectFind End");
        return false;
    }
debugPrint(__FUNCTION__ + " true End");
    return true;
}

int CAcemSyncChartPos::getHideWidth()
{
    int posX = (int)ObjectGetInteger(ChartID(), m_strShowLineName, OBJPROP_XDISTANCE);
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = int(1 << chartScale);
    int hideWidth = m_wndWidth - posX - (step / 2) - 2;

    return hideWidth;
}

bool CAcemSyncChartPos::shiftBaseLineOnGrid()
{
debugPrint(__FUNCTION__ + " Start");
    int posX = (int)ObjectGetInteger(ChartID(), m_strShowLineName, OBJPROP_XDISTANCE);
    if (!moveBaseLine(posX)) {
        return false;
    }
    return true;
debugPrint(__FUNCTION__ + " End");
}

bool CAcemSyncChartPos::moveBaseLine(int posX)
{
debugPrint(__FUNCTION__ + " Start");
debugPrint(__FUNCTION__ + " posX: " + IntegerToString(posX));
    m_posX = posX;
    int width = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    if (posX >= width) {
        posX = width - 10;
    }
    if (posX <= 0) {
        posX = 10;
    }

    if (!shiftOnGridX(ChartID(), posX, posX)) {
debugPrint(__FUNCTION__ + " End : shiftOnGridX false");
        m_bFailedMoveBaseLine = true;
        return false;
    }

    m_posX = posX;
    m_syncLineCnavas.move(posX);
    moveSupportObject();
debugPrint(__FUNCTION__ + " true End");

    m_bFailedMoveBaseLine = false;
    return true;
}

void CAcemSyncChartPos::moveSupportObject()
{
    if (IS_HIDE_RIGHT) {
        int hideWidth = getHideWidth();
        m_hideRightCanvas.resize(hideWidth, false);
    }
    int posX = (int)ObjectGetInteger(ChartID(), m_strShowLineName, OBJPROP_XDISTANCE);
    ObjectSetInteger(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_XDISTANCE, posX - 3);                // X座標
}

string CAcemSyncChartPos::getBaseTimeString()
{
    datetime baseTime = (datetime)ObjectGetInteger(ChartID(), ACEM_SYNC_HIDE_BASE_LINE_NAME, OBJPROP_TIME, 0);
    string baseTimeString = TimeToString(baseTime);
    
    return baseTimeString;
}

void CAcemSyncChartPos::setBaseTimeLabelString()
{
    string baseTimeString = getBaseTimeString();
    ObjectSetString(ChartID(), ACEM_SYNC_LINE_TIME_LABEL, OBJPROP_TEXT, baseTimeString);
}

bool CAcemSyncChartPos::setBaseLineTime(datetime newTime)
{
debugPrint(__FUNCTION__ + " Start");
debugPrint(__FUNCTION__ + " newTime: " + TimeToString(newTime));
    ObjectSetInteger(ChartID(), m_strHideLineNmae, OBJPROP_TIME, newTime);
    setBaseTimeLabelString();
    if (!syncChart()) {
debugPrint(__FUNCTION__ + " false End");
        return false;
    }

    syncOtherChart(newTime);
    
debugPrint(__FUNCTION__ + " true End");
    return true;
}

void CAcemSyncChartPos::syncOtherChart(datetime newTime)
{
debugPrint(__FUNCTION__ + " Start");
    if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
        long targetId;
        for (targetId = ChartFirst(); targetId != -1; targetId = ChartNext(targetId)) {
            if (isSyncChart(targetId)) {
                ObjectSetInteger(targetId, m_strHideLineNmae, OBJPROP_TIME, newTime);
                EventChartCustom(targetId, 0, 0, 0.0, ACEM_CMD_SYNC_CHART_POS);
            }
        }
    }
debugPrint(__FUNCTION__ + " End");
}
