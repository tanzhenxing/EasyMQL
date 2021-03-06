//+------------------------------------------------------------------+
//|                                                       Trader.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include "..\common\Data.mqh"
#include "Market.mqh"
#include "Order.mqh"
#include "History.mqh"
#include "HistoryDeal.mqh"
#include "HistoryOrder.mqh"
#include "Position.mqh"
#include "Search.mqh"

CMarket        market;
COrder         order;
CHistory       history;
CHistoryDeal   history_deal;
CHistoryOrder  history_order;
CPosition      position;
CSearch        search;

//+------------------------------------------------------------------+
//| 交易类                                                           |
//+------------------------------------------------------------------+
class CTrade
  {
private:
    // 开仓失败订单信息
    OPEN_FAIL        m_open_fail;    
    // 订单备注
    string           m_order_comment;
                      
protected: 
    // 清除开仓失败记录
    void             initOpenFail(void){m_open_fail.type=-1;m_open_fail.lots=0;m_open_fail.magic_number=-1;}; 
    // 提交订单到交易服务器
    bool             send(long magic_number,double lots,string symbol,int type,double price=0,int slippage=50,double stop_loss=0,double take_profit=0,datetime expiration=0,color order_color=CLR_NONE);
           
public:  
    // 设置交易配置
    void             set(ENUM_ORDER_PARAM name,string value);
    string           firstSymbol(void){return g_trade_config.first_symbol;};
    string           secondSymbol(void){return g_trade_config.second_symbol;};
    string           comment(void){return g_trade_config.comment;};  
    // 点差
    int              spread(string symbol);  // 开仓点差
    int              groupSpread(void);      // 订单组开仓点差
    // 开仓操作      (参数顺序：magic_number, lots, symbol, type)
    bool             openBuy(long magic_number,double lots,string name){return send(magic_number,lots,name,ORDER_BUY);};
    bool             openSell(long magic_number,double lots,string name){return send(magic_number,lots,name,ORDER_SELL);};
    bool             openGroup(long magic_number,double lots,int type);
    bool             openGroupBuy(long magic_number,double lots);
    bool             openGroupSell(long magic_number,double lots);
    void             openFail(void);
    // 平仓操作
    bool             closeTicket(long ticket);
    bool             closeTicketArr(const long & tickets[]);
    bool             closeGroup(long magic_number,int type);
    bool             closeGroupBuy(long magic_number){return closeGroup(magic_number,ORDER_BUY);};
    bool             closeGroupSell(long magic_number){return closeGroup(magic_number,ORDER_SELL);};
    bool             closeAll(void); 
    bool             closeProfit(double profit,int type);
    bool             closeFail(void);
    // 市场报价
    double           marketPrice(string symbol,int type);
    
  };

int CTrade::spread(string name)
{
    int spread;
    #ifdef __MQL5__
      spread = (int)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
    #else 
      spread = (int)MarketInfo(name,MODE_SPREAD);
    #endif
    return spread;
}
//+------------------------------------------------------------------+
//| 获取订单组开仓点差                                               |
//+------------------------------------------------------------------+
int CTrade::groupSpread()
{
    string first_symbol = g_trade_config.first_symbol;
    string second_symbol = g_trade_config.second_symbol;
    int symbol_spread = 0;
    if(second_symbol=="")
    {
      symbol_spread = spread(first_symbol);
    } else {
      symbol_spread = spread(first_symbol) + spread(second_symbol);
    }
    return symbol_spread;
}
//+------------------------------------------------------------------+
//| 创建新订单                  处理失败 false ，处理成功返回 true   |
//+------------------------------------------------------------------+
bool CTrade::send(long magic_number,double lots,string name,int type,double price,int slippage,double stop_loss,double take_profit,datetime expiration,color order_color)
{
   // 拼接订单备注
   string comment = m_order_comment;
   double ask;
   double bid;
   #ifdef __MQL5__
      bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
      ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   #else 
      bid = MarketInfo(symbol,MODE_BID);
      ask = MarketInfo(symbol,MODE_ASK);
   #endif 
   // 检测货币对是否有效
   if(ask == 0)
   {
      Print("要创建的订单货币对symbol:" + name + " 出错,不开仓");
      return true;
   }
   // 获取市场价
   if(type==ORDER_BUY)
   {
     price = ask;
   } else {
     price = bid;
   }

   // 检测手数是否有效
   if(lots<0.01)
   {
      Print("要创建的订单手数 lots: " + DoubleToString(lots) + " 出错,不开仓");
      return true;
   }
   // 检查魔术号是否有效
   if(magic_number<1)
   {
      Print("要创建的订单magic_number: " + DoubleToString(magic_number) + " 出错,不开仓");
      return true;
   }
   // 检测订单是否存在
   search.select(magic_number,lots,name,type);
   if(search.total()>0)
   {
      Print("不开仓,订单已经存在: symbol=" + name + ",type:" + IntegerToString(type) + ",lots="+ DoubleToString(lots,2) + ",magic_number=" + IntegerToString(magic_number));
      return true;
   }
   // 提交订单
//--- 声明并初始化交易请求和交易请求结果
   MqlTradeRequest request={0};
   MqlTradeResult  result={0};
//--- 请求参数
   request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
   request.symbol   = name;                              // 交易品种
   request.volume   = lots;                                   // 0.2 手交易量
   request.type     = (ENUM_ORDER_TYPE)type;                       // 订单类型
   request.price    = price; // 持仓价格
   request.deviation = slippage;                                     // 允许价格偏差
   request.magic    = magic_number;                          // 订单幻数
   request.comment  = comment;
//--- 发送请求
   int order_send;
   #ifdef __MQL5__
      order_send = OrderSend(request,result);
   #else 
      order_send = OrderSend(symbol,type,lots,price,slippage,stop_loss,take_profit,comment,magic_number,expiration,order_color);
   #endif 
   
   
   if(order_send<0)
   {
      Print("货币对" + name + " 创建订单失败,交易服务器出错或繁忙中, " + name + "," + IntegerToString(type) + "," + DoubleToString(lots) + "," + IntegerToString(magic_number));
      return false;
   }
   // 检测订单是否存在
   search.select(magic_number,lots,name,type);
   if(search.total()<1)
   {
      Print("订单不存在，开仓失败，" + name + ",type:" + IntegerToString(type) + ",lots="+ DoubleToString(lots,2) + ",magic_number=" + IntegerToString(magic_number));
      return false;
   }
   // 返回结果
   return true;
}
//+------------------------------------------------------------------+
//| 创建订单组                                                         |
//+------------------------------------------------------------------+
bool CTrade::openGroup(long magic_number,double lots,int type)
{
   bool open_group = false;
   // 创建订单组
   if(type==ORDER_BUY)
   {
      open_group = openGroupBuy(magic_number,lots);
   }
   if(type==ORDER_SELL)
   {
      open_group = openGroupSell(magic_number,lots);
   }
   return open_group;
}
//+------------------------------------------------------------------+
//| BUY订单组                                                        |
//+------------------------------------------------------------------+
bool CTrade::openGroupBuy(long magic_number,double lots)
{
   string first_symbol = g_trade_config.first_symbol;
   string second_symbol= g_trade_config.second_symbol;
   m_order_comment = g_trade_config.comment  + "_" + IntegerToString(magic_number) + "_buy";
   // 创建订单组
   openBuy(magic_number,lots,first_symbol);
   if(second_symbol!="")
   {
      openSell(magic_number,lots,second_symbol);
   }
   // 检查订单组是否创建成功
   search.selectGroupBuy(magic_number,lots);
   if(search.total()<2)
   {  // 保存创建订单组失败信息
      m_open_fail.type = ORDER_BUY;
      m_open_fail.lots = lots;
      m_open_fail.magic_number = magic_number;
      Print("订单组数量<2 : " + IntegerToString(magic_number) + " 失败");
      return false;
   }
   return true;   
}
//+------------------------------------------------------------------+
//| Sell订单组                                                       |
//+------------------------------------------------------------------+
bool CTrade::openGroupSell(long magic_number,double lots)
{
   string first_symbol = g_trade_config.first_symbol;
   string second_symbol= g_trade_config.second_symbol;
   m_order_comment = g_trade_config.comment  + "_" + IntegerToString(magic_number) + "_sell";
   // 创建订单组
   openSell(magic_number,lots,first_symbol);
   if(second_symbol!="")
   {
      openBuy(magic_number,lots,second_symbol);
   }
   // 检查订单组是否创建成功
   search.selectGroupSell(magic_number,lots);
   if(search.total()<2)
   {  // 保存创建订单组失败信息
      m_open_fail.type = ORDER_SELL;
      m_open_fail.lots = lots;
      m_open_fail.magic_number = magic_number;
      Print("订单组数量<2 : " + IntegerToString(magic_number) + " 失败");
      return false;
   }
   return true;   
}
//+------------------------------------------------------------------+
//| 重开失败订单                                                     |
//+------------------------------------------------------------------+
void CTrade::openFail()
{
     long magic_number = m_open_fail.magic_number;
     double lots = m_open_fail.lots;
     int type = m_open_fail.type;
     // 提交订单到交易服务器
     if(magic_number>0 && lots>0 && type>-1)
     {
        bool open_order = false;
        switch(type)
        {
            case ORDER_BUY:
                 open_order = openGroupBuy(magic_number,lots);
                 break;
            case ORDER_SELL: 
                 open_order = openGroupSell(magic_number,lots);
                 break;
        }
        // 开仓成功，清除开仓失败记录
        if(open_order==true)
        {
           initOpenFail();
        }
     }
     return;
};
//+------------------------------------------------------------------+
//| 关闭指定ticket的订单        返回：true 处理成功，false处理失败   |
//+------------------------------------------------------------------+
bool CTrade::closeTicket(long ticket)
{
   // 检查订单号
   if(ticket<1)
   {  // 无效订单号，处理成功
      Print("无效订单号，ticket：" + IntegerToString(ticket));
      return true; 
   }
   // 检查订单是否存在
   search.find(ticket);
   if(search.total()==0)
   {  // 订单号不存在，处理成功
      Print("订单号ticket：" + IntegerToString(ticket) + " 不存在");
      return true;  
   }
   //--- 声明并初始化交易请求和交易请求结果
   MqlTradeRequest request;
   MqlTradeResult  result;
   // 查找订单
   int total;
   #ifdef __MQL5__
     total = PositionsTotal();
   #else
     total = OrdersTotal(); // 订单总数
   #endif 
   for(int i=0; i<total; i++)
   {
      bool selete;
      #ifdef __MQL5__
         long get_ticket = (long)PositionGetTicket(i);
         selete = (bool)get_ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif 
      if(selete==true)
      {
         long    order_ticket;
         string  order_symbol;
         double  order_lots;
         long   order_type;
         
         #ifdef __MQL5__
           order_ticket = get_ticket;
           order_symbol =  PositionGetString(POSITION_SYMBOL);
           order_lots = PositionGetDouble(POSITION_VOLUME);
           order_type = PositionGetInteger(POSITION_TYPE);
         #else
           order_ticket = OrderTicket();
           order_symbol = OrderSymbol();
           order_lots = OrderLots();
           order_type = OrderType();
         #endif 
         
         if(order_ticket==ticket)
         {
            //--- 归零请求和结果值
            ZeroMemory(request);
            ZeroMemory(result);
            // 获取市场价格
            double ask = 0;
            double bid = 0;
            double price = 0;
            #ifdef __MQL5__
               bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
               ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
            #else 
               bid = MarketInfo(symbol,MODE_BID);
               ask = MarketInfo(symbol,MODE_ASK);
            #endif 
            // 获取市场价
            if(order_type==ORDER_BUY)
            {
              price = ask;
            } else {
              price = bid;
            }
            // 关闭订单
            //--- 设置操作参数
            request.price    = price;
            request.type     = (ENUM_ORDER_TYPE)order_type;
            request.action   = TRADE_ACTION_DEAL;        // 交易操作类型
            request.position = order_ticket;          // 持仓价格
            request.symbol   = order_symbol;          // 交易品种 
            request.volume   = order_lots;                   // 持仓交易量
            request.deviation= 100;                        // 允许价格偏差
            // request.magic    = EXPERT_MAGIC;             // 持仓幻数
            
            bool order_close;
            #ifdef __MQL5__
               order_close = OrderSend(request,result);
            #else 
               order_close = OrderClose(ticket,order_lots,price,200,CLR_NONE);
            #endif 
         }     
      }
   }
   // 检查订单是否存在
   search.find(ticket);
   if(search.total()==0)
   {  // 订单号不存在，平仓成功
      return true;   
   }
   // 返回结果
   return false;
}
//+------------------------------------------------------------------+
//| 关闭订单号数组                                                   |
//+------------------------------------------------------------------+
bool CTrade::closeTicketArr(const long & tickets[])
{
    int total = ArraySize(tickets);
    // 关闭订单
    for(int i=0;i<total;i++)
    {  // 平仓失败，复制订单号到带平仓数组
       if(tickets[i]>0 && closeTicket(tickets[i])==false)
       {  
          ArrayResize(close_arr,total);
          ArrayCopy(close_arr,tickets);
          return false;
       }
    }
    return true;
}
//+------------------------------------------------------------------+
//| 关闭订单组                                                       |
//+------------------------------------------------------------------+
bool CTrade::closeGroup(long magic_number,int type)
{
   string first_symbol = g_trade_config.first_symbol;
   string second_symbol = g_trade_config.second_symbol;
   if(magic_number<0)
   {
      Print("魔术号: " + IntegerToString(magic_number) + " 出错，不平仓");
      return true;
   }
   search.selectGroup(magic_number,0,type);
   bool close_group = closeTicketArr(tem_arr);
   if(close_group==false)
   {
      return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//| 关闭所有持仓订单                                                 |
//+------------------------------------------------------------------+
bool CTrade::closeAll()
{
   // 订单总数
   int total;
   #ifdef __MQL5__
   total = PositionsTotal();
   #else
   total = OrdersTotal(); // 订单总数
   #endif 
   // 遍历订单
   for(int i=0;i<total;i++)
   {
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)PositionGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif
      if(selete==true)
      {
         long    order_ticket;
         #ifdef __MQL5__
           order_ticket = ticket;
         #else
           order_ticket = OrderTicket();
         #endif
         if(closeTicket(order_ticket)==false)
         {
            Print("ticket:" + IntegerToString(order_ticket) + " 平仓出错，全部平仓未完成");
            return false;
         }
      }
   }
   // 检查订单是否已经全部平仓
   if(total==0)
   {
      TerminalClose(0); // 关闭终端
   }
   return true;
}
//+------------------------------------------------------------------+
//| 关闭达到止盈条件的订单                                           |
//+------------------------------------------------------------------+
bool CTrade::closeProfit(double profit,int type)
{
   string first_symbol = g_trade_config.first_symbol;
   string second_symbol = g_trade_config.second_symbol;
   // 获取魔术号列表
   search.selectMagicNumber(type);
   int total = ArraySize(magic_number_arr);
   for(int i=0; i<total; i++)
   {
       // buy方向
       int magic_number = magic_number_arr[i];
       search.selectGroupBuy(magic_number);
       if(search.realProfit()>profit)
       {
          if(closeGroupBuy(magic_number)==false)
          {
             return false;
          }
       }
       // sell方向
       search.selectGroupSell(magic_number);
       if(search.realProfit()>profit)
       {
          if(closeGroupSell(magic_number)==false)
          {
             return false;
          }
       }
   }
   return true;
}
//+------------------------------------------------------------------+
//| 关闭平仓失败订单                                                 |
//+------------------------------------------------------------------+
bool CTrade::closeFail()
{
    int total = ArraySize(close_arr);
    // 关闭订单
    for(int i=0;i<total;i++)
    {
       if(closeTicket(close_arr[i])==false)
       {
          return false;
       }
    }
    // 全部平仓成功，清空订单号
    ArrayFree(close_arr);
    return true;
}
//+------------------------------------------------------------------+
//| 市场报价                                                         |
//+------------------------------------------------------------------+
double CTrade::marketPrice(string name,int type)
{
   double ask;
   double bid;
   #ifdef __MQL5__
      bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
      ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   #else 
      bid = MarketInfo(name,MODE_BID);
      ask = MarketInfo(name,MODE_ASK);
   #endif 
   // 获取市场价
    double price = 0;
    if(type==ORDER_BUY)
    {
       price = ask; // 买入价
    }
    if(type==ORDER_SELL)
    {
       price = bid; // 卖出价
    }
    return price;             
}
//+------------------------------------------------------------------+
//|     交易配置                                                     |
//+------------------------------------------------------------------+
void CTrade::set(ENUM_ORDER_PARAM name,string value)
{
     switch(name)
     {
        case FIRST_SYMBOL:
             g_trade_config.first_symbol = value;
             break;
        case SECOND_SYMBOL:
             g_trade_config.second_symbol = value;
             break;   
        case COMMENT:
             g_trade_config.comment = value;
             break;    
     }
     return;
}