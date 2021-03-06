//+------------------------------------------------------------------+
//|                                                       Export.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include "Config.mqh"

class CExport
  {
private:

protected:

public:
     string        AccountInfo();
     
  };

//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
string CExport::AccountInfo()
{
   // 交易账户信息
   string content = "{"
   + "\"ea_running_time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\","
   + "\"ea_name\":\"" + mql.ProgramName() + "\","
   + "\"name\":\"" + account.Name() + "\","
   + "\"account_number\":\"" + IntegerToString(account.Login()) + "\","
   + "\"server\":\"" + account.Server() + "\","
   + "\"server_time\":\"" + day_time.FormatDatetime(day_time.NowTime()) + "\","
   + "\"connect\":\"" + IntegerToString(terminal.Connected()) + "\","
   + "\"company\":\"" + account.Company() + "\","
   + "\"balance\":\"" + DoubleToString(account.Balance(),2) + "\","
   + "\"currency\":\"" + account.Currency() + "\","
   + "\"credit\":\"" + DoubleToString(account.Credit(),2) + "\","
   + "\"equity\":\"" + DoubleToString(account.Equity(),2) + "\","
   + "\"margin_free\":\"" + DoubleToString(account.MarginFree(),2) + "\","
   + "\"leverage\":\"" + DoubleToString(account.Leverage(),2) + "\","
   + "\"margin\":\"" + DoubleToString(account.Margin(),2) + "\","
   + "\"profit\":\"" + DoubleToString(account.Profit(),2) + "\","
   + "\"stop_out_level\":\"" + DoubleToString(account.StopOutLevel(),0) + "\","
   + "\"margin_level\":\"" + DoubleToString(account.MarginLevel(),2) + "\","
   + "\"limit_orders\":\"" + IntegerToString(account.LimitOrders()) + "\","
   + "\"trade_allowed\":\"" + IntegerToString(account.TradeAllowed()) + "\","
   + "\"ea_trade_allowed\":\"" + IntegerToString(account.TradeExpert()) + "\","
   + "\"account_type\":\"" + IntegerToString(account.TradeMode()) + "\","
   + "\"margin_so_call\":\"" + DoubleToString(account.MarginSoCall(),0) + "\","
   + "\"margin_so_so\":\"" + DoubleToString(account.MarginSoSo(),0) + "\""
   + "}";
   return content;
}
