//+------------------------------------------------------------------+
//|                                                       Trader.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>
#include <EasyMQL\Account.mqh>
#include <EasyMQL\Order.mqh>
#include <EasyMQL\History.mqh>

// 全局变量
CAccount  account;
COrder    order;
CHistory  history;
CConfig   config;

//+------------------------------------------------------------------+
//| 交易类                                                           |
//+------------------------------------------------------------------+
class CTrader : public CObject
  {
private:
    // 开仓失败订单信息
    OPEN_FAIL        m_open_fail;
    // 订单备注
    string           m_order_comment;
                      
protected: 
    // 清除开仓失败记录
    void             InitOpenFail(void){m_open_fail.type=-1;m_open_fail.lots=0;m_open_fail.magic_number=-1;}; 
    // 提交订单到交易服务器
    bool             Send(int magic_number,double lots,string symbol,int type,double price=0,int slippage=50,double stop_loss=0,double take_profit=0,datetime expiration=0,color order_color=CLR_NONE);
           
public:  
    // 点差
    int              Spread(string symbol){return (int)MarketInfo(symbol,MODE_SPREAD);}; // 开仓点差
    int              GroupSpread(void);      // 订单组开仓点差
    // 开仓操作      (参数顺序：magic_number, lots, symbol, type)
    bool             OpenBuy(int magic_number,double lots,string symbol){return Send(magic_number,lots,symbol,OP_BUY);};
    bool             OpenSell(int magic_number,double lots,string symbol){return Send(magic_number,lots,symbol,OP_SELL);};
    bool             OpenGroup(int magic_number,double lots,int type);
    bool             OpenGroupBuy(int magic_number,double lots);
    bool             OpenGroupSell(int magic_number,double lots);
    void             OpenFail(void);
    // 平仓操作
    bool             CloseTicket(int ticket);
    bool             CloseTicketArr(const int & tickets[]);
    bool             CloseGroup(int magic_number,int type);
    bool             CloseGroupBuy(int magic_number){return CloseGroup(magic_number,OP_BUY);};
    bool             CloseGroupSell(int magic_number){return CloseGroup(magic_number,OP_SELL);};
    bool             CloseAll(void); 
    bool             CloseProfit(double profit,int type);
    bool             CloseFail(void);
    // 市场报价
    double           MarketPrice(string symbol,int type);
    
  };
//+------------------------------------------------------------------+
//| 获取订单组开仓点差                                               |
//+------------------------------------------------------------------+
int CTrader::GroupSpread()
{
    string first_symbol = order_param.first_symbol;
    string second_symbol = order_param.second_symbol;
    int symbol_spread = 0;
    if(second_symbol=="")
    {
      symbol_spread = Spread(first_symbol);
    } else {
      symbol_spread = Spread(first_symbol) + Spread(second_symbol);
    }
    return symbol_spread;
}
//+------------------------------------------------------------------+
//| 创建新订单                  处理失败 false ，处理成功返回 true   |
//+------------------------------------------------------------------+
bool CTrader::Send(int magic_number,double lots,string symbol,int type,double price,int slippage,double stop_loss,double take_profit,datetime expiration,color order_color)
{
   // 拼接订单备注
   string comment = m_order_comment;
   // 检测货币对是否有效
   if(MarketInfo(symbol,MODE_BID) == 0)
   {
      Print("要创建的订单货币对symbol:" + symbol + " 出错,不开仓");
      return true;
   }
   // 获取市场价
   price = MarketPrice(symbol,type);
   // 检测手数是否有效
   if(lots<0.01)
   {
      Print("要创建的订单手数 lots: " + DoubleToStr(lots) + " 出错,不开仓");
      return true;
   }
   // 检查魔术号是否有效
   if(magic_number<1)
   {
      Print("要创建的订单magic_number: " + DoubleToStr(magic_number) + " 出错,不开仓");
      return true;
   }
   // 检测订单是否存在
   order.Select(magic_number,lots,symbol,type);
   if(order.Total()>0)
   {
      Print("不开仓,订单已经存在: symbol=" + symbol + ",type:" + IntegerToString(type) + ",lots="+ DoubleToStr(lots,2) + ",magic_number=" + IntegerToString(magic_number));
      return true;
   }
   // 提交订单
   int order_send = OrderSend(symbol,type,lots,price,slippage,stop_loss,take_profit,comment,magic_number,expiration,order_color);
   if(order_send<0)
   {
      Print("货币对" + symbol + " 创建订单失败,交易服务器出错或繁忙中, " + symbol + "," + IntegerToString(type) + "," + DoubleToStr(lots) + "," + IntegerToString(magic_number));
      return false;
   }
   // 检测订单是否存在
   order.Select(magic_number,lots,symbol,type);
   if(order.Total()<1)
   {
      Print("订单不存在，开仓失败，" + symbol + ",type:" + IntegerToString(type) + ",lots="+ DoubleToStr(lots,2) + ",magic_number=" + IntegerToString(magic_number));
      return false;
   }
   // 返回结果
   return true;
}
//+------------------------------------------------------------------+
//| 创建订单组                                                         |
//+------------------------------------------------------------------+
bool CTrader::OpenGroup(int magic_number,double lots,int type)
{
   bool open_group = false;
   // 创建订单组
   if(type==OP_BUY)
   {
      open_group = OpenGroupBuy(magic_number,lots);
   }
   if(type==OP_SELL)
   {
      open_group = OpenGroupSell(magic_number,lots);
   }
   return open_group;
}
//+------------------------------------------------------------------+
//| BUY订单组                                                        |
//+------------------------------------------------------------------+
bool CTrader::OpenGroupBuy(int magic_number,double lots)
{
   string first_symbol = order_param.first_symbol;
   string second_symbol= order_param.second_symbol;
   m_order_comment = order_param.comment_prefix  + "_" + IntegerToString(magic_number) + "_buy";
   // 创建订单组
   OpenBuy(magic_number,lots,first_symbol);
   if(second_symbol!="")
   {
      OpenSell(magic_number,lots,second_symbol);
   }
   // 检查订单组是否创建成功
   order.SelectGroupBuy(magic_number,lots);
   if(order.Total()<2)
   {  // 保存创建订单组失败信息
      m_open_fail.type = OP_BUY;
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
bool CTrader::OpenGroupSell(int magic_number,double lots)
{
   string first_symbol = order_param.first_symbol;
   string second_symbol= order_param.second_symbol;
   m_order_comment = order_param.comment_prefix  + "_" + IntegerToString(magic_number) + "_sell";
   // 创建订单组
   OpenSell(magic_number,lots,first_symbol);
   if(second_symbol!="")
   {
      OpenBuy(magic_number,lots,second_symbol);
   }
   // 检查订单组是否创建成功
   order.SelectGroupSell(magic_number,lots);
   if(order.Total()<2)
   {  // 保存创建订单组失败信息
      m_open_fail.type = OP_SELL;
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
void CTrader::OpenFail()
{
     int magic_number = m_open_fail.magic_number;
     double lots = m_open_fail.lots;
     int type = m_open_fail.type;
     // 提交订单到交易服务器
     if(magic_number>0 && lots>0 && type>-1)
     {
        bool open_order = false;
        switch(type)
        {
            case OP_BUY:
                 open_order = OpenGroupBuy(magic_number,lots);
                 break;
            case OP_SELL: 
                 open_order = OpenGroupSell(magic_number,lots);
                 break;
        }
        // 开仓成功，清除开仓失败记录
        if(open_order==true)
        {
           InitOpenFail();
        }
     }
     return;
};
//+------------------------------------------------------------------+
//| 关闭指定ticket的订单        返回：true 处理成功，false处理失败   |
//+------------------------------------------------------------------+
bool CTrader::CloseTicket(int ticket)
{
   // 检查订单号
   if(ticket<1)
   {  // 无效订单号，处理成功
      Print("无效订单号，ticket：" + IntegerToString(ticket));
      return true; 
   }
   // 检查订单是否存在
   order.Find(ticket);
   if(order.Total()==0)
   {  // 订单号不存在，处理成功
      Print("订单号ticket：" + IntegerToString(ticket) + " 不存在");
      return true;  
   }
   // 查找订单
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderTicket()==ticket)
         {
            // 获取市场价格
            double price = MarketPrice(OrderSymbol(),OrderType());
            // 关闭订单
            bool order_close = OrderClose(ticket,OrderLots(),price,200,CLR_NONE); 
         }     
      }
   }
   // 检查订单是否存在
   order.Find(ticket);
   if(order.Total()==0)
   {  // 订单号不存在，平仓成功
      return true;   
   }
   // 返回结果
   return false;
}
//+------------------------------------------------------------------+
//| 关闭订单号数组                                                   |
//+------------------------------------------------------------------+
bool CTrader::CloseTicketArr(const int & tickets[])
{
    int total = ArraySize(tickets);
    // 关闭订单
    for(int i=0;i<total;i++)
    {  // 平仓失败，复制订单号到带平仓数组
       if(tickets[i]>0 && CloseTicket(tickets[i])==false)
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
bool CTrader::CloseGroup(int magic_number,int type)
{
   string first_symbol = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   if(magic_number<0)
   {
      Print("魔术号: " + IntegerToString(magic_number) + " 出错，不平仓");
      return true;
   }
   order.SelectGroup(magic_number,0,type);
   bool close_group = CloseTicketArr(tem_arr);
   if(close_group==false)
   {
      return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//| 关闭所有持仓订单                                                 |
//+------------------------------------------------------------------+
bool CTrader::CloseAll()
{
   // 遍历订单
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(CloseTicket(OrderTicket())==false)
         {
            Print("ticket:" + IntegerToString(OrderTicket()) + " 平仓出错，全部平仓未完成");
            return false;
         }
      }
   }
   // 检查订单是否已经全部平仓
   if(OrdersTotal()==0)
   {
      TerminalClose(0); // 关闭终端
   }
   return true;
}
//+------------------------------------------------------------------+
//| 关闭达到止盈条件的订单                                           |
//+------------------------------------------------------------------+
bool CTrader::CloseProfit(double profit,int type)
{
   string first_symbol = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   // 获取魔术号列表
   order.SelectMagicNumber(type);
   int total = ArraySize(magic_number_arr);
   for(int i=0; i<total; i++)
   {
       // buy方向
       int magic_number = magic_number_arr[i];
       order.SelectGroupBuy(magic_number);
       if(order.RealProfit()>profit)
       {
          if(CloseGroupBuy(magic_number)==false)
          {
             return false;
          }
       }
       // sell方向
       order.SelectGroupSell(magic_number);
       if(order.RealProfit()>profit)
       {
          if(CloseGroupSell(magic_number)==false)
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
bool CTrader::CloseFail()
{
    int total = ArraySize(close_arr);
    // 关闭订单
    for(int i=0;i<total;i++)
    {
       if(CloseTicket(close_arr[i])==false)
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
double CTrader::MarketPrice(string symbol,int type)
{
    double price = 0;
    if(type==OP_BUY)
    {
       price = MarketInfo(OrderSymbol(),MODE_ASK); // 买入价
    }
    if(type==OP_SELL)
    {
       price = MarketInfo(OrderSymbol(),MODE_BID); // 卖出价
    }
    return price;             
}