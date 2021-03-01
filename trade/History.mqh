//+------------------------------------------------------------------+
//|                                                      History.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>
#include "..\Config.mqh"


// 本年天数 DayOfYear()
double cache_days = 0; 
// 历史订单总数            
int    history_orders_count = 0; 

class CHistory : public CObject
  {
private:
   // 订单信息汇总
   void                 Count(const long & tickets[]);

protected:
   ORDERS_COUNT         m_orders_count;        // 保存订单统计信息
   void                 SelectGroup(int type,int magic_number,double lots=0); 
   
public:
   // 自定义条件查询
   void                 Find(int ticket){long arr[1];arr[0]=ticket;Count(arr);};                                 // 指定订单号
   void                 All();                                                                                  // 全部订单  
   void                 Select(int magic_number=-1, string symbol="", int type=-1, double lots=0);                // 自定义条件       
   void                 SelectMagicNumber(int magic_number, int type=-1, double lots=0){Select(magic_number,"",type,lots);};                                       // 指定魔术号、手数                                                                   
   void                 SelectGroupBuy(int magic_number,double lots=0){SelectGroup(ORDER_BUY,magic_number,lots);};   // buy订单组 
   void                 SelectGroupSell(int magic_number,double lots=0){SelectGroup(ORDER_SELL,magic_number,lots);}; // sell订单组 
   // 按照时间查询     
   void                 SelectByTime(datetime begin_time=BEGIN_TIME, datetime end_time=END_TIME,ENUM_ORDER_TIME order_time=CLOSE_TIME); // 自定义起始时间   
   void                 SelectByDay(datetime time,ENUM_ORDER_TIME order_time=CLOSE_TIME){SelectByTime(day_time.DayBegin(time), day_time.DayEnd(time),order_time);};  // 按日查询                       
   void                 SelectByMonth(datetime time,ENUM_ORDER_TIME order_time=CLOSE_TIME){SelectByTime(day_time.MonthBegin(time), day_time.MonthEnd(time),order_time);}; // 按月查询                     
   void                 SelectByYear(datetime time,ENUM_ORDER_TIME order_time=CLOSE_TIME){SelectByTime(day_time.YearBegin(time), day_time.YearEnd(time),order_time);}; // 按年查询
   void                 SelectByWeek(datetime time,ENUM_ORDER_TIME order_time=CLOSE_TIME){SelectByTime(day_time.WeekBegin(time), day_time.WeekEnd(time),order_time);};  // 按周查询
                        // 订单查询结果
   int                  Total(void){return (int)m_orders_count.total;};       // 订单总数量
   double               Profit(void){return m_orders_count.profit;};          // 订单盈利合计
   double               RealProfit(void){return m_orders_count.real_profit;}; // 订单纯利合计
   double               Lots(void){return m_orders_count.lots;};              // 订单手数合计
   double               Commission(void){return m_orders_count.commission;};  // 订单手续费合计
   double               Swap(void){return m_orders_count.swap;};              // 订单库存费合计
   string               Result(void){return m_orders_count.orders_list;};     // 订单查询结果（json格式）

   // 保存订单到文件
   bool                 Save(string path,string content){return file.Write(path,content);};                      // 保存订单信息
   void                 SaveAll(void);                                                                           // 保存所有类比的历史订单
   
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 自定义条件的订单                                                 |
//+------------------------------------------------------------------+
void CHistory::Select(int magic_number, string symbol, int type, double lots)
{
   long arr[];
   int size = 0;
   // 筛选订单 
   int total;
   #ifdef __MQL5__
     total = HistoryOrdersTotal();
   #else
     total = OrdersTotal(); // 订单总数
   #endif    
   // 获取指定条件的订单数量
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
//| 全部订单信息                                                     |
//+------------------------------------------------------------------+
void CHistory::All()
{
   double profit      = 0; // 盈利合计
   double real_profit = 0; // 纯利合计
   double lots        = 0; // 手数合计
   double commission  = 0; // 手续费合计
   double swap        = 0; // 库存费合计
   string orders_list = ""; // 订单列表字符串
   int    count       = 0; // 统计数量
   
   int total;
   #ifdef __MQL5__
     total = HistoryOrdersTotal();
   #else
     total = OrdersTotal(); // 订单总数
   #endif

   // 获取指定条件的订单数量
   for(int i=0; i<total; i++)
   {
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)HistoryOrderGetTicket(i);
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
//+------------------------------------------------------------------+
//| 指定起始时间的订单信息                                           |
//+------------------------------------------------------------------+
void CHistory::SelectByTime(datetime begin_time, datetime end_time,ENUM_ORDER_TIME order_time)
{
   long arr[];
   int size = 0;

   int total;
   #ifdef __MQL5__
     total = HistoryOrdersTotal();
   #else
     total = OrdersTotal(); // 订单总数
   #endif   
   datetime time = 0;
   for(int i=0; i<total; i++)
   {
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)HistoryOrderGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif 
     if(selete==true)
     {
       datetime order_open_time;
       datetime order_close_time;
       long order_ticket;
       
      #ifdef __MQL5__
         order_open_time =  (datetime)OrderGetInteger(ORDER_TIME_SETUP);
         order_close_time =  (datetime)OrderGetInteger(ORDER_TIME_DONE);
         order_ticket = ticket;
      #else
         order_open_time  = OrderOpenTime();
         order_close_time = OrderCloseTime();
         order_ticket = OrderTicket();
      #endif 
        switch(order_time)
        {
           case OPEN_TIME:
                time = order_open_time;
                break;
           case CLOSE_TIME:
                time = order_close_time;
                break;            
        }
        if(begin_time<time && order_time<time)
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
//| 保存所有类别的订单信息                                           |
//+------------------------------------------------------------------+
void CHistory::SaveAll()
{
  // 交易服务器日期
  MqlDateTime current_time;
  TimeToStruct(TimeCurrent(),current_time);  
  double days = current_time.year + current_time.day_of_year * 0.001;
  // 本地日期
  MqlDateTime local_time;
  TimeToStruct(TimeLocal(),local_time); 
  double local_days = local_time.year + local_time.day_of_year * 0.001;
  // 检查订单总数是否有变化、日期是否有变化
    int total;
   #ifdef __MQL5__
     total = HistoryOrdersTotal();
   #else
     total = OrdersTotal(); // 订单总数
   #endif  
  if(total>history_orders_count || days>cache_days || local_days>cache_days)
  {
     // 出入金
     Select(-1, "", 6,0);
     Save(CASH_FILE,Result());
     // 其他订单
     Select(-1, "", 7,0);
     Save(OTHER_FILE,Result());   
     // 保存全部历史订单
     All();
     Save(HISTORY_FILE,Result());
     // 今日历史订单
     SelectByDay(day_time.TodayBegin());
     Save(TODAY_FILE,Result());
     // 昨日历史订单
     SelectByDay(day_time.YesterdayBegin());
     Save(LAST_DAY_FILE,Result()); 
     // 本月历史订单
     SelectByMonth(day_time.CurrentMonthBegin());
     Save(MONTH_FILE,Result());    
     // 上一月历史订单
     SelectByMonth(day_time.LastMonthBegin(TRADER_TIME));
     Save(LAST_MONTH_FILE,Result()); 
     // 本年历史订单
     SelectByYear(day_time.CurrentYearBegin());
     Save(YEAR_FILE,Result()); 
     // 上一年历史订单
     SelectByYear(day_time.LastYearBegin(TRADER_TIME));
     Save(LAST_YEAR_FILE,Result());
     // 本周
     
     // 上一周
     
     // 最近7天
     
     history_orders_count = total;
     cache_days = days;
  }
  return;
}
//+------------------------------------------------------------------+
//| 统计数组的订单信息                                               |
//+------------------------------------------------------------------+
void CHistory::Count(const long &tickets[])
{
   int total = ArraySize(tickets);
   double profit      = 0; // 盈利合计
   double real_profit = 0; // 纯利合计
   double lots        = 0; // 手数合计
   double commission  = 0; // 手续费合计
   double swap        = 0; // 库存费合计
   string orders_list = ""; // 订单列表字符串
   int    count       = 0; // 统计数量
   
   // 筛选订单 
   int orders_total;
   #ifdef __MQL5__
     orders_total = HistoryOrdersTotal();
   #else
     orders_total = OrdersTotal(); // 订单总数
   #endif 
   for(int i=0; i<orders_total; i++)
   {
      bool selete;
      #ifdef __MQL5__
         long ticket = (long)HistoryOrderGetTicket(i);
         selete = (bool)ticket;
      #else
         selete = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      #endif 
     if(selete==true)
     {
       for(int j=0; j<total; j++)
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