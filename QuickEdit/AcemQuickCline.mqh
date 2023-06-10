//+------------------------------------------------------------------+
//|                                               AcemQuickCline.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property version   "1.00"

#property strict

#include <Acem/QuickEdit/AcemQuickEditBase.mqh>
#include <ChartObjects/ChartObjectsChannels.mqh>

input string cline_dmy1 = "";//-- 平行チャネルの設定 --
input eInputKeyCode KEY_CHANNEL = ACEM_KEYCODE_C;//　　平行チャネルの入力キー
input color CLINE_COLOR = 0x00FFFFFF;//　　色
input ENUM_LINE_STYLE CLINE_STYLE = STYLE_SOLID;//　　線種
input eLineidth CLINE_WIDTH = LINE_WIDTH_1;//　　線幅
input bool CLINE_BACK = false;//　　背景として表示
#ifdef  __MQL4__
input bool CLINE_RAY_RIGHT = false;//　　ラインを延長
#endif
#ifdef __MQL5__
input bool CLINE_RAY_LEFT = false;//　　左に延長
input bool CLINE_RAY_RIGHT = false;//　　右に延長
input bool CLINE_FILL = false;//　　塗りつぶし
#endif

class CAcemQuickCline : public CAcemQuickEditBase
{
private:
    long m_channelIndex;
    CChartObjectChannel m_Channel;
    CChartObjectChannel *m_pChannel;
    int m_ChannelPointNum;

    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);

    bool init(bool bDel);

    string getNewObjName();
    virtual bool setDefalutProp(string objName);
    
public:
    CAcemQuickCline();
    ~CAcemQuickCline();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickCline::CAcemQuickCline()
{
    m_channelIndex = 0;
    m_pChannel = NULL;
    m_ChannelPointNum = 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickCline::~CAcemQuickCline()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickCline::init(bool bDel)
{
    if (m_pChannel != NULL) {
        if (bDel) {
            m_Channel.Delete();
        }
        m_pChannel = NULL;
        m_ChannelPointNum = 0;
        m_Channel.Selected(false);
    }
    
    return true;
}

bool CAcemQuickCline::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (lparam == KEY_CHANNEL) {
        if (m_pChannel == NULL) {
            init(true);
            string objName = getNewObjName();
            m_pChannel = GetPointer(m_Channel);
            if (m_Channel.Create(ChartID(), objName, 0, m_time, m_price, m_time, m_price, m_time, m_price)) {
                m_Channel.Selected(true);
                setDefalutProp(objName);
                m_ChannelPointNum = 1;
            }
        }
    } else if (lparam == ACEM_KEYCODE_ESC) {
        init(true);
    }

    return true;
}
bool CAcemQuickCline::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    if (m_pChannel != NULL) {
        m_pChannel.SetPoint(m_ChannelPointNum, m_time, m_price);
        ChartRedraw(ChartID());
    }
    return true;
}

bool CAcemQuickCline::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    if (m_pChannel != NULL) {
        if (m_ChannelPointNum == 2) {
            init(false);
        } else {
            m_ChannelPointNum++;
        }
    }
    return true;
}

string CAcemQuickCline::getNewObjName()
{
    string objName;
    do {
        objName = "Trend Line " + convettNumToStr05(m_channelIndex++);
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}

bool CAcemQuickCline::setDefalutProp(string objName)
{
    CAcemQuickEditBase::setDefalutProp(objName);
    ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, CLINE_COLOR);
    ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, CLINE_STYLE);
    ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, CLINE_WIDTH);
    ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, CLINE_BACK);
    ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_RIGHT, CLINE_RAY_RIGHT);
    
#ifdef __MQL5__
    ObjectSetInteger(ChartID(), objName, OBJPROP_RAY_LEFT, CLINE_RAY_LEFT);
    ObjectSetInteger(ChartID(), objName, OBJPROP_FILL,fill);
#endif
    return true;
}
