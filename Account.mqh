//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>
#include <EasyMQL\Config.mqh>

class CAccount : public CObject
  {
private:
    
protected:    
    
public:
    string        Info();
    bool          Save(){return json.Write(ACCOUNT_INFO,Info());};  // 保存账户信息
  };

//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
string CAccount::Info()
{
   // 交易账户信息
   string content = "{"
   + "\"ea_running_time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\","
   + "\"ea_name\":\"" + WindowExpertName() + "\","
   + "\"name\":\"" + AccountName() + "\","
   + "\"account_number\":\"" + IntegerToString(AccountNumber()) + "\","
   + "\"server\":\"" + AccountServer() + "\","
   + "\"server_time\":\"" + day_time.FormatDatetime(TimeCurrent()) + "\","
   + "\"connect\":\"" + IntegerToString(IsConnected()) + "\","
   + "\"company\":\"" + AccountCompany() + "\","
   + "\"balance\":\"" + DoubleToStr(AccountBalance(),2) + "\","
   + "\"currency\":\"" + AccountCurrency() + "\","
   + "\"credit\":\"" + DoubleToStr(AccountCredit(),2) + "\","
   + "\"equity\":\"" + DoubleToStr(AccountEquity(),2) + "\","
   + "\"free_margin_mode\":\"" + IntegerToString(AccountFreeMarginMode()) + "\","
   + "\"margin_free\":\"" + DoubleToStr(AccountFreeMargin(),2) + "\","
   + "\"leverage\":\"" + DoubleToStr(AccountLeverage(),2) + "\","
   + "\"margin\":\"" + DoubleToStr(AccountMargin(),2) + "\","
   + "\"profit\":\"" + DoubleToStr(AccountProfit(),2) + "\","
   + "\"stop_out_level\":\"" + DoubleToStr(AccountStopoutLevel(),0) + "\","
   + "\"stop_out_mode\":\"" + IntegerToString(AccountStopoutMode()) + "\","
   + "\"margin_level\":\"" + DoubleToStr(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL),2) + "\","
   + "\"limit_orders\":\"" + IntegerToString(AccountInfoInteger(ACCOUNT_LIMIT_ORDERS)) + "\","
   + "\"trade_allowed\":\"" + IntegerToString(AccountInfoInteger(ACCOUNT_TRADE_ALLOWED)) + "\","
   + "\"ea_trade_allowed\":\"" + IntegerToString(AccountInfoInteger(ACCOUNT_TRADE_EXPERT)) + "\","
   + "\"account_type\":\"" + IntegerToString(AccountInfoInteger(ACCOUNT_TRADE_MODE)) + "\","
   + "\"margin_so_call\":\"" + DoubleToStr(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL),0) + "\","
   + "\"margin_so_so\":\"" + DoubleToStr(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO),0) + "\""
   + "}";
   return content;
}
