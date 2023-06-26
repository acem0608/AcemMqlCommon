//+------------------------------------------------------------------+
//|                                               AcemSyncObject.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Acem/Common/AcemBase.mqh>

class CAcemSyncObject : public CAcemBase
{
protected:
    virtual bool OnObjectCreate(int id, long lparam, double dparam, string sparam);
public:
    CAcemSyncObject();
    ~CAcemSyncObject();
    void init();
    void deinit(const int reason);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncObject::CAcemSyncObject()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncObject::~CAcemSyncObject()
{
}
//+------------------------------------------------------------------+

void CAcemSyncObject::init()
{
}

void CAcemSyncObject::deinit(const int reason)
{
}

bool CAcemSyncObject::OnObjectCreate(int id, long lparam, double dparam, string sparam)
{

    if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
        string newObjName = sparam;
        if (StringFind(sparam, " ACEM ") == -1) { 
            newObjName = sparam + " ACEM " + ChartID();
            ObjectSetString(ChartID(), sparam, OBJPROP_NAME, newObjName);
            ChartRedraw(ChartID());
        }

        double price1;
        datetime time1;
        long objType;
        ObjectGetInteger(ChartID(), newObjName, OBJPROP_TIME, 0, time1);
        ObjectGetDouble(ChartID(), newObjName, OBJPROP_PRICE,  0, price1);
        ObjectGetInteger(ChartID(), newObjName, OBJPROP_TYPE, 0, objType);
        long targetId;
        for (targetId = ChartFirst();targetId != -1; targetId = ChartNext(targetId)) {
           if (targetId == ChartID()) {
               continue;
           }
        
           if (ChartSymbol(ChartID()) != ChartSymbol(targetId)) {
               continue;
           }
           
           ObjectCreate(targetId, newObjName, objType, 0, time1, price1);

           ChartRedraw(targetId);
        }
    }

    return true;
}
