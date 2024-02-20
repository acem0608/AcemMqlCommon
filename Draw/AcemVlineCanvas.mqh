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
    void setLineWidth(int width) { m_lineWidth = width; };
    int getLineWidth() { return m_lineWidth; };
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
//    m_canvasName = lineName;
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

    return true;
}
/*
bool CAcemVlineCanvas::deinit(const int reason)
{
    switch (reason) {
        case REASON_REMOVE:
            {
                Destroy();
            }
            break;
        case REASON_PROGRAM:
        case REASON_CHARTCLOSE:
        case REASON_CLOSE:
        case REASON_RECOMPILE:
        case REASON_CHARTCHANGE:
        case REASON_PARAMETERS:
        case REASON_ACCOUNT:
        case REASON_TEMPLATE:
        case REASON_INITFAILED:
        default:
            {
            }
            break;
    }
    return true;
}
*/
void CAcemVlineCanvas::resize(bool bUpdate)
{
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    CAcemBaseCanvas::resize(m_lineWidth, height, bUpdate);
}

void CAcemVlineCanvas::move(int x)
{
    m_posX = x;
    int pos = x - (int)(m_lineWidth / 2);
    CAcemBaseCanvas::move(pos, 0);
    saveParam();
}

datetime CAcemVlineCanvas::getCurrentTime()
{
    datetime currentTime;
    currentTime = convPosXToTime(ChartID(), m_posX, true);

    return currentTime;
}

void CAcemVlineCanvas::saveParam(){
    string strParam;
    int posX = (int)ObjectGetInteger(ChartID(), m_canvasName, OBJPROP_XDISTANCE);
    strParam = IntegerToString(posX);
    ObjectSetString(ChartID(), m_canvasName, OBJPROP_TEXT, strParam);
}

void CAcemVlineCanvas::loadParam()
{
    string strParam;
    strParam = ObjectGetString(ChartID(), m_canvasName, OBJPROP_TEXT);
    int posX;
    posX = (int)StringToInteger(strParam);
}

void CAcemVlineCanvas::setParam(SVlineCanvasParam& param)
{
}

bool CAcemVlineCanvas::getParam(SVlineCanvasParam& param)
{
    if (ObjectFind(ChartID(), m_canvasName) < 0) {
        return false;
    }
    
    string strParam;
    strParam = ObjectGetString(ChartID(), m_canvasName, OBJPROP_TEXT);
    param.posX = (int)StringToInteger(strParam);
    return true;
}
