//+------------------------------------------------------------------+
//|                                                       Market.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include "Symbol.mqh"

CSymbol    symbol;

class CMarket
  {
private:

protected:


public:
  #ifdef __MQL5__
    bool      bookAdd(string name){return MarketBookAdd(name);};         // 提供所选的交易品种的开盘市场深度信息
    bool      bookRelease(string name){return MarketBookRelease(name);}; // 提供所选交易品种的收盘市场报价信息
    bool      bookGet(string name,MqlBookInfo& book[]){return MarketBookGet(name,book);}; // 指定交易品种的市场报价记录
  #endif 
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

