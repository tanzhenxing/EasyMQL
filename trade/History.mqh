//+------------------------------------------------------------------+
//|                                                      History.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CHistory
  {
private:

protected:

public:
   int           total(void){return HistoryDealsTotal();};
   bool          select(datetime begin_time,datetime end_time){return HistorySelect(begin_time,end_time);};
   bool          selectByPosition(long id){return HistorySelectByPosition(id);};
  };
  