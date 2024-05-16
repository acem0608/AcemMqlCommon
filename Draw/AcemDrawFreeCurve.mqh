//+------------------------------------------------------------------+
//|                                            AcemDrawFreeCurve.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

//#define _ACEM_DEBUG

#include <ChartObjects/ChartObjectsLines.mqh>
#include <Arrays/List.mqh>
#include <Acem/Common/AcemBase.mqh>
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Common/AcemUtility.mqh>
#include <Acem/Draw/AcemFreeCurveCanvas.mqh>
#include <Acem/Draw/AcemFreeCurveData.mqh>
#include <Acem/Draw/AcemFreeCurveIcon.mqh>

#define ACEM_FREE_CUREVE_PARM_MODE "AcemFreeCurveParm_Mode"
#define ACEM_FREE_CURVE_INPUT_KEY 0x04

input color ACEM_DRAW_FREE_CURVE_LINE_COLOR1 = 0x0000FFFF;        //色1
input eInputKeyCode KEY_COLOR_1 = ACEM_KEYCODE_Y;            //色1キー
input color ACEM_DRAW_FREE_CURVE_LINE_COLOR2 = 0x0000FF;        //色2
input eInputKeyCode KEY_COLOR_2 = ACEM_KEYCODE_U;            //色2キー
input color ACEM_DRAW_FREE_CURVE_LINE_COLOR3 = 0x00FF0000;        //色3
input eInputKeyCode KEY_COLOR_3 = ACEM_KEYCODE_I;            //色3キー
input eInputKeyCode KEY_COLOR_CHANGE = ACEM_KEYCODE_Q;          //色変更キー
input eLineWidth ACEM_DRAW_RFRE_CURVE_LINE_WIDTH = LINE_WIDTH_3;//線幅
input eInputKeyCode KEY_MODE_DELETE = ACEM_KEYCODE_E;            //削除モード切り替えキー
input bool IS_QUIQ_DELETE = true;//削除モードでライン選択で即削除する
input eInputKeyCode KEY_ALL_DELETE = ACEM_KEYCODE_A;             //一括削除キー
input eInputKeyCode KEY_MODE_SPLIT = ACEM_KEYCODE_S;          //分割モード切り替えキー
input eInputKeyCode KEY_MODE_VISIVBLE = ACEM_KEYCODE_S;          //表示/非表示切り替えキー
input bool IS_FREECURVE_AUTO_SPLIT = true;//自動分割
input int FREECURVE_AUTO_SPLIT_DISTANCE = 50;//自動分割する距離（ピクセル）
input bool IS_TOUCH_MODE = true;//タッチペンモード
input eInputKeyCode KEY_TOUCH_INPUT = ACEM_KEYCODE_W;//入力切り替え

enum eIndexSplitPrefix
{
    Index_Prefix,
    Index_ChartId,
    Index_GroupIndex,
    Index_LineIndex
};

class CAcemDrawFreeCurve : public CAcemBase
{
private:
    CList m_listLine;
    CAcemFreeCurveData* m_pCurrentLine;
    CAcemFreeCurveCanvas m_canvas;
    CAcemFreeCurveIcon m_icon;

    color m_lineColor;
    int m_lineWidth;
    eDrawFreeCurveMode m_mode;
    bool m_bTouchDrawing;
    int m_colorNum;

public:
    CAcemDrawFreeCurve();
    ~CAcemDrawFreeCurve();

    bool init();
    void deinit(const int reason);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectCreate(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDelete(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectClick(int id, long lparam, double dparam, string sparam);
#ifdef __MQL5__
    virtual bool OnCustomEvent(int id, long lparam, double dparam, string sparam);
#endif

    bool convWindowsPosToChartPos(long id, int x, int y, datetime& time, double& price);
    bool convChartPosToWindowsPos(long id, datetime time, double price, int& x, int& y);
    void CAcemDrawFreeCurve::getWindowPos(CAcemChartPoint* pPoint, int& x, int& y);

    bool drawLine(CAcemChartPoint* pStPoint, CAcemChartPoint* pEdPoint, int lineWidth, color lineColor, bool bUpdate = false);
    bool redraw();
    string createLinePrefix(int groupIndex);
    string createLineName(string prefix, int lineIndex);
    string createLineName(int lineIndex, int groupIndex);
    bool addLineData(CAcemChartPoint* pStPoint, CAcemChartPoint* pEdPoint, int lineWidth, color lineColor, string lineName);
    void readLineData();
    bool isExsitLine(int groupIndex, int lineIndex);
    void setAllLineVisibility(bool bVisble);
    void rebuildLineData();
    void setMode(eDrawFreeCurveMode mode);
    void finishInput();

};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemDrawFreeCurve::CAcemDrawFreeCurve() : m_canvas(ACEM_FREE_CUREVE_CANVAS_NAME), m_pCurrentLine(NULL), m_icon(ACEM_FREE_CUREVE_ICON_NAME)
{
    m_listLine.FreeMode(true);
    m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR1;
    m_lineWidth = (int)ACEM_DRAW_RFRE_CURVE_LINE_WIDTH;
    m_mode = FreeCurve_InputMode;
    m_bTouchDrawing = false;
    m_colorNum = 1;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemDrawFreeCurve::~CAcemDrawFreeCurve()
{
}
//+------------------------------------------------------------------+

bool CAcemDrawFreeCurve::init()
{
//debugPrint(__FUNCTION__ + " Start");
    m_canvas.init();
    m_icon.init();
    m_pCurrentLine = NULL;
    m_listLine.Clear();

    readLineData();

    eDrawFreeCurveMode mode = FreeCurve_InputMode;
    if (IS_TOUCH_MODE) {
        mode = FreeCurve_TouchMode;
        ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
    }

    if (ObjectFind(ChartID(), ACEM_FREE_CUREVE_PARM_MODE) >= 0) {
        string strMode = ObjectGetString(ChartID(), ACEM_FREE_CUREVE_PARM_MODE, OBJPROP_TEXT);
        mode = (eDrawFreeCurveMode)IntegerToString(int(strMode));
        if (IS_TOUCH_MODE) {
            if (mode == FreeCurve_InputMode) {
                mode = FreeCurve_TouchMode;
            }
        } else {
            if (mode == FreeCurve_TouchMode) {
                mode = FreeCurve_InputMode;
            }
        }
    }
    setMode(mode);

    rebuildObject();

    redraw();
//debugPrint(__FUNCTION__ + " End");
    return true;
}

void CAcemDrawFreeCurve::deinit(const int reason)
{
    m_canvas.deinit(reason);
    m_icon.deinit(reason);
    if (reason == REASON_REMOVE) {
        ObjectsDeleteAll(ChartID(), ACEM_FREECURVE_DATA_PREFIX);
        ObjectDelete(ChartID(), ACEM_FREE_CUREVE_PARM_MODE);
    }
    ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
}

bool CAcemDrawFreeCurve::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
//debugPrint(__FUNCTION__ + " Start");
    int x = (int)lparam;
    int y = (int)dparam;
    uint flag = (uint)sparam;
    bool bInputting = false;
    if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP) && m_mode == FreeCurve_InputMode) {
        if (IS_TOUCH_MODE || ((flag & ACEM_FREE_CURVE_INPUT_KEY) == ACEM_FREE_CURVE_INPUT_KEY)) {
            bInputting = true;
        }
    }
    if (bInputting) {
        datetime time;
        double price;

        if (!convWindowsPosToChartPos(ChartID(), x, y, time, price)) {
            finishInput();
            return true;
        }

        CAcemChartPoint* pChartPoint = new CAcemChartPoint(time, price);
        CAcemChartPoint* pLastPoint = NULL;

        if (m_pCurrentLine == NULL) {
            m_pCurrentLine = new CAcemFreeCurveData();
            if (m_pCurrentLine == NULL) {
                delete pChartPoint;
                return false;
            }
            m_pCurrentLine.setColor(m_lineColor);
            m_pCurrentLine.setLineWidth(m_lineWidth);
            string prefix;
            prefix = createLinePrefix(m_listLine.Total());
            m_pCurrentLine.setLineDataPrefix(prefix);
            m_listLine.Add(m_pCurrentLine);
            //ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
        } else {
            pLastPoint = m_pCurrentLine.GetLastNode();
            if (pLastPoint.isEqual(pChartPoint)) {
                delete pChartPoint;
                return true;
            }
            if (IS_FREECURVE_AUTO_SPLIT) {
                int lastX;
                int lastY;
                datetime lastTime;
                double lastPrice;
                pLastPoint.getTimePrice(lastTime, lastPrice);
                if (!convChartPosToWindowsPos(ChartID(), lastTime, lastPrice, lastX, lastY)) {
                    delete pChartPoint;
                    return false;
                }
                if (MathAbs(x - lastX) > FREECURVE_AUTO_SPLIT_DISTANCE ||
                    MathAbs(y - lastY) > FREECURVE_AUTO_SPLIT_DISTANCE ||
                    ((x - lastX) * (x - lastX) + (y - lastY) * (y - lastY)) > (FREECURVE_AUTO_SPLIT_DISTANCE * FREECURVE_AUTO_SPLIT_DISTANCE)) {
                        if (m_pCurrentLine.Total() == 1) {
                            m_pCurrentLine.Delete(0);
                        } else {
                            m_pCurrentLine = new CAcemFreeCurveData();
                            if (m_pCurrentLine == NULL) {
                                delete pChartPoint;
                                return false;
                            }
                            m_pCurrentLine.setColor(m_lineColor);
                            m_pCurrentLine.setLineWidth(m_lineWidth);
                            string prefix;
                            prefix = createLinePrefix(m_listLine.Total());
                            m_pCurrentLine.setLineDataPrefix(prefix);
                            m_listLine.Add(m_pCurrentLine);
                        }
                        pLastPoint = NULL;
                }
            }
        }

        m_pCurrentLine.Add(pChartPoint);

        if (pLastPoint != NULL) {
            int lineWidth = m_pCurrentLine.getLineWidth();
            color lineColor = m_pCurrentLine.getLineColor();
            string prefix = m_pCurrentLine.getLineDataPrefix();
            string lineName = createLineName(prefix, m_pCurrentLine.Total() - 2); // 0始まりにするために2を引く
            addLineData(pLastPoint, pChartPoint, lineWidth, lineColor, lineName);
            drawLine(pLastPoint, pChartPoint, lineWidth, lineColor, true);
        }
    } else {
        if (m_pCurrentLine != NULL) {
            finishInput();
        }
    }

    m_icon.move(x, y);
    ChartRedraw(ChartID());

//debugPrint(__FUNCTION__ + " End");
    return true;
}

bool CAcemDrawFreeCurve::OnChartChange(int id, long lparam, double dparam, string sparam)
{
//debugPrint(__FUNCTION__ + " Start");
    m_canvas.resize();
    switch (m_mode) {
        case FreeCurve_InputMode:
        case FreeCurve_TouchMode:
            {
                redraw();
            }
            break;
        case FreeCurve_DelMode:
            {
                m_canvas.Erase();
                m_canvas.Update();
            }
            break;
    }
//debugPrint(__FUNCTION__ + " End");
    return true;
}

bool CAcemDrawFreeCurve::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (lparam == KEY_MODE_DELETE) {
        switch (m_mode) {
            case FreeCurve_InputMode:
            case FreeCurve_InvisibleMode:
            case FreeCurve_TouchMode:
                {
                    if (m_listLine.Total() == 0) {
                        break;
                    }
                    setMode(FreeCurve_DelMode);

                    setAllLineVisibility(true);

                    m_canvas.Update();
                    finishInput();
                    ChartRedraw();
                }
                break;
            case FreeCurve_DelMode:
                {
                    rebuildLineData();
                    setAllLineVisibility(false);
                    setMode(FreeCurve_InputMode);
                    ChartRedraw();
                    redraw();
                }
                break;
        }
    }

    if (lparam == KEY_ALL_DELETE) {
        if (m_mode == FreeCurve_DelMode) {
            setMode(FreeCurve_DeletingMode);
            m_listLine.Clear();
            finishInput();
            ObjectsDeleteAll(ChartID(), ACEM_FREECURVE_DATA_PREFIX);
            setMode(FreeCurve_InputMode);
            ChartRedraw();
            redraw();
        }
    }

    if (lparam == KEY_MODE_VISIVBLE) {
        if (m_mode == FreeCurve_InvisibleMode) {
            setMode(FreeCurve_InputMode);
        } else if (m_mode == FreeCurve_InputMode || m_mode == FreeCurve_TouchMode) {
            setMode(FreeCurve_InvisibleMode);
        }

        redraw();
    }

    if (lparam == KEY_MODE_SPLIT) {
        switch (m_mode) {
            case FreeCurve_DelMode:
                {
                    setMode(FreeCurve_SplitMode);
                }
                break;
            case FreeCurve_SplitMode:
                {
                    setMode(FreeCurve_DelMode);
                }
                break;
            default:
                break;
        }
    }

    if (lparam == KEY_TOUCH_INPUT && IS_TOUCH_MODE) {
        switch (m_mode) {
            case FreeCurve_InputMode:
                {
                    setMode(FreeCurve_TouchMode);
                    finishInput();
                }
                break;
            case FreeCurve_TouchMode:
                {
                    setMode(FreeCurve_InputMode);
                }
                break;
            case FreeCurve_DelMode:
                {
                    rebuildLineData();
                    setAllLineVisibility(false);
                    m_mode = FreeCurve_TouchMode;
                    setMode(FreeCurve_InputMode);
                    ChartRedraw();
                    redraw();
                }
                break;
            default:
                break;
        }
        ChartRedraw();
        redraw();
    }

    if (lparam == VK_CONTROL) {
        if (m_pCurrentLine != NULL) {
            finishInput();
        }
    }

    if (lparam == KEY_COLOR_1 && m_lineColor != ACEM_DRAW_FREE_CURVE_LINE_COLOR1) {
        m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR1;
        m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
        finishInput();
    }
    if (lparam == KEY_COLOR_2 && m_lineColor != ACEM_DRAW_FREE_CURVE_LINE_COLOR2) {
        m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR2;
        m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
        finishInput();
    }
    if (lparam == KEY_COLOR_3 && m_lineColor != ACEM_DRAW_FREE_CURVE_LINE_COLOR3) {
        m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR3;
        m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
        finishInput();
    }

    if (lparam == KEY_COLOR_CHANGE) {
        m_colorNum++;
        if (m_colorNum >= 4) {
            m_colorNum = 1;
        }
        switch (m_colorNum) {
            case 1:
                {
                    m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR1;
                    m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
                    finishInput();
                }
                break;
            case 2:
                {
                    m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR2;
                    m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
                    finishInput();
                }
                break;
            case 3:
                {
                    m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR3;
                    m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
                    finishInput();
                }
                break;
        }
    }
    return true;
}

bool CAcemDrawFreeCurve::OnObjectCreate(int id, long lparam, double dparam, string sparam)
{
/*
    int z_order = (int)ObjectGetInteger(ChartID(), sparam, OBJPROP_ZORDER);
    if (z_order == 0) {
        ObjectSetInteger(ChartID(), sparam, OBJPROP_ZORDER, 10);
    }
*/
    return true;
}

bool CAcemDrawFreeCurve::OnObjectDelete(int id, long lparam, double dparam, string sparam)
{
    if (sparam == ACEM_FREE_CUREVE_CANVAS_NAME) {
        if (ObjectCreate(ChartID(), ACEM_FREE_CUREVE_CANVAS_NAME, OBJ_BITMAP_LABEL, 0, 0, 0)) {
            string rcname;
            if (getParamString(ChartID(), ACEM_PARAM_FREE_CUREVE_CANVAS_RCNAME, rcname)) {
                if (ObjectSetString(ChartID(), ACEM_FREE_CUREVE_CANVAS_NAME, OBJPROP_BMPFILE, rcname)) {
                    m_canvas.clearParam();
                    if (m_canvas.init()) {
                        m_canvas.resize();
                        m_canvas.Update(true);
                        rebuildObject();
                        ChartRedraw(ChartID());
                    }
                }
            } else {
                m_canvas.init();
            }
        }
    }

    string splitString[];
    int splitNum = StringSplit(sparam, ' ', splitString);
    if (splitString[Index_Prefix] == ACEM_FREECURVE_DATA_PREFIX && m_mode != FreeCurve_DeletingMode) {
        bool bDelete = false;
        CAcemFreeCurveData* pCurveData;
        string dataPrefix;
        int groupIndex = (int)StringToInteger(splitString[Index_GroupIndex]);
        string delPrefix = createLinePrefix(groupIndex);
        for (pCurveData = m_listLine.GetFirstNode(); pCurveData != NULL; pCurveData = m_listLine.GetNextNode()) {
            dataPrefix = pCurveData.getLineDataPrefix();
            if (dataPrefix == delPrefix) {
                m_listLine.DeleteCurrent();
                bDelete = true;
                break;
            }
        }

        if (bDelete) {
            setMode(FreeCurve_DeletingMode);
            ObjectsDeleteAll(ChartID(), delPrefix);

            setMode(FreeCurve_DelMode);
            if (m_listLine.Total() == 0) {
                setMode(FreeCurve_InputMode);
            }
            ChartRedraw();
        }
    }

    return true;
}

bool CAcemDrawFreeCurve::OnObjectClick(int id, long lparam, double dparam, string sparam)
{
    string splitString[];
    int splitNum = StringSplit(sparam, ' ', splitString);
    if (Index_LineIndex + 1 != splitNum) {
        return true;
    }

    if (splitString[Index_Prefix] != ACEM_FREECURVE_DATA_PREFIX) {
        return true;
    }

    if (m_mode == FreeCurve_SplitMode) {
        int lineIndex = (int)StringToInteger(splitString[Index_LineIndex]);
        if (lineIndex == 0) {
            ObjectSetInteger(ChartID(), sparam, OBJPROP_SELECTED, false);
            return true;
        }

        int groupIndex = (int)StringToInteger(splitString[Index_GroupIndex]);
        CAcemFreeCurveData* pCurveData = m_listLine.GetNodeAtIndex(groupIndex);
        if (pCurveData == NULL) {
            ObjectSetInteger(ChartID(), sparam, OBJPROP_SELECTED, false);
            return true;
        }

        int maxIndex = pCurveData.Total() - 2;
        if (lineIndex == maxIndex) {
            ObjectSetInteger(ChartID(), sparam, OBJPROP_SELECTED, false);
            return true;
        }

        ObjectSetInteger(ChartID(), sparam, OBJPROP_SELECTED, false);

        CAcemChartPoint* pPoint = pCurveData.GetNodeAtIndex(lineIndex);
        datetime time;
        double price;
        pPoint.getTimePrice(time, price);
        pPoint = new CAcemChartPoint(time, price);

        CAcemFreeCurveData* pSplitCurve = new CAcemFreeCurveData();
        pSplitCurve.setColor(pCurveData.getLineColor());
        pSplitCurve.setLineWidth(pCurveData.getLineWidth());
        string newPrefix = createLinePrefix(m_listLine.Total());
        pSplitCurve.setLineDataPrefix(newPrefix);
        pSplitCurve.Add(pPoint);
        pCurveData.GetNextNode();
        int total = pCurveData.Total();
        while (pCurveData.Total() > lineIndex + 1) {
            pPoint = pCurveData.DetachCurrent();
            pSplitCurve.Add(pPoint);
        }
        m_listLine.Add(pSplitCurve);

        int newIndex = 0;
        string oldPrefix = pCurveData.getLineDataPrefix();
        string oldName;
        string newName;
        setMode(FreeCurve_DeletingMode);
        for (newIndex = 0; newIndex + lineIndex < total - 1; newIndex++) {
            oldName = createLineName(oldPrefix, lineIndex + newIndex);
            if (ObjectFind(ChartID(), oldName) < 0) {
                break;
            }
            newName = createLineName(newPrefix, newIndex);
            ObjectSetString(ChartID(), oldName, OBJPROP_NAME, newName);
        }

        setMode(FreeCurve_DelMode);
    } else if (m_mode == FreeCurve_DelMode) {
        if (IS_QUIQ_DELETE) {
            ObjectDelete(ChartID(), sparam);
        }
    }

    return true;
}

#ifdef __MQL5__
bool CAcemDrawFreeCurve::OnCustomEvent(int id, long lparam, double dparam, string sparam)
{
    if (ACEM_CMD_SYNC_CHART_POS == sparam) {
        if (!ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
            redraw();
        }
    }

    return true;
}
#endif

bool CAcemDrawFreeCurve::convWindowsPosToChartPos(long id, int x, int y, datetime& time, double& price)
{
    int subWindow = 0;
    if (!ChartXYToTimePrice(ChartID(), x, y, subWindow, time, price)) {
        return false;
    }

    int leftIndex = (int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
    datetime leftTime = iTime(NULL, 0, leftIndex);
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = int(1 << chartScale);
    int stepNum = int(x / step);
    int periodSec = PeriodSeconds(PERIOD_CURRENT);
    int convTimeIndex;
    int mod;

    if (leftIndex < stepNum) {
        convTimeIndex = 0;
        mod = x - (leftIndex * step);
    } else {
        convTimeIndex = leftIndex - stepNum;
        mod = x - (stepNum * step);
    }
    datetime baseTime = iTime(NULL, 0, convTimeIndex);
    convTimeIndex = leftIndex - stepNum;
    datetime modTime = datetime(mod * periodSec / step);
    datetime convTime = baseTime + modTime;
    time = convTime;

    return true;
}

bool CAcemDrawFreeCurve::convChartPosToWindowsPos(long id, datetime time, double price, int& x, int& y)
{
    int subWindow = 0;
    ChartTimePriceToXY(ChartID(), subWindow, time, price, x, y);

    int leftIndex = (int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
    int nearIndex = iBarShift(NULL, 0, time, false);
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = int(1 << chartScale);
    int stepNum = leftIndex - nearIndex;
    datetime nearTime = iTime(NULL, 0, nearIndex);
    int periodSec = PeriodSeconds(PERIOD_CURRENT);
    datetime diffTime = time - nearTime;
    double diffStepNum = (double)(diffTime / (double)periodSec);
    int diffX = (int)MathRound(diffStepNum * step);
    int convX = (stepNum * step) + diffX;

    x = convX;

    return true;
}

bool CAcemDrawFreeCurve::drawLine(CAcemChartPoint* pStPoint, CAcemChartPoint* pEdPoint, int lineWidth, color lineColor, bool bUpdate)
{
    int x1;
    int y1;
    int x2;
    int y2;

    getWindowPos(pStPoint, x1, y1);
    getWindowPos(pEdPoint, x2, y2);

    m_canvas.drawLine(x1, y1, x2, y2, lineWidth, lineColor, bUpdate);

    return true;
}

void CAcemDrawFreeCurve::getWindowPos(CAcemChartPoint* pPoint, int& x, int& y)
{
    double price;
    datetime time;

    pPoint.getTimePrice(time, price);
    convChartPosToWindowsPos(ChartID(), time, price, x, y);
}

bool CAcemDrawFreeCurve::redraw(void)
{
//debugPrint(__FUNCTION__ + " Start");
    m_canvas.Erase();

    switch (m_mode) {
        case FreeCurve_InputMode:
        case FreeCurve_TouchMode:
            {
                CAcemFreeCurveData* pCurveData;
                int lineWidth;
                color lineColor;

                for (pCurveData = m_listLine.GetFirstNode(); pCurveData != NULL; pCurveData = m_listLine.GetNextNode()) {
                    if (pCurveData.Total() < 2) {
                        continue;
                    }
                    lineWidth = pCurveData.getLineWidth();
                    lineColor = pCurveData.getLineColor();
                    CAcemChartPoint* pStPoint = pCurveData.GetFirstNode();
                    CAcemChartPoint* pEdPoint;
                    for (pEdPoint = pCurveData.GetNextNode(); pEdPoint != NULL; pEdPoint = pCurveData.GetNextNode()) {
                        drawLine(pStPoint, pEdPoint, lineWidth, lineColor);
                        pStPoint = pEdPoint;
                    }
                }
            }
            break;
        case FreeCurve_DelMode:
        case FreeCurve_InvisibleMode:
            {
            }
            break;
    }
    m_canvas.Update();
//debugPrint(__FUNCTION__ + " End");
    return true;
}

bool CAcemDrawFreeCurve::isExsitLine(int groupIndex, int lineIndex)
{
    string lineName = createLineName(groupIndex, lineIndex);
    if (ObjectFind(ChartID(), lineName) < 0) {
        return false;
    }

    return true;
}

string CAcemDrawFreeCurve::createLinePrefix(int groupIndex)
{
    string prefix = ACEM_FREECURVE_DATA_PREFIX + " " + IntegerToString(ChartID()) + " " + IntegerToString(groupIndex, 3, '0');

    return prefix;
}

string CAcemDrawFreeCurve::createLineName(int groupIndex, int lineIndex)
{
    string prefix;
    prefix = createLinePrefix(groupIndex);
    string lineName = createLineName(prefix, lineIndex);

    return lineName;
}

string CAcemDrawFreeCurve::createLineName(string prefix, int lineIndex)
{
    string lineName = prefix + " " + IntegerToString(lineIndex, 4, '0');

    return lineName;
}

bool CAcemDrawFreeCurve::addLineData(CAcemChartPoint* pStPoint, CAcemChartPoint* pEdPoint, int lineWidth, color lineColor, string lineName)
{
    double stPrice;
    datetime stTime;
    double edPrice;
    datetime edTime;

    pStPoint.getTimePrice(stTime, stPrice);
    pEdPoint.getTimePrice(edTime, edPrice);

    int subWindow = 0;
    CChartObjectTrend tLine;
    if (tLine.Create(ChartID(), lineName, subWindow, stTime, stPrice, edTime, edPrice)) {
        ObjectSetInteger(ChartID(), lineName, OBJPROP_COLOR, lineColor);
        //        ObjectSetInteger(ChartID(), lineName, OBJPROP_COLOR, 0x0000ffff);
        ObjectSetInteger(ChartID(), lineName, OBJPROP_WIDTH, lineWidth);
        //        ObjectSetInteger(ChartID(), lineName, OBJPROP_BACK, TLINE_BACK);
        ObjectSetInteger(ChartID(), lineName, OBJPROP_RAY_RIGHT, 0);
        ObjectSetInteger(ChartID(), lineName, OBJPROP_SELECTABLE, true);
        ObjectSetInteger(ChartID(), lineName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
#ifdef __MQL5__
        ObjectSetInteger(ChartID(), lineName, OBJPROP_RAY_LEFT, 0);
#endif
        tLine.Detach();
    }

    return true;
}

void CAcemDrawFreeCurve::readLineData()
{
    int groupIndex = 0;
    int lineIndex = 0;

    int lineWidth;
    color lineColor;
    string prefix;
    datetime time;
    double price;
    string lineName;
    CAcemFreeCurveData* pFreeCurveData;
    CAcemChartPoint* pChartPoint;
    for (groupIndex = 0, lineIndex = 0; isExsitLine(groupIndex, lineIndex); groupIndex++, lineIndex = 0) {
        prefix = createLinePrefix(groupIndex);
        lineName = createLineName(prefix, lineIndex);

        pFreeCurveData = new CAcemFreeCurveData();
        pFreeCurveData.setLineDataPrefix(prefix);
        lineColor = (color)ObjectGetInteger(ChartID(), lineName, OBJPROP_COLOR);
        pFreeCurveData.setColor(lineColor);
        lineWidth = (int)ObjectGetInteger(ChartID(), lineName, OBJPROP_WIDTH);
        pFreeCurveData.setLineWidth(lineWidth);

        m_listLine.Add(pFreeCurveData);

        // 始点
        price = ObjectGetDouble(ChartID(), lineName, OBJPROP_PRICE, 0);
        time = (datetime)ObjectGetInteger(ChartID(), lineName, OBJPROP_TIME, 0);
        pChartPoint = new CAcemChartPoint(time, price);
        pFreeCurveData.Add(pChartPoint);

        // 終点
        price = ObjectGetDouble(ChartID(), lineName, OBJPROP_PRICE, 1);
        time = (datetime)ObjectGetInteger(ChartID(), lineName, OBJPROP_TIME, 1);
        pChartPoint = new CAcemChartPoint(time, price);
        pFreeCurveData.Add(pChartPoint);

        for (lineIndex = 1; isExsitLine(groupIndex, lineIndex); lineIndex++) {
            lineName = createLineName(prefix, lineIndex);

            // 終点
            price = ObjectGetDouble(ChartID(), lineName, OBJPROP_PRICE, 1);
            time = (datetime)ObjectGetInteger(ChartID(), lineName, OBJPROP_TIME, 1);
            pChartPoint = new CAcemChartPoint(time, price);
            pFreeCurveData.Add(pChartPoint);
        }
    }
}

void CAcemDrawFreeCurve::setAllLineVisibility(bool bVisble)
{
    long visibility = bVisble ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS;

    int groupIndex;

    int lineCount;
    int lineIndex = m_listLine.Total();
    string lineName;
    string prefix;
    CAcemFreeCurveData* pFreeCurveData = m_listLine.GetFirstNode();
    for (pFreeCurveData = m_listLine.GetFirstNode(), groupIndex = 0; pFreeCurveData != NULL; lineIndex++, pFreeCurveData = m_listLine.GetNextNode()) {
        lineCount = pFreeCurveData.Total();
        prefix = pFreeCurveData.getLineDataPrefix();
        for (lineIndex = 0; lineIndex < lineCount - 1; lineIndex++) {
            lineName = createLineName(prefix, lineIndex);
            if (ObjectFind(ChartID(), lineName) < 0) {
                break;
            }
            ObjectSetInteger(ChartID(), lineName, OBJPROP_TIMEFRAMES, visibility);
        }
    }
}

void CAcemDrawFreeCurve::rebuildLineData()
{
    int groupIndex = 0;
    CAcemFreeCurveData* pCurveData;
    string newPrefix;
    string currentPrefix;
    eDrawFreeCurveMode oldMode = m_mode;
    setMode(FreeCurve_DeletingMode);
    for (pCurveData = m_listLine.GetFirstNode(); pCurveData != NULL; pCurveData = m_listLine.GetNextNode(), groupIndex++) {
        newPrefix = createLinePrefix(groupIndex);
        currentPrefix = pCurveData.getLineDataPrefix();
        if (newPrefix != currentPrefix) {
            int totalNum = pCurveData.Total() - 1;
            int lineIndex;
            string oldLineName;
            string newLineName;
            for (lineIndex = 0; lineIndex < totalNum; lineIndex++) {
                oldLineName = createLineName(currentPrefix, lineIndex);
                newLineName = createLineName(newPrefix, lineIndex);
                ObjectSetString(ChartID(), oldLineName, OBJPROP_NAME, newLineName);
            }
        }
        pCurveData.setLineDataPrefix(newPrefix);
    }
    setMode(oldMode);
}

void CAcemDrawFreeCurve::setMode(eDrawFreeCurveMode mode)
{
    if (mode == FreeCurve_InputMode) {
        if (m_mode != FreeCurve_TouchMode && IS_TOUCH_MODE) {
            mode = FreeCurve_TouchMode;
        }
    }

    m_mode = mode;
    m_icon.setIcon(m_mode, ColorToARGB(m_lineColor));
    
    switch (m_mode) {
    case FreeCurve_DelMode:
    case FreeCurve_InvisibleMode:
        {
            m_canvas.minimize();
        }
        break;
    case FreeCurve_InputMode:
        {
            m_canvas.resize();
        }
        break;
    case FreeCurve_TouchMode:
        {
            m_canvas.resize();
        }
        break;
    }
    m_canvas.Erase();
    m_canvas.Update();
    
    string strMode;
    strMode = IntegerToString(mode);
    if (ObjectFind(ChartID(), ACEM_FREE_CUREVE_PARM_MODE) < 0) {
        ObjectCreate(ChartID(), ACEM_FREE_CUREVE_PARM_MODE, OBJ_TEXT, 0, 0, 0);
        ObjectSetInteger(ChartID(), ACEM_FREE_CUREVE_PARM_MODE, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }

    ObjectSetString(ChartID(), ACEM_FREE_CUREVE_PARM_MODE, OBJPROP_TEXT, strMode);
}

void CAcemDrawFreeCurve::finishInput(void)
{
    if (m_pCurrentLine != NULL) {
        if (m_pCurrentLine.Total() == 1) {
            if (m_listLine.Total() > 0) {
                m_listLine.Delete(m_listLine.Total() - 1);
            }
        }
    }
    m_pCurrentLine = NULL;
}