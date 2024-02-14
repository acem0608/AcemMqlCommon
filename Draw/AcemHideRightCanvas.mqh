//+------------------------------------------------------------------+
//|                                          AcemHideRightCanvas.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/Draw/AcemBaseCanvas.mqh>

class CAcemHideRightCanvas : public CAcemBaseCanvas
{
private:
    CAcemHideRightCanvas() {};

protected:

public:
    CAcemHideRightCanvas(string canvasName);
    ~CAcemHideRightCanvas();
    virtual bool init();
    void resize(int width, bool bUpdate);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemHideRightCanvas::CAcemHideRightCanvas(string canvasName) : CAcemBaseCanvas(canvasName)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemHideRightCanvas::~CAcemHideRightCanvas()
{
}
//+------------------------------------------------------------------+

bool CAcemHideRightCanvas::init()
{
    int width = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS) / 2;
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);

    bool retc = CAcemBaseCanvas::init(0, 0, width, height);
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_CORNER, CORNER_RIGHT_UPPER);

    return true;
}

void CAcemHideRightCanvas::resize(int width, bool bUpdate)
{
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    CAcemBaseCanvas::resize(width, height, bUpdate);
    color hideColor = ColorToARGB((color)ChartGetInteger(ChartID(), CHART_COLOR_BACKGROUND));
    fill(hideColor);
}