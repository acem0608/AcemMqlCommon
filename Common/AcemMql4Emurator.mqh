//+------------------------------------------------------------------+
//|                                             AcemMql4Emurator.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
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
#ifndef __ACEM_MQL4_EMULATOR__
#define __ACEM_MQL4_EMULATOR__
#ifdef __MQL5__

int WindowFirstVisibleBar()
{
    int firstBarIndex = ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
    
    return firstBarIndex;
}


int WindowBarsPerChart()
{
    int chartBarNum = ChartGetInteger(0,CHART_VISIBLE_BARS,0);
    
    return chartBarNum;
}
#endif
#endif