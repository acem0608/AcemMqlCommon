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
    bool m_bSyncMode;

    virtual string getNewObjName();
    
public:
    CAcemQuickEditBase();
    CAcemQuickEditBase(string objPrefix);
    ~CAcemQuickEditBase();
    
    virtual void init();
    void setMouseToTimePrice(long lparam, double dparam);
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
    m_bSyncMode = false;
}

CAcemQuickEditBase::CAcemQuickEditBase(string objPrefix)
{
    m_time = 0;
    m_price = 0.0;
    m_objNamePrefix = objPrefix;
    m_objNameIndex = 0;
    m_bSyncMode = false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickEditBase::~CAcemQuickEditBase()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickEditBase::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    setMouseToTimePrice(lparam, dparam);
    
    m_bSyncMode = isCtrlDown(sparam);
    
    return true;
}

void CAcemQuickEditBase::setMouseToTimePrice(long lparam, double dparam)
{
    int windowNo;
    datetime mouseTime;
    double mousePrice;
    if (!ChartXYToTimePrice(ChartID(), (int)lparam, (int)dparam, windowNo, mouseTime, mousePrice))
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
    datetime currentTime = TimeLocal();
    ulong num = (ulong)currentTime;
    string strHexNum = convIntToHexString(num);
    if (m_bSyncMode) {
        objName = ACEM_IDENTIFER + " " + ACEM_SYNC_KEYWORD + " " + m_objNamePrefix + " " + strHexNum;
    } else {
        objName = ACEM_IDENTIFER + " " + m_objNamePrefix + " " + strHexNum;
    }

    return objName;
}
