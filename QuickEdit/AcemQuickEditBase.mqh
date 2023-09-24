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
#include <Acem/Common/AcemDefine.mqh>
#include <Acem/Common/AcemUtility.mqh>

#define KEYCODE_ESC 27

class CAcemQuickEditBase : public CAcemBase
{
private:

protected:
    long m_time;
    double m_price;
    string m_objNamePrefix;
    long m_objNameIndex; 

    virtual string getNewObjName();
    
public:
    CAcemQuickEditBase();
    CAcemQuickEditBase(string objPrefix);
    ~CAcemQuickEditBase();
    
    virtual void init();
    void setMouseToTimePrice(long lparam, double dparam);
    virtual bool OnChartEvent(int id, long lparam, double dparam, string sparam);
    virtual bool setDefalutProp(string objName);
    virtual bool isEditing() {return false;};

    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
   
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickEditBase::CAcemQuickEditBase()
{
    m_time = 0;
    m_price = 0.0;
    m_objNamePrefix = "";
    m_objNameIndex = 0;
}

CAcemQuickEditBase::CAcemQuickEditBase(string objPrefix)
{
    m_time = 0;
    m_price = 0.0;
    m_objNamePrefix = objPrefix;
    m_objNameIndex = 0;
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

bool CAcemQuickEditBase::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    setMouseToTimePrice(lparam, dparam);
    
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

string CAcemQuickEditBase::getNewObjName()
{
    string objName;
    do {
        objName = m_objNamePrefix + IntegerToString(m_objNameIndex++, 5, '0')+ " " + ACEM_IDENTIFER + " " + IntegerToString(ChartID());
    } while (ObjectFind(ChartID(), objName) >= 0);

    return objName;
}
