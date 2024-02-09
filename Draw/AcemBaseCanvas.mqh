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

class CAcemBaseCanvas : public CCanvas
{
protected:
    CAcemBaseCanvas() {};   //  使用禁止
    string m_canvasName;

public:
    CAcemBaseCanvas(string canvasName);
    ~CAcemBaseCanvas();
    
    virtual bool init() = 0;
    virtual bool init(int x, int y, int width, int height);
    bool deinit();
#ifdef __MQL4__
    virtual bool Attach(const long chart_id,const string objname,ENUM_COLOR_FORMAT clrfmt=COLOR_FORMAT_XRGB_NOALPHA);
#endif
    bool Attach();
    void resize(int width, int height, bool bUpdate);
    void move(int x, int y);
    void fill(color clr);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemBaseCanvas::CAcemBaseCanvas(string canvasName)
{
    m_canvasName = canvasName;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemBaseCanvas::~CAcemBaseCanvas()
{
}
//+------------------------------------------------------------------+

bool CAcemBaseCanvas::init(int x, int y, int width, int height)
{
    int objIndex = ObjectFind(ChartID(), m_canvasName);
    if (objIndex >= 0 && ObjectGetInteger(ChartID(), m_canvasName, OBJPROP_TYPE) == OBJ_BITMAP_LABEL) {
        //ObjectDelete(0, m_canvasName);
        if (!Attach(ChartID(), m_canvasName)) {
            return false;
        }
    } else if (!CreateBitmapLabel(m_canvasName, x, y, width, height, COLOR_FORMAT_ARGB_NORMALIZE)) {
        return (false);
    }
    ObjectSetInteger(0, m_canvasName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, m_canvasName, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
    ObjectSetInteger(0, m_canvasName, OBJPROP_BACK, false);

    return true;
}

bool CAcemBaseCanvas::deinit()
{
    Erase(0x00000000);
    Update();
    ObjectDelete(ChartID(), m_canvasName);

    return true;
}

#ifdef __MQL4__
bool CAcemBaseCanvas::Attach(const long chart_id,const string objname,ENUM_COLOR_FORMAT clrfmt=COLOR_FORMAT_XRGB_NOALPHA)
{
    int type = (int)ObjectGetInteger(chart_id, m_canvasName, OBJPROP_TYPE);
    if (OBJ_BITMAP_LABEL == ObjectGetInteger(chart_id, m_canvasName, OBJPROP_TYPE)) {
        m_width = (int)ObjectGetInteger(ChartID(), m_canvasName, OBJPROP_XSIZE);
        if (m_width <= 0) {
            m_width = 1;
        }
        m_height = (int)ObjectGetInteger(ChartID(), m_canvasName, OBJPROP_YSIZE);
        if (m_height <= 0) {
            m_height = 1;
        }
        string rcname = ObjectGetString(chart_id, m_canvasName, OBJPROP_BMPFILE);
        rcname = StringSubstr(rcname, StringFind(rcname, "::"));
        if (StringLen(rcname) != 0 && m_width > 0 && m_height > 0 && ArrayResize(m_pixels, m_width * m_height) > 0) {
            ZeroMemory(m_pixels);
            if (ResourceCreate(rcname, m_pixels, m_width, m_height, 0, 0, 0, clrfmt)) {
                m_chart_id = chart_id;
                m_objname = m_canvasName;
                m_rcname = rcname;
                m_format = clrfmt;
                m_objtype = OBJ_BITMAP_LABEL;
                
                Resize(m_width, m_height);

                return (true);
            }
        }
    }
    //--- failed
    return (false);
}
#endif

bool CAcemBaseCanvas::Attach()
{
    return Attach(ChartID(), m_canvasName, COLOR_FORMAT_ARGB_NORMALIZE);
}

void CAcemBaseCanvas::resize(int width, int height, bool bUpdate)
{
    if (m_width != width || m_height != height)
    {
        m_width = width;
        m_height = height;
        Resize((int)m_width, (int)m_height);
        Erase(ColorToARGB(0xff000000));
        
        if (bUpdate) {
            Update();
        }
    }
}

void CAcemBaseCanvas::move(int x, int y)
{
    if (ObjectFind(ChartID(), m_canvasName) >= 0)
    {
        ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_YDISTANCE, y);
    }
}

void CAcemBaseCanvas::fill(color clr)
{
    Fill(0, 0, ColorToARGB(clr));
}