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
private:
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
