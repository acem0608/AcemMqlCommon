//+------------------------------------------------------------------+
//|                                          AcemFreeCurveCanvas.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/Draw/AcemBaseCanvas.mqh>

class CAcemFreeCurveCanvas : public CAcemBaseCanvas
{
private:
    CAcemFreeCurveCanvas();

public:
    CAcemFreeCurveCanvas(string canvasName);
    ~CAcemFreeCurveCanvas();
    
    void drawLine(int x1, int y1, int x2, int y2, int lineWidth, color lineColor, bool bUpdate = false);
//    bool init();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveCanvas::CAcemFreeCurveCanvas(string canvasName) : CAcemBaseCanvas(canvasName)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveCanvas::~CAcemFreeCurveCanvas()
{
}
//+------------------------------------------------------------------+
/*
bool CAcemFreeCurveCanvas::init()
{
    CAcemBaseCanvas::init();
    
    m_canvas.FillRectangle(0, 0, m_width, m_height, ColorToARGB((color)ChartGetInteger(ChartID(), CHART_COLOR_BACKGROUND));

    return true;
}
*/
void CAcemFreeCurveCanvas::drawLine(int x1, int y1, int x2, int y2, int lineWidth, color lineColor, bool bUpdate)
{
    Line(x1, y1, x2, y2, ColorToARGB(lineColor));
//    m_canvas.Line(x1, y1, x2, y2, ColorToARGB((color)ChartGetInteger(ChartID(), CHART_COLOR_BACKGROUND)));
    if (bUpdate) {
        Update();
    }
//    Print("(" +x1 + "," + y1 + ") -> (" + x2 + "," + y2 + ")");
}