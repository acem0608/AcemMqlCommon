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

int convIndexToPosX(int index)
{
    int posX;
    int posY;
    double price = 1.0;
    datetime time = convIndexToTime(index);
    ChartTimePriceToXY(ChartID(), 0, time, price, posX, posY);

    return posX;
}

datetime convIndexToTime(int index)
{
    datetime time  = iTime(ChartSymbol(ChartID()), ChartPeriod(ChartID()), index);

    return time;
}
int convPosXToIndex(int x)
{
    datetime time = convPosXToTime(x);
    int index = iBarShift(ChartSymbol(ChartID()), ChartPeriod(ChartID()), time, false);
    
    return index;
}

datetime convPosXToTime(int x)
{
    datetime time;
    int posY = 0;
    double price;
    int subwindos;
   
    ChartXYToTimePrice(ChartID(), x, posY, subwindos, time, price);

    return time;
}

int convTimeToPosX(datetime time)
{
    int posX;
    int posY;
    double price = 1;
    ChartTimePriceToXY(ChartID(), 0, time, price, posX, posY);

    return posX;
}

int convTimeToIndex(datetime time)
{
    int posX = convTimeToPosX(time);
    int index = convPosXToIndex(posX);

    return index;
}

#endif