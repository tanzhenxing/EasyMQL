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
#include <EasyMQL\Config.mqh>

// 本年天数 DayOfYear()
double cache_days = 0; 
// 历史订单总数            
int    history_orders_count = 0; 

class CHistory : public CObject
  {
private:
   // 订单信息汇总
   void                 Count(const int & tickets[]);

protected:
   ORDERS_COUNT         m_orders_count;        // 保存订单统计信息
   void                 SelectGroup(int type,int magic_number,double lots=0); 
   
public:
   // 自定义条件查询
   void                 Find(int ticket){int arr[1];arr[0]=ticket;Count(arr);};                                 // 指定订单号
   void                 All();                                                                                  // 全部订单  
   void                 Select(int magic_number=-1, string symbol="", int type=-1, double lots=0);                // 自定义条件       
   void                 SelectMagicNumber(int magic_number, int type=-1, double lots=0){Select(magic_number,"",type,lots);};                                       // 指定魔术号、手数                                                                   
   void                 SelectGroupBuy(int magic_number,double lots=0){SelectGroup(OP_BUY,magic_number,lots);};   // buy订单组 
   void                 SelectGroupSell(int magic_number,double lots=0){SelectGroup(OP_SELL,magic_number,lots);}; // sell订单组 
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
   int arr[];
   int size = 0;
   int total = OrdersHistoryTotal(); // 订单总数
   // 获取指定条件的订单数量
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
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
   int total = OrdersHistoryTotal(); // 订单总数
   // 获取指定条件的订单数量
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
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
//+------------------------------------------------------------------+
//| 指定起始时间的订单信息                                           |
//+------------------------------------------------------------------+
void CHistory::SelectByTime(datetime begin_time, datetime end_time,ENUM_ORDER_TIME order_time)
{
   int arr[];
   int size = 0;
   int total = OrdersHistoryTotal();
   datetime time = 0;
   for(int i=0; i<total; i++)
   {
     if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
     {
        switch(order_time)
        {
           case OPEN_TIME:
                time = OrderOpenTime();
                break;
           case CLOSE_TIME:
                time = OrderCloseTime();
                break;            
        }
        if(begin_time<time && order_time<time)
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
//| 保存所有类别的订单信息                                           |
//+------------------------------------------------------------------+
void CHistory::SaveAll()
{
  // 交易服务器日期
  double days = Year() + DayOfYear() * 0.001;
  // 本地日期
  double local_days = TimeYear(TimeLocal()) + TimeDayOfYear(TimeLocal()) * 0.001;
  // 检查订单总数是否有变化、日期是否有变化
  if(OrdersHistoryTotal()>history_orders_count || days>cache_days || local_days>cache_days)
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
     
     history_orders_count = OrdersHistoryTotal();
     cache_days = days;
  }
  return;
}
//+------------------------------------------------------------------+
//| 统计数组的订单信息                                               |
//+------------------------------------------------------------------+
void CHistory::Count(const int &tickets[])
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
   for(int i=0; i<OrdersHistoryTotal(); i++)
   {
     if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
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