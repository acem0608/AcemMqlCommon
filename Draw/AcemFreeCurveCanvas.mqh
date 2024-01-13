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
