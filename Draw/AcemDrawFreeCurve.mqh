//+------------------------------------------------------------------+
//|                                            AcemDrawFreeCurve.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Arrays/List.mqh>
#include <Acem/Common/AcemBase.mqh>
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Draw/AcemFreeCurveData.mqh>
#include <Acem/Draw/AcemFreeCurveCanvas.mqh>

class CAcemDrawFreeCurve : public CAcemBase
{
private:
    CList m_listLine;
    CAcemFreeCurveData *m_pCurrentLine;
    CAcemFreeCurveCanvas m_canvas;

public:
    CAcemDrawFreeCurve();
    ~CAcemDrawFreeCurve();

    bool init();
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);

    bool convWindowsPosToChartPos(int id, int x, int y, datetime &time, double &price);
    bool convChartPosToWindowsPos(int id, datetime time, double price, int &x, int &y);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemDrawFreeCurve::CAcemDrawFreeCurve() : m_canvas(ACEM_FREE_CUREVE_CANVAS_NAME), m_pCurrentLine(NULL)
{
    m_listLine.FreeMode(true);
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
        // Print("intput:(" + x + "," + y + ") -> (" + TimeToStr(time) + "," + price + ")");
        CAcemChartPoint *pChartPoint = new CAcemChartPoint(time, price);
        CAcemChartPoint *pLastPoint = NULL;

        if (m_pCurrentLine == NULL)
        {
            m_pCurrentLine = new CAcemFreeCurveData();
            if (m_pCurrentLine == NULL)
            {
                return false;
            }
            m_listLine.Add(m_pCurrentLine);
        }
        else
        {
            pLastPoint = m_pCurrentLine.getLastPoint();
        }
        m_pCurrentLine.addPoint(pChartPoint);
        if (0)
        {
            CAcemChartPoint *pTmpPoint = m_pCurrentLine.getLastPoint();
            datetime wTime;
            double wPrice;
            pTmpPoint.getTimePrice(wTime, wPrice);
            Print("AddPoint:(" + TimeToStr(wTime) + "," + wPrice + ")");
        }
        if (pLastPoint != NULL)
        {
            int x1;
            int y1;
            int x2;
            int y2;
            double prePrice;
            datetime preTime;

            pLastPoint.getTimePrice(preTime, prePrice);
            // Print("pLastPoint:(" + TimeToStr(preTime) + "," + prePrice + ")");
            convChartPosToWindowsPos(ChartID(), preTime, prePrice, x1, y1);
            convChartPosToWindowsPos(ChartID(), time, price, x2, y2);

            int lineWidth = m_pCurrentLine.getLineWidth();
            color lineColor = m_pCurrentLine.getLineColor();
            m_canvas.drawLine(x1, y1, x2, y2, lineWidth, lineColor);
            // Print("(" + x2 + "," + y2 + ") (" + x + "," + y + ")");
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
    m_canvas.Erase();

    return true;
}

bool CAcemDrawFreeCurve::convWindowsPosToChartPos(int id, int x, int y, datetime &time, double &price)
{
    int subWindow = 0;
    ChartXYToTimePrice(ChartID(), x, y, subWindow, time, price);

    int leftIndex = WindowFirstVisibleBar();
    datetime leftTime = Time[leftIndex];
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = int(1 << chartScale);
    int stepNum = int(x / step);
    int chartPeriod = (int)ChartPeriod(ChartID());
    int mod = x - (stepNum * step);
    // Print("mod = " + IntegerToString(mod));
    int modTime = int(mod * 60 * chartPeriod / step);
    datetime convTime = leftTime + (chartPeriod * stepNum * 60) + modTime;
    // Print(TimeToStr(time) + " : " + TimeToStr(convTime));
    if (0)
    {
        int x1, y1;
        convChartPosToWindowsPos(ChartID(), convTime, price, x1, y1);
        Print("(" + x + "," + y + ") (" + x1 + "," + y1 + ")");
    }
    // Print(TimeToStr(leftTime) + " x = " + IntegerToString(x) + " : " + TimeToStr(convTime) + " : " + IntegerToString(chartPeriod) + " : " + IntegerToString(stepNum));
    // Print("x = " +IntegerToString(x) +  ": StepNum = " + IntegerToString(stepNum) + " : step = " + IntegerToString(step));

    time = convTime;

    return true;
}

bool CAcemDrawFreeCurve::convChartPosToWindowsPos(int id, datetime time, double price, int &x, int &y)
{
    int subWindow = 0;
    ChartTimePriceToXY(ChartID(), subWindow, time, price, x, y);

    int leftIndex = WindowFirstVisibleBar();
    datetime leftTime = Time[leftIndex];
    int chartScale = (int)ChartGetInteger(ChartID(), CHART_SCALE);
    int step = int(1 << chartScale);
    int chartPeriod = (int)ChartPeriod(ChartID());
    uint timeStep = chartPeriod * 60;
    long diffTime = time - leftTime;
    if (diffTime < 0)
    {
        return false;
    }
    double stepNum = (double)(diffTime / (double)timeStep);
    int convX = (int)MathRound(stepNum * step);
    // Print("conv : time = " + TimeToStr(time) + " : x = " + IntegerToString(x) + " : conX = "+ IntegerToString(convX));
    x = convX;

    return true;
}