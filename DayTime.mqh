//+------------------------------------------------------------------+
//|                                                         Time.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>
#include <EasyMQL\Defines.mqh>


class CDayTime : public CObject
  {
private:
     datetime        NowTime();

protected:
    // 指定日期的日开始、结束时间
    datetime         DayBeginTime(datetime time){return StrToTime(IntegerToString(TimeYear(time))+"."+IntegerToString(TimeMonth(time))+"."+IntegerToString(TimeDay(time)));}; // 日开始时间
    datetime         DayEndTime(datetime time){return DayBeginTime(time) + ONE_DAY_TIME - 1;};                // 日结束时间    
    datetime         LastDayBeginTime(datetime time){return DayBeginTime(time) - ONE_DAY_TIME;};              // 下一日开始时间
    datetime         LastDayEndTime(datetime time){return DayBeginTime(time)-1;};                             // 下一日结束时间
    // 指定日期的周开始、结束时间
    datetime         WeekBeginTime(datetime time);
    datetime         WeekEndTime(datetime time){return WeekBeginTime(time) + ONE_DAY_TIME * 7 - 1;};
    datetime         LastWeekBeginTime(datetime time){return WeekBeginTime(time) - ONE_DAY_TIME * 7;};
    datetime         LastWeekEndTime(datetime time){return WeekBeginTime(time)-1;};    
    datetime         Last7DaysBeginTime(datetime time){return DayBeginTime(time) - ONE_DAY_TIME * 7;};
    datetime         Last7DaysEndTime(datetime time){return DayBeginTime(time)-1;};
    // 指定月份的日开始、结束时间
    datetime         MonthBeginTime(datetime time){return StrToTime(IntegerToString(TimeYear(time))+"."+IntegerToString(TimeMonth(time))+".01");};     // 月开始时间
    datetime         MonthEndTime(datetime time);                                                                                                      // 月结束时间
    datetime         LastMonthBeginTime(datetime time);                                                                                                // 下一月开始时间
    datetime         LastMonthEndTime(datetime time){return MonthEndTime(LastMonthBeginTime(time));};                                                  // 下一月结束时间
    // 指定年份的日开始、结束时间
    datetime         YearBeginTime(datetime time){return StrToTime(IntegerToString(TimeYear(time))+".01.01");};     // 年开始时间
    datetime         YearEndTime(datetime time){return StrToTime(IntegerToString(TimeYear(time))+".12.31");};       // 年结束时间
    datetime         LastYearBeginTime(datetime time){return StrToTime(IntegerToString(TimeYear(time)-1)+".01.01");}; // 下一年开始时间
    datetime         LastYearEndTime(datetime time){return StrToTime(IntegerToString(TimeYear(time)-1)+".12.31");};   // 下一年结束时间
                           
public: 
    // 时间格式化 （使用 - 分隔时间）
    string           FormatDatetime(datetime time){string time_to_str = TimeToStr(time,TIME_DATE|TIME_SECONDS);StringReplace(time_to_str,".","-");return time_to_str;};  
    
    // 日期的起始和结束时间
    datetime         DayBegin(datetime time){return DayBeginTime(time);};                // 日开始时间
    datetime         DayEnd(datetime time){return DayEndTime(time);};                    // 日开始时间    
    datetime         TodayBegin(){return DayBeginTime(NowTime());};                      // 今日开始时间
    datetime         TodayEnd(){return DayEndTime(NowTime());};                          // 今日结束时间
    datetime         YesterdayBegin(){return LastDayBeginTime(NowTime());};              // 昨日开始时间 
    datetime         YesterdayEnd(){return LastDayEndTime(NowTime());};                  // 昨日结束时间  
    datetime         LastDayBegin(datetime time){return LastDayBeginTime(time);};        // 上一日开始时间
    datetime         LastDayEnd(datetime time){return LastDayEndTime(time);};            // 上一日开始时间
    // 周的起始和结束时间
    datetime         WeekBegin(datetime time){return WeekBeginTime(time);};
    datetime         WeekEnd(datetime time){return WeekEndTime(time);};
    datetime         CurrentWeekBegin(){return WeekBeginTime(NowTime());};
    datetime         CurrentWeekEnd(){return WeekEndTime(NowTime());};
    datetime         LastWeekBegin(datetime time){return LastWeekBeginTime(time);};
    datetime         LastWeekEnd(datetime time){return LastWeekEndTime(time);};
                     // 前7日的开始和结束时间(不包括当日)
    datetime         Last7DaysBegin(datetime time){return Last7DaysBeginTime(time);};
    datetime         Last7DaysEnd(datetime time){return Last7DaysEndTime(time);};
    // 月份的起始和结束时间
    datetime         MonthBegin(datetime time){return MonthBeginTime(time);};                 // 月开始时间
    datetime         MonthEnd(datetime time){return MonthEndTime(time);};                     // 月结束时间
    datetime         CurrentMonthBegin(){return MonthBeginTime(NowTime());};                  // 本月开始时间
    datetime         CurrentMonthEnd(){return MonthEndTime(NowTime());};                      // 本月结束时间         
    datetime         LastMonthBegin(datetime time){return LastMonthBeginTime(time);};         // 上一月开始时间
    datetime         LastMonthEnd(datetime time){return LastMonthEndTime(time);}; 
    // 年份的起始和结束时间
    datetime         YearBegin(datetime time){return YearBeginTime(time);};     
    datetime         YearEnd(datetime time){return YearEndTime(time);};
    datetime         CurrentYearBegin(){return YearBeginTime(NowTime());};     
    datetime         CurrentYearEnd(){return YearEndTime(NowTime());};   
    datetime         LastYearBegin(datetime time){return LastYearBeginTime(time);};            // 上一年开始时间
    datetime         LastYearEnd(datetime time){return LastYearEndTime(time);};                // 上一年开始时间
    
  };
//+------------------------------------------------------------------+
//| 当前时间                                                         |
//+------------------------------------------------------------------+
datetime CDayTime::NowTime()
{
       datetime time = TimeCurrent();
       if(TRADER_TIME>TimeCurrent())
       {
          time = TRADER_TIME;
       }
       return time;
}
//+------------------------------------------------------------------+
//| 指定时间当月的最后时间                                           |
//+------------------------------------------------------------------+
datetime CDayTime::MonthEndTime(datetime time)
{
   int year = TimeYear(time);
   int month = TimeMonth(time);
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
   datetime next_month_time = StrToTime(IntegerToString(next_month_year)+"."+next_month_str+".01") -1;
   return next_month_time;
}
//+------------------------------------------------------------------+
//| 指定时间上一月的开始时间                                         |
//+------------------------------------------------------------------+
datetime CDayTime::LastMonthBeginTime(datetime time)
{
   int year = TimeYear(time);
   int month = TimeMonth(time);
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
   datetime next_month_time = StrToTime(IntegerToString(last_month_year)+"."+last_month_str+".01");
   return next_month_time;
}
//+------------------------------------------------------------------+
//| 指定时间周的开始时间                                             |
//+------------------------------------------------------------------+
datetime CDayTime::WeekBeginTime(datetime time)
{
   int day_of_week = TimeDayOfWeek(time);
   if(day_of_week==0)
   {
      day_of_week = 7;
   }
   return DayBegin(time) - (day_of_week -1) * ONE_DAY_TIME;
}