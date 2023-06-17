//+------------------------------------------------------------------+
//|                                                  AcemUtility.mph |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property strict

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
    datetime time = convPosXToTime(chartId, x);
    int index = iBarShift(ChartSymbol(chartId), ChartPeriod(chartId), time, false);
    
    return index;
}

datetime convPosXToTime(long chartId, int x)
{
    datetime time;
    int posY = 0;
    double price;
    int subwindos;
   
    ChartXYToTimePrice(chartId, x, posY, subwindos, time, price);

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
    int posX = convTimeToPosX(chartId, time);
    int index = convPosXToIndex(chartId, posX);

    return index;
}

#endif