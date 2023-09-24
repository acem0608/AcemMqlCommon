//+------------------------------------------------------------------+
//|                                                  AcemUtility.mph |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property strict

#include <Acem/Common/AcemMql4Emurator.mqh>

#ifndef ACEM_UTILITY
#define ACEM_UTILITY

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

int convIndexToPosX(long chartId, int index)
{
    int posX;
    int posY;
    double price = 1.0;
    datetime time = convIndexToTime(chartId, index);
    ChartTimePriceToXY(chartId, 0, time, price, posX, posY);

    return posX;
}

datetime convIndexToTime(long chartId, int index)
{
    datetime time  = iTime(ChartSymbol(chartId), ChartPeriod(chartId), index);

    return time;
}
int convPosXToIndex(long chartId, int x)
{
    int leftIndex = WindowFirstVisibleBar();
    int leftPosX = convIndexToPosX(ChartID(), leftIndex);
    int width = (int)MathPow(2, ChartGetInteger(chartId, CHART_SCALE));
    int shift = (int)MathRound((leftPosX - x) / width);
    int index = leftIndex + shift;

    return index;
}

datetime convPosXToTime(long chartId, int x)
{
    datetime time;
    int posY = 0;
    double price;
    int subwindos;
   
     bool bRetc =ChartXYToTimePrice(chartId, x, posY, subwindos, time, price);
         
    return time;
}

int convTimeToPosX(long chartId, datetime time)
{
    int posX;
    int posY;
    double price = 1;
    ChartTimePriceToXY(chartId, 0, time, price, posX, posY);

    return posX;
}

int convTimeToIndex(long chartId, datetime time)
{
    int index = iBarShift(ChartSymbol(chartId), ChartPeriod(chartId), time, false);
    
    return index;
}

bool isSameIndicator(long chartId, string checkName)
{
    int indicatorNum = ChartIndicatorsTotal(chartId, 0);
    int i;
    int indiNum = 0;
    for (i = 0; i < indicatorNum; i++) {
        string indiName = ChartIndicatorName(chartId, 0, i);
        if (indiName == checkName) {
          indiNum++;
        }
    }
    
    if (indiNum > 1)
    {
        return true;
    }

    return false;
}

bool cloneObject(long fromChartId, string fromObjName, long toChartId, string toObjName)
{
    if (ObjectFind(toChartId, toObjName) >= 0) {
        return false;
    }

    long objType;
    double price1;
    double price2;
    double price3;
    datetime time1;
    datetime time2;
    datetime time3;
    ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TYPE, 0, objType);
    ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIME, 0, time1);
    ObjectGetDouble(fromChartId, fromObjName, OBJPROP_PRICE,  0, price1);
    ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIME, 1, time2);
    ObjectGetDouble(fromChartId, fromObjName, OBJPROP_PRICE,  1, price2);
    ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIME, 2, time3);
    ObjectGetDouble(fromChartId, fromObjName, OBJPROP_PRICE,  2, price3);
    
    ObjectCreate(toChartId, toObjName, (ENUM_OBJECT)objType, 0, time1, price1, time2, price2, time3, price3);

    setSameProp(fromChartId, fromObjName, toChartId, toObjName);
    
    return true;
}

void setSameProp(long fromChartId, string fromObjName, long toChartId, string toObjName)
{
    if (ObjectFind(toChartId, toObjName) < 0) {
        return;
    }
    
    //Integerの設定
    long intVal;
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_COLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_COLOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_STYLE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_STYLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_WIDTH, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_WIDTH, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_BACK, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_BACK, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_ZORDER, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_ZORDER, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_FILL, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_FILL, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_HIDDEN, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_HIDDEN, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_STYLE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_STYLE, 0, intVal);
    }
    
    // 非選択とする
    //if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_SELECTED, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_SELECTED, 0, false);
    //}
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_SELECTED, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_SELECTED, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIME, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_TIME, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIME, 1, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_TIME, 1, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIME, 2, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_TIME, 2, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_SELECTABLE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_SELECTABLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_LEVELS, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_LEVELS, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_LEVELCOLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_LEVELCOLOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_LEVELSTYLE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_LEVELSTYLE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_LEVELWIDTH, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_LEVELWIDTH, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_ALIGN, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_ALIGN, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_FONTSIZE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_FONTSIZE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_RAY_RIGHT, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_RAY_RIGHT, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_ELLIPSE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_ELLIPSE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_ARROWCODE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_ARROWCODE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_TIMEFRAMES, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_TIMEFRAMES, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_ANCHOR, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_ANCHOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_XDISTANCE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_XDISTANCE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_YDISTANCE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_YDISTANCE, 0, intVal);
    }
//    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_DRAWLINES, 0, intVal)) {
//        ObjectSetInteger(toChartId, toObjName, OBJPROP_DRAWLINES, 0, intVal);
//    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_STATE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_STATE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_XSIZE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_XSIZE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_YSIZE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_YSIZE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_XOFFSET, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_XOFFSET, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_YOFFSET, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_YOFFSET, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_BGCOLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_BGCOLOR, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_CORNER, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_CORNER, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_BORDER_TYPE, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_BORDER_TYPE, 0, intVal);
    }
    if (ObjectGetInteger(fromChartId, fromObjName, OBJPROP_BORDER_COLOR, 0, intVal)) {
        ObjectSetInteger(toChartId, toObjName, OBJPROP_BORDER_COLOR, 0, intVal);
    }

    //Doubleの設定
    double dooubleVal;
    if (ObjectGetDouble(fromChartId, fromObjName, OBJPROP_PRICE, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, toObjName, OBJPROP_PRICE, 0, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, fromObjName, OBJPROP_PRICE, 1, dooubleVal)) {
        ObjectSetDouble(toChartId, toObjName, OBJPROP_PRICE, 1, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, fromObjName, OBJPROP_PRICE, 2, dooubleVal)) {
        ObjectSetDouble(toChartId, toObjName, OBJPROP_PRICE, 2, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, fromObjName, OBJPROP_LEVELVALUE, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, toObjName, OBJPROP_LEVELVALUE, 0, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, fromObjName, OBJPROP_ANGLE, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, toObjName, OBJPROP_ANGLE, 0, dooubleVal);
    }
    if (ObjectGetDouble(fromChartId, fromObjName, OBJPROP_DEVIATION, 0, dooubleVal)) {
        ObjectSetDouble(toChartId, toObjName, OBJPROP_DEVIATION, 0, dooubleVal);
    }
    
    //文字列の設定
    string strVal;
    if (ObjectGetString(fromChartId, fromObjName, OBJPROP_TEXT, 0, strVal)) {
        ObjectSetString(toChartId, toObjName, OBJPROP_TEXT, 0, strVal);
    }
    if (ObjectGetString(fromChartId, fromObjName, OBJPROP_TOOLTIP, 0, strVal)) {
        ObjectSetString(toChartId, toObjName, OBJPROP_TOOLTIP, 0, strVal);
    }
    if (ObjectGetString(fromChartId, fromObjName, OBJPROP_LEVELTEXT, 0, strVal)) {
        ObjectSetString(toChartId, toObjName, OBJPROP_LEVELTEXT, 0, strVal);
    }
    if (ObjectGetString(fromChartId, fromObjName, OBJPROP_FONT, 0, strVal)) {
        ObjectSetString(toChartId, toObjName, OBJPROP_FONT, 0, strVal);
    }
    if (ObjectGetString(fromChartId, fromObjName, OBJPROP_BMPFILE, 0, strVal)) {
        ObjectSetString(toChartId, toObjName, OBJPROP_BMPFILE, 0, strVal);
    }
}

#endif