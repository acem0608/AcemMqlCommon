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

    return CAcemBaseCanvas::init(0, 0, width, height);
}

void CAcemWindowFillCanvas::resize()
{
    int width = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);

    CAcemBaseCanvas::resize(width, height);
}