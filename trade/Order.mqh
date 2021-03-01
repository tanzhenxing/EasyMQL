//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include "..\Config.mqh"

class COrder
  {
protected:
   ORDERS_COUNT         m_orders_count;        // 保存订单统计信息
   ORDERS_LATEST        m_orders_latest;       // 最后一组订单信息
   
private:  
   void                 Count(const long & tickets[]);    // 订单信息汇总

public:  
   // 检查订单号是否存在
   void                 Find(long ticket){long arr[1];arr[0] = ticket;Count(arr);};                               // 指定订单号
   void                 All(){Select(-1,0,"",-1);};                                                             // 全部订单 
   // 自定义条件查询    (参数顺序：magic_number, lots, symbol, type)
   void                 Select(long magic_number=-1, double lots=0, string symbol="", int type=-1);              // 自定义条件      
   // 持仓方向查询 
   void                 SelectBuy(double lots=0);            // buy方向的订单
   void                 SelectSell(double lots=0);           // sell方向的订单
   // 指定订单组
   void                 SelectGroup(long magic_number,double lots=0,int type=-1);                                                                     
   void                 SelectGroupBuy(long magic_number,double lots=0);
   void                 SelectGroupSell(long magic_number,double lots=0);   
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
   long                 LastMagicNumber(void){return m_orders_latest.magic_number;};          // 最新开仓订单组魔术号
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
void COrder::Select(long magic_number, double lots, string symbol, int type)
{
   long arr[];
   int size = 0;
   // 订单总数
   int total;
   #ifdef __MQL5__
   total = PositionsTotal();
   #else
   total = OrdersTotal(); // 订单总数
   #endif 

   for(int i=0;i<total;i++)
   {
      // 选择订单是否成功
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
         string  order_symbol;
         double  order_lots;
         ulong   order_type;
         long    order_magic_number;
         
         #ifdef __MQL5__
           order_ticket = ticket;
           order_symbol =  PositionGetString(POSITION_SYMBOL);
           order_lots = PositionGetDouble(POSITION_VOLUME);
           order_type = PositionGetInteger(POSITION_TYPE);
           order_magic_number = PositionGetInteger(POSITION_MAGIC);
         #else
           order_ticket = OrderTicket();
           order_symbol = OrderSymbol();
           order_lots = OrderLots();
           order_type = OrderType();
           order_magic_number =  OrderMagicNumber();
         #endif 
         
         size = ArraySize(arr);
     // 默认条件,统计全部订单
         if(symbol=="" && lots==0 && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;         
         }
      // 满足4项条件
         // 指定 symbol、lots、type、magic_number 的订单数量
         if(symbol==order_symbol && lots==order_lots && type==order_type && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;    
            continue;
         }
      // 满足3项条件
         // 指定 symbol、lots、type 的订单手数
         if(symbol==order_symbol && lots==order_lots && type==order_type && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 symbol、lots、magic_number 的订单手数
         if(symbol==order_symbol && lots==order_lots && type==-1 && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 symbol、type、magic_number 的订单手数
         if(symbol==order_symbol && lots==0 && type==order_type && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 lots、type、magic_number 的订单手数
         if(symbol=="" && lots==order_lots && type==order_type && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
      // 满足2项条件
         // 指定 symbol、lots 的订单手数
         if(symbol==order_symbol && lots==order_lots && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 symbol、type 的订单手数
         if(symbol==order_symbol && lots==0 && type==order_type && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 symbol、magic_number 的订单手数
         if(symbol==order_symbol && lots==0 && type==-1 && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 lots、type 的订单手数
         if(symbol=="" && lots==order_lots && type==order_type && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 lots、magic_number 的订单手数
         if(symbol=="" && lots==order_lots && type==-1 && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 type、magic_number 的订单手数
         if(symbol=="" && lots==0 && type==order_type && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
      // 满足一项条件
         // 指定 symbol 的订单手数
         if(symbol==order_symbol && lots==0 && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 lots 的订单手数
         if(symbol=="" && lots==order_lots && type==-1 && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 type 的订单手数
         if(symbol=="" && lots==0 && type==order_type && magic_number==-1)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
            continue;
         }
         // 指定 magic_number 的订单手数
         if(symbol=="" && lots==0 && type==-1 && magic_number==order_magic_number)
         {
            ArrayResize(arr,size+1);
            arr[size] = order_ticket;
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
   Select(-1,lots,first_symbol,ORDER_BUY);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   Select(-1,lots,second_symbol,ORDER_SELL);
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
   Select(-1,lots,first_symbol,ORDER_SELL);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   Select(-1,lots,second_symbol,ORDER_BUY);
   data.PushArr(ticket_arr);
   // 重新统计数据
   Count(tem_arr);
   return;
}
//+------------------------------------------------------------------+
//| 查询指定方向的订单组                                             |
//+------------------------------------------------------------------+
void COrder::SelectGroup(long magic_number,double lots,int type)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   int first_type = type;
   int second_type;
   if(type==ORDER_BUY)
   {
      second_type = ORDER_SELL;
   } else {
      second_type = ORDER_BUY;
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
void COrder::SelectGroupBuy(long magic_number,double lots=0)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   // 清空临时数组
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(magic_number,lots,first_symbol,ORDER_BUY);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   if(second_symbol!="")
   {
      Select(magic_number,lots,second_symbol,ORDER_SELL);
      data.PushArr(ticket_arr);   
   }
   // 重新统计数据
   Count(tem_arr);
   return;   
}
//+------------------------------------------------------------------+
//| 查询sell订单组                                                   |
//+------------------------------------------------------------------+
void COrder::SelectGroupSell(long magic_number,double lots=0)
{
   string first_symbol  = order_param.first_symbol;
   string second_symbol = order_param.second_symbol;
   ArrayFree(tem_arr);
   // 主货币对订单
   Select(magic_number,lots,first_symbol,ORDER_SELL);
   data.PushArr(ticket_arr);
   // 辅货币对订单
   if(second_symbol!="")
   {
      Select(magic_number,lots,second_symbol,ORDER_BUY);
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
     SelectMagicNumber(ORDER_BUY);
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
     SelectMagicNumber(ORDER_SELL);
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
   long arr[];
   int size = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
   {
      // 选择订单是否成功
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)PositionGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif 
      
     if(selete==true)
     {
         long     order_ticket;
         long     order_time;        
         #ifdef __MQL5__
           order_ticket = ticket;
           order_time = PositionGetInteger(POSITION_TIME);
         #else
           order_ticket = OrderTicket();
           order_time   = OrderOpenTime();
         #endif

        if(begin_time<order_time && order_time<end_time)
        {
           size = ArraySize(arr);
           ArrayResize(arr,size+1);
           arr[size] = order_ticket;
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
   if(first_type==ORDER_BUY)
   {
      second_type = ORDER_SELL;
   } else {
      second_type = ORDER_BUY;
   }
   
   // 获取最近开仓的魔术号
   datetime open_time = 0;
   long     magic_number = -1;
   // 订单总数
   long total;
   #ifdef __MQL5__
   total = PositionsTotal();
   #else
   total = OrdersTotal(); // 订单总数
   #endif 
   
   for(int i=0; i<total; i++)
   {
      // 选择订单是否成功
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)PositionGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif 
      if(selete==true)
      {
         long     order_ticket;
         datetime     order_time;  
         string   order_symbol;
         double   order_lots;
         long     order_type;
         long     order_magic_number;      
         #ifdef __MQL5__
           order_ticket = ticket;
           order_time = (datetime)PositionGetInteger(POSITION_TIME);
           order_symbol = PositionGetString(POSITION_SYMBOL);
           order_lots = PositionGetDouble(POSITION_VOLUME);
           order_type = PositionGetInteger(POSITION_TYPE);
           order_magic_number = PositionGetInteger(POSITION_MAGIC);           
         #else
           order_ticket = OrderTicket();
           order_time   = OrderOpenTime();
           order_symbol = OrderSymbol();
           order_lots = OrderLots();
           order_type = OrderType();
           order_magic_number = OrderMagicNumber();
         #endif
         if(order_magic_number>0 && order_time>open_time)
         {
            if(first_type==order_type && lots==order_lots && first_symbol==order_symbol)
            {
               open_time    = order_time;
               magic_number = order_magic_number;
               continue;
            }
            if(second_type==order_type && lots==order_lots && second_symbol==order_symbol)
            {
               open_time    = order_time;
               magic_number = order_magic_number;
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
   // 订单总数
   long total;
   #ifdef __MQL5__
   total = PositionsTotal();
   #else
   total = OrdersTotal(); // 订单总数
   #endif 
   // 遍历订单获取魔术号.
   for(int i=0; i<total; i++)
   {
      // 选择订单是否成功
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)PositionGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif 
      if(selete==true)
      {
         long     order_type;
         long     order_magic_number;      
         #ifdef __MQL5__
           order_type = PositionGetInteger(POSITION_TYPE);
           order_magic_number = (long)PositionGetInteger(POSITION_MAGIC);           
         #else
           order_type = OrderType();
           order_magic_number = OrderMagicNumber();
         #endif

         if(type==order_type && order_magic_number>0)
         {
            data.Push(order_magic_number);
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
void COrder::Count(const long &tickets[])
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
   int total_orders;  // 订单总数
   #ifdef __MQL5__
      total_orders = PositionsTotal(); 
   #else 
      total_orders = OrdersTotal(); 
   #endif
   
   for(int i=0; i<total_orders; i++)
   {
      // 选择订单是否成功
      bool selete;
      #ifdef __MQL5__
         ulong ticket = PositionGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif    
     if(selete==true)
     {
         ulong    order_ticket;
         string   order_symbol;
         long     order_type;
         double   order_lots;
         double   order_open_price;
         long     order_open_time;
         double   order_close_price;
         long     order_close_time;
         double   order_take_profit;
         double   order_stop_loss;
         double   order_profit;
         double   order_commission;
         double   order_swap;
         long     order_magic_number;   
         string   order_comment;
         
         #ifdef __MQL5__
           order_ticket = ticket;
           order_symbol = PositionGetString(POSITION_SYMBOL);
           order_type =  PositionGetInteger(POSITION_TYPE);
           order_lots = PositionGetDouble(POSITION_VOLUME);
           order_open_price = PositionGetDouble(POSITION_PRICE_OPEN);
           order_open_time =  PositionGetInteger(POSITION_TIME);
           order_close_price = 0;
           order_close_time = 0;
           order_take_profit = PositionGetDouble(POSITION_TP);
           order_stop_loss = PositionGetDouble(POSITION_SL);
           order_profit = PositionGetDouble(POSITION_PROFIT);
           order_commission = 0;
           order_swap = PositionGetDouble(POSITION_SWAP);  
           order_magic_number =  PositionGetInteger(POSITION_MAGIC);
           order_comment = PositionGetString(POSITION_COMMENT);
         #else
           order_ticket = OrderTicket();
           order_symbol = OrderSymbol();
           order_type = OrderType();
           order_lots = OrderLots();
           order_open_price = OrderOpenPrice();
           order_open_time = OrderOpenTime();
           order_close_price = OrderClosePrice();
           order_close_time = OrderCloseTime();
           order_take_profit = OrderTakeProfit();
           order_stop_loss = OrderStopLoss();
           order_profit = OrderProfit();
           order_commission = OrderCommission();
           order_swap = OrderSwap();          
           order_magic_number = OrderMagicNumber();
           order_comment = OrderComment();
         #endif
       for(int j=0; j<total; j++)
       {
         if(order_ticket==tickets[j])
         {
            count       = count + 1;
            profit      = profit + order_profit;
            real_profit = real_profit + order_commission + order_profit + order_swap;
            lots        = lots + order_lots;
            commission  = commission + order_commission;
            swap        = swap + order_swap;
            // 拼接订单信息
            string orders_info = "{"
            + "\"ticket\":\"" + IntegerToString(order_ticket) + "\","
            + "\"symbol\":\"" + order_symbol + "\","
            + "\"type\":\"" + IntegerToString(order_type) + "\","
            + "\"lots\":\"" + DoubleToString(order_lots,2) + "\","
            + "\"open_price\":\"" + DoubleToString(order_open_price,5) + "\","
            + "\"open_time\":\"" + day_time.FormatDatetime(order_open_time) + "\","
            + "\"close_price\":\"" + DoubleToString(order_close_price,5) + "\","
            + "\"close_time\":\"" + day_time.FormatDatetime(order_close_time) + "\","
            + "\"take_profit\":\"" + DoubleToString(order_take_profit,5) + "\","
            + "\"stop_loss\":\"" + DoubleToString(order_stop_loss,5) + "\","
            + "\"profit\":\"" + DoubleToString(order_profit,2) + "\","
            + "\"swap\":\"" + DoubleToString(order_swap,2) + "\","
            + "\"commission\":\"" + DoubleToString(order_commission,2) + "\","
            + "\"magic_number\":\"" + IntegerToString(order_magic_number) + "\","
            + "\"comment\":\"" + order_comment + "\""
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
      + "\"account_number\":\"" + IntegerToString(account.Login()) + "\","
      + "\"server\":\"" + account.Server() + "\","
      + "\"total\":\"" + IntegerToString(count) + "\","
      + "\"lots\":\"" + DoubleToString(lots,2) + "\","
      + "\"profit\":\"" + DoubleToString(profit,2) + "\","
      + "\"real_profit\":\"" + DoubleToString(real_profit,2) + "\","
      + "\"commission\":\"" + DoubleToString(commission,2) + "\","
      + "\"swap\":\"" + DoubleToString(swap,2) + "\","
      + "\"data\":[" +orders_list + "]}";
  return;   
}