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
    CAcemSyncObject(){};

    string m_strIndiName;
    
    virtual bool OnObjectCreate(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    
    void cloneObject(string objName, long fromChartId, long toChartId);
    void setSameProp(string objName, long fromChartId, long toChartId);
    void syncChartObject(string objName, long fromChartId, long toChartId);
public:
    CAcemSyncObject(string indiDname);
    ~CAcemSyncObject();
    void init();
    void deinit(const int reason);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemSyncObject::CAcemSyncObject(string indiDname)
{
    m_strIndiName = indiDname;
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
        long fromChartId = ChartID();
        string newObjName = sparam;
        if (StringFind(sparam, " ACEM ") == -1) { 
            newObjName = sparam + " ACEM " + ChartID();
            ObjectSetString(fromChartId, sparam, OBJPROP_NAME, newObjName);
        }

        long toChartId;
        for (toChartId = ChartFirst();toChartId != -1; toChartId = ChartNext(toChartId)) {
            syncChartObject(newObjName, fromChartId, toChartId);
        }
    }

    return true;
}

bool CAcemSyncObject::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{

    if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
        long fromChartId = ChartID();
        long toChartId;
        for (toChartId = ChartFirst();toChartId != -1; toChartId = ChartNext(toChartId)) {
           if (toChartId == fromChartId) {
               continue;
           }
        
           if (ChartSymbol(ChartID()) != ChartSymbol(toChartId)) {
               continue;
           }
           
           setSameProp(sparam, fromChartId, toChartId);
           ChartRedraw(toChartId);
        }
    }
    return true;
}

bool CAcemSyncObject::OnObjectChange(int id, long lparam, double dparam, string sparam)
{

    if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP)) {
        long fromChartId = ChartID();
        long toChartId;
        for (toChartId = ChartFirst();toChartId != -1; toChartId = ChartNext(toChartId)) {
           if (toChartId == fromChartId) {
               continue;
           }
        
           if (ChartSymbol(ChartID()) != ChartSymbol(toChartId)) {
               continue;
           }
           
           setSameProp(sparam, fromChartId, toChartId);
           ChartRedraw(toChartId);
        }
    }
    return true;
}


void CAcemSyncObject::syncChartObject(string objName, long fromChartId, long toChartId)
{
    if (toChartId == fromChartId) {
       return;
    }
    
    if (ChartSymbol(ChartID()) != ChartSymbol(toChartId)) {
       return;
    }
    
    string strIndiName;
    int i;
    int indiNum = ChartIndicatorsTotal(toChartId, 0);
    for (i = 0; i < indiNum; i++) {
        strIndiName = ChartIndicatorName(toChartId, 0, i);
        if (strIndiName == m_strIndiName) {
            if (ObjectFind(toChartId, objName) < 0) {
                cloneObject(objName, fromChartId, toChartId);
            }
            setSameProp(objName, fromChartId, toChartId);
            ChartRedraw(toChartId);
            break;
        }
    }
}

void CAcemSyncObject::cloneObject(string objName, long fromChartId, long toChartId)
{
    long objType;
    double price1;
    double price2;
    double price3;
    datetime time1;
    datetime time2;
    datetime time3;
    ObjectGetInteger(fromChartId, objName, OBJPROP_TYPE, 0, objType);
    ObjectGetInteger(fromChartId, objName, OBJPROP_TIME, 0, time1);
    ObjectGetDouble(fromChartId, objName, OBJPROP_PRICE,  0, price1);
    ObjectGetInteger(fromChartId, objName, OBJPROP_TIME, 1, time2);
    ObjectGetDouble(fromChartId, objName, OBJPROP_PRICE,  1, price2);
    ObjectGetInteger(fromChartId, objName, OBJPROP_TIME, 2, time3);
    ObjectGetDouble(fromChartId, objName, OBJPROP_PRICE,  2, price3);
    
    ObjectCreate(toChartId, objName, objType, 0, time1, price1, time2, price2, time3, price3);

    setSameProp(objName, fromChartId, toChartId);
}

void CAcemSyncObject::setSameProp(string objName, long fromChartId, long toChartId)
{
    if (ObjectFind(toChartId, objName) < 0) {
        return;
    }
    
    //Integerの設定
    long intVal;
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_COLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_COLOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_STYLE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_STYLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_WIDTH, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_WIDTH, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_BACK, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_BACK, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_ZORDER, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_ZORDER, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_FILL, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_FILL, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_HIDDEN, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_HIDDEN, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_STYLE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_STYLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_SELECTED, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_SELECTED, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_SELECTED, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_SELECTED, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_TIME, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_TIME, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_TIME, 1, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_TIME, 1, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_TIME, 2, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_TIME, 2, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_SELECTABLE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_SELECTABLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_LEVELS, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_LEVELS, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_LEVELCOLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_LEVELCOLOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_LEVELSTYLE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_LEVELSTYLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_LEVELWIDTH, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_LEVELWIDTH, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_ALIGN, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_ALIGN, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_FONTSIZE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_FONTSIZE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_RAY_RIGHT, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_RAY_RIGHT, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_ELLIPSE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_ELLIPSE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_ARROWCODE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_ARROWCODE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_TIMEFRAMES, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_TIMEFRAMES, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_ANCHOR, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_ANCHOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_XDISTANCE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_XDISTANCE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_YDISTANCE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_YDISTANCE, 0, intVal);
    }
//    if (ObjectGetInteger(fromChartId, objName, OBJPROP_DRAWLINES, 0, intVal)) {
//        ObjectSetInteger(toChartId, objName, OBJPROP_DRAWLINES, 0, intVal);
//    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_STATE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_STATE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_XSIZE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_XSIZE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_YSIZE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_YSIZE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_XOFFSET, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_XOFFSET, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_YOFFSET, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_YOFFSET, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_BGCOLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_BGCOLOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_CORNER, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_CORNER, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_BORDER_TYPE, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_BORDER_TYPE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, objName, OBJPROP_BORDER_COLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, objName, OBJPROP_BORDER_COLOR, 0, intVal);
    }

    //Doubleの設定
    double dooubleVal;
    if (ObjectGetDouble(fromChartId, objName, OBJPROP_PRICE, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, objName, OBJPROP_PRICE, 0, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, objName, OBJPROP_PRICE, 1, dooubleVal)) {
        ObjectSetDouble(toChartId, objName, OBJPROP_PRICE, 1, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, objName, OBJPROP_PRICE, 2, dooubleVal)) {
        ObjectSetDouble(toChartId, objName, OBJPROP_PRICE, 2, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, objName, OBJPROP_LEVELVALUE, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, objName, OBJPROP_LEVELVALUE, 0, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, objName, OBJPROP_ANGLE, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, objName, OBJPROP_ANGLE, 0, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, objName, OBJPROP_DEVIATION, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, objName, OBJPROP_DEVIATION, 0, dooubleVal);
    }
    
    //文字列の設定
    string strVal;
    if (ObjectGetString(fromChartId, objName, OBJPROP_TEXT, 0, strVal)) {
        ObjectSetString(toChartId, objName, OBJPROP_TEXT, 0, strVal);
    }
    if (ObjectGetString(fromChartId, objName, OBJPROP_TOOLTIP, 0, strVal)) {
        ObjectSetString(toChartId, objName, OBJPROP_TOOLTIP, 0, strVal);
    }
    if (ObjectGetString(fromChartId, objName, OBJPROP_LEVELTEXT, 0, strVal)) {
        ObjectSetString(toChartId, objName, OBJPROP_LEVELTEXT, 0, strVal);
    }
    if (ObjectGetString(fromChartId, objName, OBJPROP_FONT, 0, strVal)) {
        ObjectSetString(toChartId, objName, OBJPROP_FONT, 0, strVal);
    }
    if (ObjectGetString(fromChartId, objName, OBJPROP_BMPFILE, 0, strVal)) {
        ObjectSetString(toChartId, objName, OBJPROP_BMPFILE, 0, strVal);
    }
}
