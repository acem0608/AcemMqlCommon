//+------------------------------------------------------------------+
//|                                                     AcemBase.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
class CAcemBase
{
private:
public:
    CAcemBase();
    ~CAcemBase();

    virtual bool OnChartEvent(int id, long lparam, double dparam, string sparam);
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectCreate(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDelete(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectClick(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectEndEdit(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemBase::CAcemBase()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemBase::~CAcemBase()
{
}
//+------------------------------------------------------------------+

bool CAcemBase::OnChartEvent(int id, long lparam, double dparam, string sparam)
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

bool CAcemBase::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnObjectCreate(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnObjectDelete(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnObjectClick(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnObjectEndEdit(int id, long lparam, double dparam, string sparam)
{
    return true;
}

bool CAcemBase::OnChartChange(int id, long lparam, double dparam, string sparam)
{
    return true;
}

