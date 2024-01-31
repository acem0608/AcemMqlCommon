//+------------------------------------------------------------------+
//|                                         AcemWindowFillCanvas.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Acem/Draw/AcemBaseCanvas.mqh>

class CAcemWindowFillCanvas : public CAcemBaseCanvas
{
protected:
    CAcemWindowFillCanvas(){};

public:
    CAcemWindowFillCanvas(string canvasName);
    ~CAcemWindowFillCanvas();
    virtual bool init();
    virtual void resize();
    virtual void minimize();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemWindowFillCanvas::CAcemWindowFillCanvas(string canvasName) : CAcemBaseCanvas(canvasName)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemWindowFillCanvas::~CAcemWindowFillCanvas()
{
}
//+------------------------------------------------------------------+
bool CAcemWindowFillCanvas::init()
{
    int width = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);

    bool retc = CAcemBaseCanvas::init(0, 0, width, height);
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_SELECTABLE, false);
    return retc;
}

void CAcemWindowFillCanvas::resize()
{
    int width = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);

    CAcemBaseCanvas::resize(width, height);
}

void CAcemWindowFillCanvas::minimize()
{
    CAcemBaseCanvas::resize(3, 3);
}