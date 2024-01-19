//+------------------------------------------------------------------+
//|                                            AcemHideRightSide.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Canvas\Canvas.mqh>
#include <Acem/Common/AcemDebug.mqh>

class CAcemHideRightSide
{
private:
    CCanvas m_canvas;
    long m_width;
    long m_height;
    long m_hidePos;
    string m_canvas_name;
    uint m_hideColor;

public:
    CAcemHideRightSide();
    ~CAcemHideRightSide();
    bool init();
    bool deinit();
    void Erase();
    void Resize();
    void setHidePos(int x);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemHideRightSide::CAcemHideRightSide()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemHideRightSide::~CAcemHideRightSide()
{
debugPrint("CAcemHideRightSide::~CAcemHideRightSide()");
}
//+------------------------------------------------------------------+

bool CAcemHideRightSide::init()
{
    m_width = ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    m_height = ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    m_canvas_name = ACEM_CHART_HIDE_CANVAS;

    int objIndex = ObjectFind(ChartID(), m_canvas_name);
    if (objIndex >= 0 && ObjectGetInteger(ChartID(), m_canvas_name, OBJPROP_TYPE) == OBJ_BITMAP_LABEL)
/*
    {
        bool bAttatch = m_canvas.Attach(ChartID(), m_canvas_name, COLOR_FORMAT_ARGB_NORMALIZE);
    }
    else
*/

    {
        ObjectDelete(0, m_canvas_name);
    }
    if (!m_canvas.CreateBitmapLabel(m_canvas_name, 0, 0, (int)m_width, (int)m_height, COLOR_FORMAT_ARGB_NORMALIZE))
    {
        return (false);
    }
    m_hideColor = ColorToARGB((color)ChartGetInteger(ChartID(), CHART_COLOR_BACKGROUND));
    ObjectSetInteger(0, m_canvas_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, m_canvas_name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
    ObjectSetInteger(0, m_canvas_name, OBJPROP_BACK, false);
    ObjectSetInteger(ChartID(), ACEM_CHART_HIDE_CANVAS, OBJPROP_ZORDER, 1);
    Resize();

    return true;
}

bool CAcemHideRightSide::deinit()
{
debugPrint("CAcemHideRightSide::deinit()");
m_canvas.CreateBitmapLabel("AcemDummyBitmapLabel", 0, 0, (int)m_width, (int)m_height, COLOR_FORMAT_ARGB_NORMALIZE);
    return true;
    // return (ObjectDelete(0, m_canvas_name) ? true : false);
}

void CAcemHideRightSide::Erase()
{
    m_canvas.Erase();
}

void CAcemHideRightSide::Resize()
{
    long width = ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
    long height = ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);

    if (m_width != width || m_height != m_height)
    {
        m_width = width;
        m_height = height;
        m_canvas.Resize((int)m_width, (int)m_height);
        m_canvas.Erase(ColorToARGB(0xff000000));
        m_canvas.Update();
    }
}

void CAcemHideRightSide::setHidePos(int x)
{
    int chartScale = ChartGetInteger(ChartID(), CHART_SCALE);
    int offset = int((1 << chartScale) / 2) + 1;
    m_hidePos = x + offset;
    m_canvas.Erase();
    m_canvas.FillRectangle(m_hidePos, 0, m_width, m_height, m_hideColor);
    m_canvas.Update();
}