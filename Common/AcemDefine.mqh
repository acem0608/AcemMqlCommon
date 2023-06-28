//+------------------------------------------------------------------+
//|                                                   AcemDefine.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property strict
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
#ifndef _ACEM_DEFINE
#define _ACEM_DEFINE

#define ACEM_SYNC_ADD_CODE "AcemSyncAdd"
#define ACEM_SYNC_MOD_CODE "AcemSyncMod"
#define ACEM_SYNC_DEL_CODE "AcemSyncDel"
#define ACEM_SYNC_OTHER_CHART_ADD "AcemSyncSAd"
#define ACEM_SYNC_OTHER_CHART_MOD "AcemSyncSmd"

#define ACEM_SYNC_BASE_LINE_NAME "AcemSyncBaseLine"


enum eInputKeyCode
{
    ACEM_KEYCODE_ESC = 27,// ESC
    ACEM_KEYCODE_0 = 48, // 0
    ACEM_KEYCODE_1 = 49, // 1
    ACEM_KEYCODE_2 = 50, // 2
    ACEM_KEYCODE_3 = 51, // 3
    ACEM_KEYCODE_4 = 52, // 4
    ACEM_KEYCODE_5 = 53, // 5
    ACEM_KEYCODE_6 = 54, // 6
    ACEM_KEYCODE_7 = 55, // 7
    ACEM_KEYCODE_8 = 56, // 8
    ACEM_KEYCODE_9 = 57, // 9
    ACEM_KEYCODE_A = 65, // A
    ACEM_KEYCODE_B = 66, // B
    ACEM_KEYCODE_C = 67, // C
    ACEM_KEYCODE_D = 68, // D
    ACEM_KEYCODE_E = 69, // E
    ACEM_KEYCODE_F = 70, // F
    ACEM_KEYCODE_G = 71, // G
    ACEM_KEYCODE_H = 72, // H
    ACEM_KEYCODE_I = 73, // I
    ACEM_KEYCODE_J = 74, // J
    ACEM_KEYCODE_K = 75, // K
    ACEM_KEYCODE_L = 76, // L
    ACEM_KEYCODE_M = 77, // M
    ACEM_KEYCODE_N = 78, // N
    ACEM_KEYCODE_O = 79, // O
    ACEM_KEYCODE_P = 80, // P
    ACEM_KEYCODE_Q = 81, // Q
    ACEM_KEYCODE_R = 82, // R
    ACEM_KEYCODE_S = 83, // S
    ACEM_KEYCODE_T = 84, // T
    ACEM_KEYCODE_U = 85, // U
    ACEM_KEYCODE_V = 86, // V
    ACEM_KEYCODE_W = 87, // W
    ACEM_KEYCODE_X = 88, // X
    ACEM_KEYCODE_Y = 89, // Y
    ACEM_KEYCODE_Z = 90 // Z
};

enum eLineWidth
{
   LINE_WIDTH_1  = 1, //1
   LINE_WIDTH_2  = 2, //2
   LINE_WIDTH_3  = 3, //3
   LINE_WIDTH_4  = 4, //4
   LINE_WIDTH_5  = 5 //5
};

#endif