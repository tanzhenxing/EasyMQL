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
    ACCOUNT_DATA  m_account;
    
protected:    
    
public:
    void          Info();        // 获取账户数据
    bool          Save();        // 保存账户信息
    double        FreeMarginCheck(string symbol,int type,double lots){return AccountFreeMarginCheck(symbol,type,lots);};
    
  };
//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
void CAccount::Info()
{
   //--- Account integer properties
   m_account.login              = ::AccountInfoInteger(ACCOUNT_LOGIN);
   m_account.number             = ::AccountNumber();
   m_account.trade_mode         = (ENUM_ACCOUNT_TRADE_MODE)::AccountInfoInteger(ACCOUNT_TRADE_MODE);
   m_account.leverage           = ::AccountInfoInteger(ACCOUNT_LEVERAGE);           // AccountLeverage();
   m_account.limit_orders       = ::AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   m_account.margin_so_mode     = (ENUM_ACCOUNT_STOPOUT_MODE)::AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
   m_account.trade_allowed      = (bool)::AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);
   m_account.trade_expert       = (bool)::AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
   m_account.margin_mode        = #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_MARGIN_MODE) #else 1 #endif ;
   m_account.currency_digits    = #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif ;
   m_account.server_type        = (::TerminalInfoString(TERMINAL_NAME)=="MetaTrader 5" ? 5 : 4);
   m_account.server_connect     = ::IsConnected();
   m_account.fifo_close         = (#ifdef __MQL5__::TerminalInfoInteger(TERMINAL_BUILD)<2155 ? false : ::AccountInfoInteger(ACCOUNT_FIFO_CLOSE) #else false #endif );  
   m_account.stop_out_level     = ::AccountStopoutLevel();
   m_account.stop_out_mode      = ::AccountStopoutMode();
     
   //--- Account real properties
   m_account.balance            = ::AccountInfoDouble(ACCOUNT_BALANCE); // AccountBalance();
   m_account.credit             = ::AccountInfoDouble(ACCOUNT_CREDIT);  // AccountCredit();
   m_account.profit             = ::AccountInfoDouble(ACCOUNT_PROFIT);  // AccountProfit();
   m_account.equity             = ::AccountInfoDouble(ACCOUNT_EQUITY);  // AccountEquity();
   m_account.margin             = ::AccountInfoDouble(ACCOUNT_MARGIN);  // AccountMargin();
   m_account.margin_free        = ::AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   m_account.margin_level       = ::AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   m_account.margin_so_call     = ::AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
   m_account.margin_so_so       = ::AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
   m_account.margin_initial     = ::AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);
   m_account.margin_maintenance = ::AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);
   m_account.assets             = ::AccountInfoDouble(ACCOUNT_ASSETS);
   m_account.liabilities        = ::AccountInfoDouble(ACCOUNT_LIABILITIES);
   m_account.comission_blocked  = ::AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);
   m_account.free_margin        = ::AccountFreeMarginMode();
   m_account.free_margin_mode   = ::AccountFreeMargin();
   
   //--- Account string properties
   m_account.name               = ::AccountInfoString(ACCOUNT_NAME);    // AccountName();
   m_account.server             = ::AccountInfoString(ACCOUNT_SERVER);  // AccountServer();
   m_account.currency           = ::AccountInfoString(ACCOUNT_CURRENCY); // AccountCurrency()
   m_account.company            = ::AccountInfoString(ACCOUNT_COMPANY);  // AccountCompany();
   m_account.expert_name        = ::WindowExpertName();
}
//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
bool CAccount::Save()
{
   Info();
   // 交易账户信息
   string content = "{"
   + "\"ea_running_time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\","
   + "\"ea_name\":\"" + m_account.expert_name + "\","
   + "\"name\":\"" + m_account.name + "\","
   + "\"account_number\":\"" + IntegerToString(m_account.login) + "\","
   + "\"server\":\"" + m_account.server + "\","
   + "\"server_time\":\"" + day_time.FormatDatetime(TimeCurrent()) + "\","
   + "\"connect\":\"" + IntegerToString(m_account.server_connect) + "\","
   + "\"company\":\"" + m_account.company + "\","
   + "\"balance\":\"" + DoubleToStr(m_account.balance,2) + "\","
   + "\"currency\":\"" + m_account.currency + "\","
   + "\"credit\":\"" + DoubleToStr(m_account.credit,2) + "\","
   + "\"equity\":\"" + DoubleToStr(m_account.equity,2) + "\","
   + "\"free_margin_mode\":\"" + DoubleToStr(m_account.free_margin_mode,2) + "\","
   + "\"margin_free\":\"" + DoubleToStr(m_account.free_margin,2) + "\","
   + "\"leverage\":\"" + DoubleToStr(m_account.leverage,2) + "\","
   + "\"margin\":\"" + DoubleToStr(m_account.margin,2) + "\","
   + "\"profit\":\"" + DoubleToStr(m_account.profit,2) + "\","
   + "\"stop_out_level\":\"" + DoubleToStr(m_account.stop_out_level,0) + "\","
   + "\"stop_out_mode\":\"" + IntegerToString(m_account.stop_out_mode) + "\","
   + "\"margin_level\":\"" + DoubleToStr(m_account.margin_level,2) + "\","
   + "\"limit_orders\":\"" + IntegerToString(m_account.limit_orders) + "\","
   + "\"trade_allowed\":\"" + IntegerToString(m_account.trade_allowed) + "\","
   + "\"ea_trade_allowed\":\"" + IntegerToString(m_account.trade_expert) + "\","
   + "\"account_type\":\"" + IntegerToString(m_account.trade_mode) + "\","
   + "\"margin_so_call\":\"" + DoubleToStr(m_account.margin_so_call,0) + "\","
   + "\"margin_so_so\":\"" + DoubleToStr( m_account.margin_so_so,0) + "\""
   + "}";
   // 保存账户信息到文件
   return json.Write(ACCOUNT_INFO,content);
}
