//+------------------------------------------------------------------+
//|                                              AcemGhostCursor.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Acem/Draw/AcemBaseCanvas.mqh>
#include <Acem/Common/AcemDefine.mqh>

class CAcemSyncCursorCanvas : public CAcemBaseCanvas
{
protected:
     CAcemSyncCursorCanvas(){};

public:
    CAcemSyncCursorCanvas(string canvasName);
    ~CAcemSyncCursorCanvas();
    bool init();

    bool setIcon();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncCursorCanvas::CAcemSyncCursorCanvas(string canvasName) : CAcemBaseCanvas(canvasName)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncCursorCanvas::~CAcemSyncCursorCanvas()
{
}
//+------------------------------------------------------------------+
bool CAcemSyncCursorCanvas::init()
{
    if (ObjectFind(ChartID(), m_canvasName) >= 0) {
        ObjectDelete(ChartID(), m_canvasName);
    }
    if (!CreateBitmapLabel(m_canvasName, 0, 0, 16, 16, COLOR_FORMAT_ARGB_NORMALIZE))
    {
        return (false);
    }
    ObjectSetInteger(0, m_canvasName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, m_canvasName, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
    ObjectSetInteger(0, m_canvasName, OBJPROP_BACK, false);

    setIcon();
    Update();
    return true;
}

bool CAcemSyncCursorCanvas::setIcon()
{
    uint aFig[16 * 16] = {
        0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0xFF000000, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xA0FFFFFF, 0xA0FFFFFF, 0xFF000000, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000};

    ArrayCopy(m_pixels, aFig);
    Update();

    return true;
}
