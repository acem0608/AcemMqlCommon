//+------------------------------------------------------------------+
//|                                              AcemVlineCanvas.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Acem/common/AcemUtility.mqh>
#include <Acem/Draw/AcemBaseCanvas.mqh>

struct SVlineCanvasParam
{
    int posX;
};

class CAcemVlineCanvas : public CAcemBaseCanvas
{
private:
    CAcemVlineCanvas(){};

protected:
    int m_lineWidth;
    int m_posX;
public:
    CAcemVlineCanvas(string lineName);
    ~CAcemVlineCanvas();
    virtual bool init();
//    bool deinit(const int reason);
//    void setLineWidth(int width) { m_lineWidth = width; };
//    int getLineWidth() { return m_lineWidth; };
    void resize(bool bUpdate);
    void move(int x);
    int getPosX() {return m_posX;};
    datetime getCurrentTime();
    void saveParam();
    void loadParam();
    void setParam(SVlineCanvasParam& param);
    bool getParam(SVlineCanvasParam& param);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

CAcemVlineCanvas::CAcemVlineCanvas(string lineName) : CAcemBaseCanvas(lineName)
{
    m_lineWidth = 1;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemVlineCanvas::~CAcemVlineCanvas()
{
}
//+------------------------------------------------------------------+
bool CAcemVlineCanvas::init()
{
Print(__FUNCTION__ + " start");
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    int y = 0;
    int x = 0;

    if (!CAcemBaseCanvas::init(x, y, m_lineWidth, height)) {
        return false;
    }
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_SELECTABLE, true);
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_HIDDEN, false);
    
    SVlineCanvasParam param;
    getParam(param);
    if (param.posX == 0) {
        int chartWidth = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
        param.posX = (chartWidth / 5) * 4;
    }
    move(param.posX);
    resize(false);

Print(__FUNCTION__ + " end");
    return true;
}

void CAcemVlineCanvas::resize(bool bUpdate)
{
Print(__FUNCTION__ + " start");
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    CAcemBaseCanvas::resize(m_lineWidth, height, bUpdate);
Print(__FUNCTION__ + " end");
}

void CAcemVlineCanvas::move(int x)
{
Print(__FUNCTION__ + " start");
    m_posX = x;
//    int pos = x - (int)(m_lineWidth / 2);
    CAcemBaseCanvas::move(x, 0);
Print("pos: " + IntegerToString(x));
    saveParam();
Print(__FUNCTION__ + " end");
}

datetime CAcemVlineCanvas::getCurrentTime()
{
Print(__FUNCTION__ + " start");
    datetime currentTime;
    currentTime = convPosXToTime(ChartID(), m_posX, true);

Print(__FUNCTION__ + " end");
    return currentTime;
}

void CAcemVlineCanvas::saveParam()
{
Print(__FUNCTION__ + " start");
    string strParam;
    int posX = (int)ObjectGetInteger(ChartID(), m_canvasName, OBJPROP_XDISTANCE);
Print("posX: " + IntegerToString(posX));
    strParam = IntegerToString(posX);
    ObjectSetString(ChartID(), m_canvasName, OBJPROP_TEXT, strParam);
Print(__FUNCTION__ + " end");
}

void CAcemVlineCanvas::loadParam()
{
Print(__FUNCTION__ + " start");
    string strParam;
    strParam = ObjectGetString(ChartID(), m_canvasName, OBJPROP_TEXT);
    int posX;
    posX = (int)StringToInteger(strParam);
}

void CAcemVlineCanvas::setParam(SVlineCanvasParam& param)
{
Print(__FUNCTION__ + " start");
Print(__FUNCTION__ + " end");
}

bool CAcemVlineCanvas::getParam(SVlineCanvasParam& param)
{
Print(__FUNCTION__ + " start");
    if (ObjectFind(ChartID(), m_canvasName) < 0) {
Print(__FUNCTION__ + " end1");
        return false;
    }
    
    string strParam;
    strParam = ObjectGetString(ChartID(), m_canvasName, OBJPROP_TEXT);
    param.posX = (int)StringToInteger(strParam);
Print(__FUNCTION__ + " end2");
    return true;
}
