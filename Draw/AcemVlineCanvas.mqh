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
    bool deinit(const int reason);
    void setLineWidth(int width) { m_lineWidth = width; };
    int getLineWidth() { return m_lineWidth; };
    bool resize(bool bUpdate);
    void move(int x);
    int getPosX() {return m_posX;};
    bool getCurrentTime(datetime& currentTime);
    void clearParam();
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
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    int y = 0;
    int x = 0;

    if (!CAcemBaseCanvas::init(x, y, m_lineWidth, height)) {
        return false;
    }
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_SELECTABLE, true);
    ObjectSetInteger(ChartID(), m_canvasName, OBJPROP_HIDDEN, false);

    int posX;
    if (!getParamInt(ChartID(), ACEM_PARAM_SYNC_POS, posX)) {
        int chartWidth = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS);
        posX = (chartWidth / 5) * 4;
    }
    move(posX);
    setParamString(ChartID(), ACEM_PARAM_SYNC_POS_LINE_RCNAME, m_rcname);
    debugPrint(__FUNCTION__ + " m_rcname: " + m_rcname);
    resize(false);

    return true;
}

bool CAcemVlineCanvas::deinit(const int reason)
{
    CAcemBaseCanvas::deinit(reason);

    switch (reason) {
        case REASON_REMOVE:
            {
                ObjectDelete(ChartID(), ACEM_PARAM_SYNC_POS);
                ObjectDelete(ChartID(), ACEM_PARAM_SYNC_POS_LINE_RCNAME);
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

bool CAcemVlineCanvas::resize(bool bUpdate)
{
    int height = (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS);
    return CAcemBaseCanvas::resize(m_lineWidth, height, bUpdate);
}

void CAcemVlineCanvas::move(int x)
{
    if (m_posX == x) {
        return;
    }
    m_posX = x;
    CAcemBaseCanvas::move(m_posX, 0);
    setParamLong(ChartID(), ACEM_PARAM_SYNC_POS, m_posX);
}

bool CAcemVlineCanvas::getCurrentTime(datetime& currentTime)
{
    if (!convPosXToTime(ChartID(), m_posX, true, currentTime)) {
        return false;
    }

    return true;
}

void CAcemVlineCanvas::clearParam()
{
    CAcemBaseCanvas::clearParam();
    m_posX = 0;
}
