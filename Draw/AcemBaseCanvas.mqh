//+------------------------------------------------------------------+
//|                                                 AcemBaseCanvas.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Canvas/Canvas.mqh>

class CAcemBaseCanvas
{
private:
    CCanvas m_canavs;
    int m_width; //
    int m_height;

public:
    CAcemBaseCanvas();
    ~CAcemBaseCanvas();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemBaseCanvas::CAcemDrawBase()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemBaseCanvas::~CAcemDrawBase()
{
}
//+------------------------------------------------------------------+
