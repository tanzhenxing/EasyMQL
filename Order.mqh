//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <EasyMQL\Config.mqh>

class COrder
  {
protected:
   ORDERS_COUNT         m_orders_count;        // 保存订单统计信息
   ORDERS_LATEST        m_orders_latest;       // 最后一组订单信息
   
private:  
   void                 Count(const int & tickets[]);    // 订单信息汇总

public:  
   // 检查订单号是否存在
   void                 Find(int ticket){int arr[1];arr[0] = ticket;Count(arr);};                               // 指定订单号
   void                 All(){Select(-1,0,"",-1);};                                                             // 全部订单 
   // 自定义条件查询    (参数顺序：magic_number, lots, symbol, type)
   void                 Select(int magic_number=-1, double lots=0, string symbol="", int type=-1);              // 自定义条件      
   // 持仓方向查询 
   void                 SelectBuy(double lots=0);            // buy方向的订单
   void                 SelectSell(double lots=0);           // sell方向的订单
   // 指定订单组
   void                 SelectGroup(int magic_number,double lots=0,int type=-1);                                                                     
   void                 SelectGroupBuy(int magic_number,double lots=0);
   void                 SelectGroupSell(int magic_number,double lots=0);   
   // 按照时间查询     
   void                 SelectTime(datetime begin_time=BEGIN_TIME, datetime end_time=END_TIME);                                // 自定义起始时间
   void                 SelectDay(datetime time){SelectTime(day_time.DayBegin(time), day_time.DayEnd(time));};                 // 按日查询
   void                 SelectMonth(datetime time){SelectTime(day_time.MonthBegin(time), day_time.MonthEnd(time));};           // 按月查询
   void                 SelectYear(datetime time){SelectTime(day_time.YearBegin(time), day_time.YearEnd(time));};              // 按年查询 
   void                 SelectWeek(datetime time){SelectTime(day_time.WeekBegin(time), day_time.WeekEnd(time));};              // 按周查询
   void                 Select7days(datetime time){SelectTime(day_time.Last7DaysBegin(time), day_time.Last7DaysEnd(time));};   // 最近7天
   // 订单查询结果
   int                  Total(void){return (int)m_orders_count.total;};       // 订单总数量
   double               Profit(void){return m_orders_count.profit;};          // 订单盈利合计
   double               RealProfit(void){return m_orders_count.real_profit;}; // 订单纯利合计
   double               Lots(void){return m_orders_count.lots;};              // 订单手数合计
   double               Commission(void){return m_orders_count.commission;};  // 订单手续费合计
   double               Swap(void){return m_orders_count.swap;};              // 订单库存费合计
   string               Result(void){return m_orders_count.orders_list;};     // 订单查询结果（json格式）   
   // 订单魔术号信息
   void                 SelectMagicNumber(int type);                              // 魔术号列表
   // 最新开仓订单组信息
   void                 FindLastGroup(int type,double lots);                            // 获取最新开仓订单组
   int                  LastMagicNumber(void){return m_orders_latest.magic_number;};          // 最新开仓订单组魔术号
   datetime             LastOpenTime(void){return m_orders_latest.open_time;};                // 最新开仓订单组的开仓时间
   // 订单组总数量
   int                  GroupCount(int type,double lots=0);  // 指定方向的订单组总数量
   int                  GroupCountBuy(double lots=0);        // buy方向 订单组总数量
   int                  GroupCountSell(double lots=0);       // sell方向 订单组总数量   
   // 保存订单到文件
   bool                 Save(string path,string content){return file.Write(path,content);};   // 保存订单信息
   
  };

//+------------------------------------------------------------------+
//| 自定义条件的订单                                                 |
//+------------------------------------------------------------------+
void COrder::Select(int magic_number, double lots, string symbol, int type)
{
   int arr[];
   int size = 0;
   int total = OrdersTotal(); // 订单总数
   // 获取指定条件的订单数量
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         size = ArraySize(arr);
         // 默认条件,统计全部订单
         if(symbol=="" && lots==0 && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;         
         }
      // 满足4项条件
         // 指定 symbol、lots、type、magic_number 的订单数量
         if(symbol==OrderSymbol() && lots==OrderLots() && type==OrderType() && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();    
            continue;
         }
      // 满足3项条件
         // 指定 symbol、lots、type 的订单手数
         if(symbol==OrderSymbol() && lots==OrderLots() && type==OrderType() && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 symbol、lots、magic_number 的订单手数
         if(symbol==OrderSymbol() && lots==OrderLots() && type==-1 && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 symbol、type、magic_number 的订单手数
         if(symbol==OrderSymbol() && lots==0 && type==OrderType() && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 lots、type、magic_number 的订单手数
         if(symbol=="" && lots==OrderLots() && type==OrderType() && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
      // 满足2项条件
         // 指定 symbol、lots 的订单手数
         if(symbol==OrderSymbol() && lots==OrderLots() && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            Print(OrderTicket());
            continue;
         }
         // 指定 symbol、type 的订单手数
         if(symbol==OrderSymbol() && lots==0 && type==OrderType() && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 symbol、magic_number 的订单手数
         if(symbol==OrderSymbol() && lots==0 && type==-1 && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 lots、type 的订单手数
         if(symbol=="" && lots==OrderLots() && type==OrderType() && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 lots、magic_number 的订单手数
         if(symbol=="" && lots==OrderLots() && type==-1 && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 type、magic_number 的订单手数
         if(symbol=="" && lots==0 && type==OrderType() && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
      // 满足一项条件
         // 指定 symbol 的订单手数
         if(symbol==OrderSymbol() && lots==0 && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 lots 的订单手数
         if(symbol=="" && lots==OrderLots() && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 type 的订单手数
         if(symbol=="" && lots==0 && type==OrderType() && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
         // 指定 magic_number 的订单手数
         if(symbol=="" && lots==0 && type==-1 && magic_number==OrderMagicNumber())
         {
            ArrayResize(arr,size+1);
            arr[size] = OrderTicket();
            continue;
         }
      }
   }
   // 复制订单号到数组
   ArrayResize(ticket_arr,size);
   ArrayCopy(ticket_arr,arr);
   Count(arr);
   return;
}
//+------------------------------------------------------------------+
//| 查询buy方向订单组                                                |
//+------------------------------------------------------------------+
void COrder::SelectBuy(double lots)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   // 清空临时数组
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(-1,lots,first_symbol,OP_BUY);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   Select(-1,lots,second_symbol,OP_SELL);
   data.PushArr(ticket_arr);
   // 重新统计数据
   Count(tem_arr);
   return;
}
//+------------------------------------------------------------------+
//| 查询buy方向订单组                                                |
//+------------------------------------------------------------------+
void COrder::SelectSell(double lots)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   // 清空临时数组
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(-1,lots,first_symbol,OP_SELL);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   Select(-1,lots,second_symbol,OP_BUY);
   data.PushArr(ticket_arr);
   // 重新统计数据
   Count(tem_arr);
   return;
}
//+------------------------------------------------------------------+
//| 查询指定方向的订单组                                             |
//+------------------------------------------------------------------+
void COrder::SelectGroup(int magic_number,double lots,int type)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   int first_type = type;
   int second_type;
   if(type==OP_BUY)
   {
      second_type = OP_SELL;
   } else {
      second_type = OP_BUY;
   }
   // 清空临时数组
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(magic_number,lots,first_symbol,first_type);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   if(second_symbol!="")
   {
      Select(magic_number,lots,second_symbol,second_type);
      data.PushArr(ticket_arr);   
   }
   // 重新统计数据
   Count(tem_arr);
   return;
}
//+------------------------------------------------------------------+
//| 查询buy订单组                                                    |
//+------------------------------------------------------------------+
void COrder::SelectGroupBuy(int magic_number,double lots=0)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   // 清空临时数组
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(magic_number,lots,first_symbol,OP_BUY);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   if(second_symbol!="")
   {
      Select(magic_number,lots,second_symbol,OP_SELL);
      data.PushArr(ticket_arr);   
   }
   // 重新统计数据
   Count(tem_arr);
   return;   
}
//+------------------------------------------------------------------+
//| 查询sell订单组                                                   |
//+------------------------------------------------------------------+
void COrder::SelectGroupSell(int magic_number,double lots=0)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(magic_number,lots,first_symbol,OP_SELL);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   if(second_symbol!="")
   {
      Select(magic_number,lots,second_symbol,OP_BUY);
      data.PushArr(ticket_arr);   
   }
   // 重新统计数据
   Count(tem_arr);
   return;   
}
//+------------------------------------------------------------------+
//| buy方向订单组数量                                                |
//+------------------------------------------------------------------+
int COrder::GroupCountBuy(double lots)
{
     int count = 0;
     SelectMagicNumber(OP_BUY);
     for(int i=0;i<ArraySize(magic_number_arr);i++)
     {
         SelectGroupBuy(magic_number_arr[i],lots);
         if(Total()>0)
         {
            count = count + 1;
         }
     }
     return count;
}
//+------------------------------------------------------------------+
//| sell方向订单组数量                                               |
//+------------------------------------------------------------------+
int COrder::GroupCountSell(double lots)
{
     int count = 0;
     SelectMagicNumber(OP_SELL);
     for(int i=0;i<ArraySize(magic_number_arr);i++)
     {
         SelectGroupSell(magic_number_arr[i],lots);
         if(Total()>0)
         {
            count = count + 1;
         }
     }
     return count;
}
//+------------------------------------------------------------------+
//| 订单组数量                                                       |
//+------------------------------------------------------------------+
int COrder::GroupCount(int type,double lots=0)
{
     int count = 0;
     SelectMagicNumber(type);
     for(int i=0;i<ArraySize(magic_number_arr);i++)
     {
         SelectGroup(magic_number_arr[i],lots,type);
         if(Total()>0)
         {
            count = count + 1;
         }
     }
     return count;
}
//+------------------------------------------------------------------+
//| 指定起始时间的订单信息                                           |
//+------------------------------------------------------------------+
void COrder::SelectTime(datetime begin_time, datetime end_time)
{
   int arr[];
   int size = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
   {
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
     {
        datetime order_time = OrderOpenTime();
        if(begin_time<order_time && order_time<end_time)
        {
           size = ArraySize(arr);
           ArrayResize(arr,size+1);
           arr[size] = OrderTicket();
        }
     }
   }
   Count(arr);
   return;
}
//+------------------------------------------------------------------+
//| 最近一组订单的魔术号、开仓时间                                   |
//+------------------------------------------------------------------+
void COrder::FindLastGroup(int type,double lots)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   int first_type = type;
   int second_type;
   if(first_type==OP_BUY)
   {
      second_type = OP_SELL;
   } else {
      second_type = OP_BUY;
   }
   
   // 获取最近开仓的魔术号
   datetime open_time = 0;
   int magic_number = -1;
   int total = OrdersTotal();
   
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderMagicNumber()>0 && OrderOpenTime()>open_time)
         {
            if(first_type==OrderType() && lots==OrderLots() && first_symbol==OrderSymbol())
            {
               open_time = OrderOpenTime();
               magic_number = OrderMagicNumber();
               continue;
            }
            if(second_type==OrderType() && lots==OrderLots() && second_symbol==OrderSymbol())
            {
               open_time = OrderOpenTime();
               magic_number = OrderMagicNumber();
               continue;
            }
         }
      }
   }
   m_orders_latest.magic_number = magic_number;
   m_orders_latest.open_time    = open_time;
}
//+------------------------------------------------------------------+
//| 获取所有的魔术号                                                 |
//+------------------------------------------------------------------+
void COrder::SelectMagicNumber(int type)
{
   int total = OrdersTotal(); // 订单总数
   // 遍历订单获取魔术号.
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         int magic_number = OrderMagicNumber();
         if(type==OrderType() && magic_number>0)
         {
            data.Push(magic_number);
         }
      }
   }
   // 复制魔术号到数组
   int size = ArraySize(tem_arr);
   ArrayResize(magic_number_arr,size);
   ArrayCopy(magic_number_arr,tem_arr);
   return;
}
//+------------------------------------------------------------------+
//| 统计数组的订单信息                                               |
//+------------------------------------------------------------------+
void COrder::Count(const int &tickets[])
{
   int    total       = ArraySize(tickets); // 订单号数量
   double profit      = 0;     // 盈利合计
   double real_profit = 0;     // 纯利合计
   double lots        = 0;     // 手数合计
   double commission  = 0;     // 手续费合计
   double swap        = 0;     // 库存费合计
   string orders_list = "";    // 订单列表字符串
   int    count       = 0;     // 统计数量
   // 筛选订单
   int total_orders = OrdersTotal(); // 订单总数
   for(int i=0; i<total_orders; i++)
   {
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
     {
       for(int j=0; j<total; j++)
       {
         if(OrderTicket()==tickets[j])
         {
            count       = count + 1;
            profit      = profit + OrderProfit();
            real_profit = real_profit + OrderCommission() + OrderProfit() + OrderSwap();
            lots        = lots + OrderLots();
            commission  = commission + OrderCommission();
            swap        = swap + OrderSwap();
            // 拼接订单信息
            string orders_info = "{"
            + "\"ticket\":\"" + IntegerToString(OrderTicket()) + "\","
            + "\"symbol\":\"" + OrderSymbol() + "\","
            + "\"type\":\"" + IntegerToString(OrderType()) + "\","
            + "\"lots\":\"" + DoubleToStr(OrderLots(),2) + "\","
            + "\"open_price\":\"" + DoubleToStr(OrderOpenPrice(),5) + "\","
            + "\"open_time\":\"" + day_time.FormatDatetime(OrderOpenTime()) + "\","
            + "\"close_price\":\"" + DoubleToStr(OrderClosePrice(),5) + "\","
            + "\"close_time\":\"" + day_time.FormatDatetime(OrderCloseTime()) + "\","
            + "\"take_profit\":\"" + DoubleToStr(OrderTakeProfit(),5) + "\","
            + "\"stop_loss\":\"" + DoubleToStr(OrderStopLoss(),5) + "\","
            + "\"profit\":\"" + DoubleToStr(OrderProfit(),2) + "\","
            + "\"swap\":\"" + DoubleToStr(OrderSwap(),2) + "\","
            + "\"commission\":\"" + DoubleToStr(OrderCommission(),2) + "\","
            + "\"magic_number\":\"" + IntegerToString(OrderMagicNumber()) + "\","
            + "\"comment\":\"" + OrderComment() + "\""
            + "}";         
            if(orders_list=="")
            {
                 orders_list = orders_info;
            } else {
                 orders_list = orders_list + "," + orders_info;
            }
            continue; 
         }       
       }           
     }
   }
   // 保存汇总数据
   m_orders_count.total       = count;
   m_orders_count.profit      = profit;
   m_orders_count.real_profit = real_profit;
   m_orders_count.lots        = lots;
   m_orders_count.commission  = commission;
   m_orders_count.swap        = swap;
   // 返回结果
   m_orders_count.orders_list = "{"
      + "\"code\":\"" + IntegerToString(0) + "\","
      + "\"time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\","
      + "\"account_number\":\"" + IntegerToString(AccountNumber()) + "\","
      + "\"server\":\"" + AccountServer() + "\","
      + "\"total\":\"" + IntegerToString(count) + "\","
      + "\"lots\":\"" + DoubleToStr(lots,2) + "\","
      + "\"profit\":\"" + DoubleToStr(profit,2) + "\","
      + "\"real_profit\":\"" + DoubleToStr(real_profit,2) + "\","
      + "\"commission\":\"" + DoubleToStr(commission,2) + "\","
      + "\"swap\":\"" + DoubleToStr(swap,2) + "\","
      + "\"data\":[" +orders_list + "]}";
  return;   
}