//+------------------------------------------------------------------+
//|                                          AcemFreeCurveCanvas.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Draw/AcemWindowFillCanvas.mqh>

class CAcemFreeCurveCanvas : public CAcemWindowFillCanvas
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
CAcemFreeCurveCanvas::CAcemFreeCurveCanvas(string canvasName) : CAcemWindowFillCanvas(canvasName)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemFreeCurveCanvas::~CAcemFreeCurveCanvas()
{
}
//+------------------------------------------------------------------+

void CAcemFreeCurveCanvas::drawLine(int x1, int y1, int x2, int y2, int lineWidth, color lineColor, bool bUpdate)
{
    if (lineWidth == 1) {
        Line(x1, y1, x2, y2, ColorToARGB(lineColor));
    }
    eLineDirection direction;
    
    int dX = x2 - x1;
    int dY = y2 - y1;

    if (MathAbs(dX) - MathAbs(dY) > 0) {
        if (dX > 0) {
            direction = ACEM_DIRECTION_RIGHT;
        } else {
            direction = ACEM_DIRECTION_LEFT;
        } 
    } else {
        if (dY > 0) {
            direction = ACEM_DIRECTION_UP;
        } else {
            direction = ACEM_DIRECTION_DOWN;
        }
    }

    int rad = int(lineWidth / 2);
    switch (direction) {
        case ACEM_DIRECTION_RIGHT:
        {
            int offset;
            int maxOffset = rad + int(MathMod(lineWidth, 2)) - 1;
            for (offset = -rad; offset < maxOffset; offset++) {
                Line(x1, y1 + offset, x2, y2 + offset, ColorToARGB(lineColor));
            }
        }
        break;
        case ACEM_DIRECTION_UP:
        {
            int offset;
            int maxOffset = rad + int(MathMod(lineWidth, 2)) - 1;
            for (offset = -rad; offset < maxOffset; offset++) {
                Line(x1 + offset, y1, x2 + offset, y2, ColorToARGB(lineColor));
            }
        }
        break;
        case ACEM_DIRECTION_LEFT:
        {
            int offset;
            int maxOffset = rad + int(MathMod(lineWidth, 2)) - 1;
            for (offset = -rad; offset < maxOffset; offset++) {
                Line(x1, y1 - offset, x2, y2 - offset, ColorToARGB(lineColor));
            }
        }
        break;
        case ACEM_DIRECTION_DOWN:
        {
            int offset;
            int maxOffset = rad + int(MathMod(lineWidth, 2)) - 1;
            for (offset = -rad; offset < maxOffset; offset++) {
                Line(x1 - offset, y1, x2 - offset, y2, ColorToARGB(lineColor));
            }
        }
        break;
    }

    if (bUpdate) {
        Update();
    }
}