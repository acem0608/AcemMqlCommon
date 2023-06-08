//+------------------------------------------------------------------+
//|                                                AcemQuickBase.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Acem/Common/AcemBase.mqh>

#define ACEM_KEYCODE_ESC 27

enum eInputKeyCode
{
    ACEM_KEYCODE_A = 65, // A
    ACEM_KEYCODE_B = 66, // B
    ACEM_KEYCODE_C = 67, // C
    ACEM_KEYCODE_D = 68, // D
    ACEM_KEYCODE_E = 69, // E
    ACEM_KEYCODE_F = 70, // F
    ACEM_KEYCODE_G = 71, // G
    ACEM_KEYCODE_H = 72, // H
    ACEM_KEYCODE_I = 73, // I
    ACEM_KEYCODE_J = 74, // J
    ACEM_KEYCODE_K = 75, // K
    ACEM_KEYCODE_L = 76, // L
    ACEM_KEYCODE_M = 77, // M
    ACEM_KEYCODE_N = 78, // N
    ACEM_KEYCODE_O = 79, // O
    ACEM_KEYCODE_P = 80, // P
    ACEM_KEYCODE_Q = 81, // Q
    ACEM_KEYCODE_R = 82, // R
    ACEM_KEYCODE_S = 83, // S
    ACEM_KEYCODE_T = 84, // T
    ACEM_KEYCODE_U = 85, // U
    ACEM_KEYCODE_V = 86, // V
    ACEM_KEYCODE_W = 87, // W
    ACEM_KEYCODE_X = 88, // X
    ACEM_KEYCODE_Y = 89, // Y
    ACEM_KEYCODE_Z = 90 // Z
};

class CAcemQuickEditBase : public CAcemBase
{
protected:
    long m_time;
    double m_price;

   void setMouseToTimePrice(long lparam, double dparam);
   string convettNumToStr05(long num);

public:
    CAcemQuickEditBase();
    ~CAcemQuickEditBase();
    
    virtual void init();
    virtual bool OnChartEvent(int id, long lparam, double dparam, string sparam);
    bool setDefalutProp(string objName);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickEditBase::CAcemQuickEditBase()
{
    m_time = 0;
    m_price = 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickEditBase::~CAcemQuickEditBase()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickEditBase::OnChartEvent(int id, long lparam, double dparam, string sparam)
{
    switch (id)
    {
    case CHARTEVENT_KEYDOWN:
        {
            OnKeyDown(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_MOUSE_MOVE:
        {
            setMouseToTimePrice(lparam, dparam);
            OnMouseMove(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_OBJECT_CREATE:
        {
            OnObjectCreate(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_OBJECT_CHANGE:
        {
            OnObjectChange(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_OBJECT_DELETE:
        {
            OnObjectDelete(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_CLICK:
        {
            OnChartClick(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_OBJECT_CLICK:
        {
            OnMouseMove(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_OBJECT_DRAG:
        {
            OnObjectDrag(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_OBJECT_ENDEDIT:
        {
            OnObjectEndEdit(id, lparam, dparam, sparam);
        }
        break;
    case CHARTEVENT_CHART_CHANGE:
        {
            OnChartChange(id, lparam, dparam, sparam);
        }
        break;
    default:
        break;
    }
    return true;
}

void CAcemQuickEditBase::setMouseToTimePrice(long lparam, double dparam)
{
    int windowNo;
    datetime mouseTime;
    double mousePrice;
    if (!ChartXYToTimePrice(ChartID(), lparam, dparam, windowNo, mouseTime, mousePrice))
    {
        return;
        m_price = 0.0;
        m_time = 0;
    }
    
    m_price = mousePrice;
    m_time = mouseTime;

}

bool CAcemQuickEditBase::setDefalutProp(string objName)
{
    long chartId = ChartID();
    if (ObjectFind(chartId, objName) < 0) {
        return false;
    }
    ObjectSetInteger(chartId, objName, OBJPROP_READONLY, false);
    ObjectSetInteger(chartId, objName, OBJPROP_HIDDEN, false);
    ObjectSetInteger(chartId, objName, OBJPROP_SELECTABLE, true);

    return true;
}

string CAcemQuickEditBase::convettNumToStr05(long num)
{
    string strNum;

    if (num > 9999)
    {
        strNum = num;
    }
    else
    {
        int digit1 = MathMod(num, 10);
        int digit2 = MathMod(int(num / 10), 10);
        int digit3 = MathMod(int(num / 100), 10);
        int digit4 = MathMod(int(num / 1000), 10);
        strNum = "0" + digit3 + digit2 + digit1;
    }

    return strNum;
}
