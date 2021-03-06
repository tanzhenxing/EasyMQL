//+------------------------------------------------------------------+
//|                                                         Time.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include "..\Defines.mqh"

class CDayTime
  {
private:
     
protected:
    // 指定日期的日开始、结束时间
    datetime         dayBeginTime(datetime time);                          // 日开始时间
    datetime         dayEndTime(datetime time){return dayBeginTime(time) + ONE_DAY_TIME - 1;};                // 日结束时间    
    datetime         lastDayBeginTime(datetime time){return dayBeginTime(time) - ONE_DAY_TIME;};              // 下一日开始时间
    datetime         lastDayEndTime(datetime time){return dayBeginTime(time)-1;};                             // 下一日结束时间
    // 指定日期的周开始、结束时间
    datetime         weekBeginTime(datetime time);
    datetime         weekEndTime(datetime time){return weekBeginTime(time) + ONE_DAY_TIME * 7 - 1;};
    datetime         lastWeekBeginTime(datetime time){return weekBeginTime(time) - ONE_DAY_TIME * 7;};
    datetime         lastWeekEndTime(datetime time){return weekBeginTime(time)-1;};    
    datetime         last7DaysBeginTime(datetime time){return dayBeginTime(time) - ONE_DAY_TIME * 7;};
    datetime         last7DaysEndTime(datetime time){return dayBeginTime(time)-1;};
    // 指定月份的日开始、结束时间
    datetime         monthBeginTime(datetime time);       // 月开始时间
    datetime         monthEndTime(datetime time);                                                                                                      // 月结束时间
    datetime         lastMonthBeginTime(datetime time);                                                                                                // 下一月开始时间
    datetime         lastMonthEndTime(datetime time){return monthEndTime(lastMonthBeginTime(time));};                                                  // 下一月结束时间
    // 指定年份的日开始、结束时间
    datetime         yearBeginTime(datetime time);     // 年开始时间
    datetime         yearEndTime(datetime time);       // 年结束时间
    datetime         lastYearBeginTime(datetime time); // 下一年开始时间
    datetime         lastYearEndTime(datetime time);   // 下一年结束时间
                           
public:  
    datetime         current(){return TimeCurrent();};
    datetime         current(MqlDateTime& mql_time){return TimeCurrent(mql_time);};
    datetime         local(){return TimeLocal();};
    datetime         local(MqlDateTime& mql_time){return TimeLocal(mql_time);};
    datetime         tradeServer(){return TimeTradeServer();};
    datetime         tradeServer(MqlDateTime& mql_time){return TimeTradeServer(mql_time);};
    datetime         gmt(){return TimeGMT();};
    datetime         gmt(MqlDateTime& mql_time){return TimeGMT(mql_time);};
    int              daylightSavings(){return TimeDaylightSavings();};
    int              gmtOffset(){return TimeGMTOffset();};
    bool             timeToStruct(datetime date_time,MqlDateTime& mql_time){return TimeToStruct(date_time,mql_time);};
    datetime         structToTime(MqlDateTime& mql_time){return StructToTime(mql_time);};
    datetime         nowTime();
    string           formatDatetime(datetime time);   // 时间格式化 （使用 - 分隔时间）
    
    // 日期的起始和结束时间
    datetime         dayBegin(datetime time){return dayBeginTime(time);};                // 日开始时间
    datetime         dayEnd(datetime time){return dayEndTime(time);};                    // 日开始时间    
    datetime         todayBegin(){return dayBeginTime(nowTime());};                      // 今日开始时间
    datetime         todayEnd(){return dayEndTime(nowTime());};                          // 今日结束时间
    datetime         yesterdayBegin(){return lastDayBeginTime(nowTime());};              // 昨日开始时间 
    datetime         yesterdayEnd(){return lastDayEndTime(nowTime());};                  // 昨日结束时间  
    datetime         lastDayBegin(datetime time){return lastDayBeginTime(time);};        // 上一日开始时间
    datetime         lastDayEnd(datetime time){return lastDayEndTime(time);};            // 上一日开始时间
    // 周的起始和结束时间
    datetime         weekBegin(datetime time){return weekBeginTime(time);};
    datetime         weekEnd(datetime time){return weekEndTime(time);};
    datetime         currentWeekBegin(){return weekBeginTime(nowTime());};
    datetime         currentWeekEnd(){return weekEndTime(nowTime());};
    datetime         lastWeekBegin(datetime time){return lastWeekBeginTime(time);};
    datetime         lastWeekEnd(datetime time){return lastWeekEndTime(time);};
                     // 前7日的开始和结束时间(不包括当日)
    datetime         last7DaysBegin(datetime time){return last7DaysBeginTime(time);};
    datetime         last7DaysEnd(datetime time){return last7DaysEndTime(time);};
    // 月份的起始和结束时间
    datetime         monthBegin(datetime time){return monthBeginTime(time);};                 // 月开始时间
    datetime         monthEnd(datetime time){return monthEndTime(time);};                     // 月结束时间
    datetime         currentMonthBegin(){return monthBeginTime(nowTime());};                  // 本月开始时间
    datetime         currentMonthEnd(){return monthEndTime(nowTime());};                      // 本月结束时间         
    datetime         lastMonthBegin(datetime time){return lastMonthBeginTime(time);};         // 上一月开始时间
    datetime         lastMonthEnd(datetime time){return lastMonthEndTime(time);}; 
    // 年份的起始和结束时间
    datetime         yearBegin(datetime time){return yearBeginTime(time);};     
    datetime         yearEnd(datetime time){return yearEndTime(time);};
    datetime         currentYearBegin(){return yearBeginTime(nowTime());};     
    datetime         currentYearEnd(){return yearEndTime(nowTime());};   
    datetime         lastYearBegin(datetime time){return lastYearBeginTime(time);};            // 上一年开始时间
    datetime         lastYearEnd(datetime time){return lastYearEndTime(time);};                // 上一年开始时间
    
  };
//+------------------------------------------------------------------+
//| 当前时间                                                         |
//+------------------------------------------------------------------+
datetime CDayTime::nowTime()
{
       datetime time = TimeCurrent();
       if(TRADER_TIME>TimeCurrent())
       {
          time = TRADER_TIME;
       }
       return time;
}
//+------------------------------------------------------------------+
//| 日开始时间                                                       |
//+------------------------------------------------------------------+
datetime CDayTime::dayBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);  
   return StringToTime(IntegerToString(mql_time.year)+"."+IntegerToString(mql_time.mon)+"."+IntegerToString(mql_time.day));
}
//+------------------------------------------------------------------+
//| 指定时间当月的开始时间                                           |
//+------------------------------------------------------------------+
datetime CDayTime::monthBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);   
   return StringToTime(IntegerToString(mql_time.year)+"."+IntegerToString(mql_time.mon)+".01");
}
//+------------------------------------------------------------------+
//| 指定时间当月的最后时间                                           |
//+------------------------------------------------------------------+
datetime CDayTime::monthEndTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);  
   int year = mql_time.year;
   int month = mql_time.mon;
   int next_month;
   int next_month_year;
   if(month==12)
   {
      next_month = 1;
      next_month_year  = year + 1;
   } else {
      next_month = month + 1;
      next_month_year  = year;
   }
   string next_month_str;
   if(next_month<10)
   {
     next_month_str = "0"+IntegerToString(next_month);
   } else {
     next_month_str = IntegerToString(next_month);
   }
   datetime next_month_time = StringToTime(IntegerToString(next_month_year)+"."+next_month_str+".01") -1;
   return next_month_time;
}
//+------------------------------------------------------------------+
//| 指定时间上一月的开始时间                                         |
//+------------------------------------------------------------------+
datetime CDayTime::lastMonthBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time); 
   int year = mql_time.year;
   int month = mql_time.mon;
   int last_month;
   int last_month_year;
   if(month==1)
   {
      last_month = 12;
      last_month_year = year -1;
   } else {
      last_month = month -1 ;
      last_month_year = year;   
   }
   string last_month_str;
   if(last_month<10)
   {
     last_month_str = "0"+IntegerToString(last_month);
   } else {
     last_month_str = IntegerToString(last_month);
   }   
   datetime next_month_time = StringToTime(IntegerToString(last_month_year)+"."+last_month_str+".01");
   return next_month_time;
}
//+------------------------------------------------------------------+
//| 指定时间周的开始时间                                             |
//+------------------------------------------------------------------+
datetime CDayTime::weekBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);  
   int day_of_week = mql_time.day_of_week;
   if(day_of_week==0)
   {
      day_of_week = 7;
   }
   return dayBegin(time) - (day_of_week -1) * ONE_DAY_TIME;
}
//+------------------------------------------------------------------+
//| 指定年的开始时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::yearBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time); 
   return StringToTime(IntegerToString(mql_time.year)+".01.01");
}
//+------------------------------------------------------------------+
//| 指定年的结束时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::yearEndTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   return StringToTime(IntegerToString(mql_time.year)+".12.31");
}
//+------------------------------------------------------------------+
//| 下一年的开始时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::lastYearBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   return StringToTime(IntegerToString(mql_time.year-1)+".01.01");
}
//+------------------------------------------------------------------+
//| 下一年的结束时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::lastYearEndTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   return StringToTime(IntegerToString(mql_time.year-1)+".12.31");
}
//+------------------------------------------------------------------+
//| 格式化时间：使用 - 分隔 YYYY-MM-DD h:i:s                         |
//+------------------------------------------------------------------+
string CDayTime::formatDatetime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   string time_str = IntegerToString(mql_time.year)+"-"+IntegerToString(mql_time.mon)+"-"+IntegerToString(mql_time.day)
                     +" "+IntegerToString(mql_time.hour)+":"+IntegerToString(mql_time.min)+":"+IntegerToString(mql_time.sec);
   return time_str;
}