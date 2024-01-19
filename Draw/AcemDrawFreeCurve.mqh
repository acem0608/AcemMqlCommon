//+------------------------------------------------------------------+
//|                                            AcemDrawFreeCurve.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <ChartObjects/ChartObjectsLines.mqh>

#include <Arrays/List.mqh>
#include <Acem/Common/AcemBase.mqh>
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Draw/AcemFreeCurveData.mqh>
#include <Acem/Draw/AcemFreeCurveCanvas.mqh>

input color ACEM_DRAW_FREE_CURVE_LINE_COLOR = 0x00FFFFFF;        // 　　色
input int ACEM_DRAW_RFRE_CURVE_LINE_WIDTH = 1;                 // 　　線幅

class CAcemDrawFreeCurve : public CAcemBase
{
private:
    CList m_listLine;
    CAcemFreeCurveData *m_pCurrentLine;
    CAcemFreeCurveCanvas m_canvas;
    
    color m_lineColor;
    int m_lineWidth;

public:
    CAcemDrawFreeCurve();
    ~CAcemDrawFreeCurve();

    bool init();
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);

    bool convWindowsPosToChartPos(int id, int x, int y, datetime &time, double &price);
    bool convChartPosToWindowsPos(int id, datetime time, double price, int &x, int &y);
    
    bool drawLine(CAcemChartPoint* pStPoint, CAcemChartPoint* pEdPoint, int lineWidth, color lineColor, bool bUpdate = false);
    bool redraw();
    string createLinePrefix(int groupIndex);
    string createLineName(string prefix, int lineIndex);
    string createLineName(int lineIndex, int groupIndex);
    bool addLineData(CAcemChartPoint* pStPoint, CAcemChartPoint* pEdPoint, int lineWidth, color lineColor, string lineName);
    void readLineData();
    bool isExsitLine(int groupIndex, int lineIndex);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemDrawFreeCurve::CAcemDrawFreeCurve() : m_canvas(ACEM_FREE_CUREVE_CANVAS_NAME), m_pCurrentLine(NULL)
{
    m_listLine.FreeMode(true);
    m_lineColor = ACEM_DRAW_FREE_CURVE_LINE_COLOR;
    m_lineWidth = ACEM_DRAW_RFRE_CURVE_LINE_WIDTH;
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
    m_canvas.init();
    m_pCurrentLine = NULL;
    m_listLine.Clear();
    
    readLineData();
    redraw();

    return true;
}

bool CAcemDrawFreeCurve::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    uint flag = (uint)sparam;
    if ((flag & 0x08) == 0x08)
    {

        int x = (int)lparam;
        int y = (int)dparam;
        datetime time;
        double price;

        convWindowsPosToChartPos(ChartID(), x, y, time, price);

        CAcemChartPoint *pChartPoint = new CAcemChartPoint(time, price);
        CAcemChartPoint *pLastPoint = NULL;

        if (m_pCurrentLine == NULL)
        {
            m_pCurrentLine = new CAcemFreeCurveData();
            m_pCurrentLine.setColor(m_lineColor);
            m_pCurrentLine.setLineWidth(m_lineWidth);
            if (m_pCurrentLine == NULL)
            {
                return false;
            }
            string prefix;
            prefix = createLinePrefix(m_listLine.Total());
            m_pCurrentLine.setLineDataPrefix(prefix);
            m_listLine.Add(m_pCurrentLine);
        }
        else
        {
            pLastPoint = m_pCurrentLine.GetLastNode();
            if (pLastPoint.isEqual(pChartPoint)) {
                return true;
            }
        }

        m_pCurrentLine.Add(pChartPoint);

        if (pLastPoint != NULL)
        {
            int lineWidth = m_pCurrentLine.getLineWidth();
            color lineColor = m_pCurrentLine.getLineColor();
            string prefix = m_pCurrentLine.getLineDataPrefix();
            string lineName = createLineName(prefix, m_pCurrentLine.Total() - 2);   // 0始まりにするために2を引く
            addLineData(pLastPoint, pChartPoint, lineWidth, lineColor, lineName);
            drawLine(pLastPoint, pChartPoint, lineWidth, lineColor, true);
        }
    }
    else
    {
        if (m_pCurrentLine != NULL)
        {
            m_pCurrentLine = NULL;
        }
    }

    return true;
}

bool CAcemDrawFreeCurve::OnChartChange(int id, long lparam, double dparam, string sparam)
{
    redraw();

    return true;
}

bool CAcemDrawFreeCurve::convWindowsPosToChartPos(int id, int x, int y, datetime &time, double &price)
{
    int subWindow = 0;
    ChartXYToTimePrice(ChartID(), x, y, subWindow, time, price);

    int leftIndex = WindowFirstVisibleBar();
    datetime leftTime = iTime(NULL, 0, leftIndex);
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = ulong(1 << chartScale);
    int stepNum = int(x / step);
    int periodSec = PeriodSeconds(PERIOD_CURRENT);
    int mod = x - (stepNum * step);
    datetime modTime = datetime(mod * periodSec / step);
    int convTimeIndex = leftIndex - stepNum;
    datetime baseTime = iTime(NULL, 0, convTimeIndex);
    datetime convTime = baseTime + modTime;
    time = convTime;

    return true;
}

bool CAcemDrawFreeCurve::convChartPosToWindowsPos(int id, datetime time, double price, int &x, int &y)
{
    int subWindow = 0;
    ChartTimePriceToXY(ChartID(), subWindow, time, price, x, y);
    
    int leftIndex = WindowFirstVisibleBar();
    int nearIndex = iBarShift(NULL, 0, time, false);
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = ulong(1 << chartScale);
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
    double stPrice;
    datetime stTime;
    double edPrice;
    datetime edTime;

    pStPoint.getTimePrice(stTime, stPrice);
    pEdPoint.getTimePrice(edTime, edPrice);
    convChartPosToWindowsPos(ChartID(), stTime, stPrice, x1, y1);
    convChartPosToWindowsPos(ChartID(), edTime, edPrice, x2, y2);

    m_canvas.drawLine(x1, y1, x2, y2, lineWidth, lineColor, bUpdate);

    return true;
}

bool CAcemDrawFreeCurve::redraw(void)
{
    m_canvas.Erase();
    
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
    
    m_canvas.Update();
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
        ObjectSetInteger(ChartID(), lineName, OBJPROP_WIDTH, lineWidth);
//        ObjectSetInteger(ChartID(), lineName, OBJPROP_BACK, TLINE_BACK);
        ObjectSetInteger(ChartID(), lineName, OBJPROP_RAY_RIGHT, 0);
        ObjectSetInteger(ChartID(), lineName,OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
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
        lineColor = ObjectGetInteger(ChartID(), lineName, OBJPROP_COLOR);
        pFreeCurveData.setColor(lineColor);
        lineWidth = ObjectGetInteger(ChartID(), lineName, OBJPROP_LEVELWIDTH);
        pFreeCurveData.setLineWidth(lineWidth);
        
        m_listLine.Add(pFreeCurveData);

        // 始点
        price = ObjectGetDouble(ChartID(), lineName,OBJPROP_PRICE, 0);
        time = ObjectGetInteger(ChartID(), lineName, OBJPROP_TIME, 0);
        pChartPoint = new CAcemChartPoint(time, price);
        pFreeCurveData.Add(pChartPoint);
        
        // 終点
        price = ObjectGetDouble(ChartID(), lineName,OBJPROP_PRICE, 1);
        time = ObjectGetInteger(ChartID(), lineName, OBJPROP_TIME, 1);
        pChartPoint = new CAcemChartPoint(time, price);
        pFreeCurveData.Add(pChartPoint);

        for (lineIndex = 1; isExsitLine(groupIndex, lineIndex); lineIndex++) {
            lineName = createLineName(prefix, lineIndex);

            // 終点
            price = ObjectGetDouble(ChartID(), lineName,OBJPROP_PRICE, 1);
            time = ObjectGetInteger(ChartID(), lineName, OBJPROP_TIME, 1);
            pChartPoint = new CAcemChartPoint(time, price);
            pFreeCurveData.Add(pChartPoint);
        }
    }
}