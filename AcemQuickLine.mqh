//+------------------------------------------------------------------+
//|                                                AcemQuickLine.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class CAcemQuickLine
{
private:
    long m_time;
    double m_price;
public:
    CAcemQuickLine();
    ~CAcemQuickLine();

    bool init();

    bool OnChartEvent(int id, long lparam, double dparam, string sparam);
    bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    bool OnObjectCreate(int id, long lparam, double dparam, string sparam);
    bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    bool OnObjectDelete(int id, long lparam, double dparam, string sparam);
    bool OnChartClick(int id, long lparam, double dparam, string sparam);
    bool OnObjectClick(int id, long lparam, double dparam, string sparam);
    bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    bool OnObjectEndEdit(int id, long lparam, double dparam, string sparam);
    bool OnChartChange(int id, long lparam, double dparam, string sparam);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickLine::CAcemQuickLine()
{
    m_time = 0;
    m_price = 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickLine::~CAcemQuickLine()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickLine::init()
{
    return true;
}

bool CAcemQuickLine::OnChartEvent(int id, long lparam, double dparam, string sparam)
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

bool CAcemQuickLine::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnObjectCreate(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnObjectDelete(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnObjectClick(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnObjectEndEdit(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemQuickLine::OnChartChange(int id, long lparam, double dparam, string sparam)
{
    return true;
}

