//+------------------------------------------------------------------+
//|                                                 AcemDrawBase.mqh |
//|                                             Copyright 2023, Acem |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Canvas/Canvas.mqh>

class CAcemDrawBase
  {
private:
    CCanvas m_canavs;
    int m_width;    //  
    int m_height;
public:
                     CAcemDrawBase();
                    ~CAcemDrawBase();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemDrawBase::CAcemDrawBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemDrawBase::~CAcemDrawBase()
  {
  }
//+------------------------------------------------------------------+
