//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright      "Copyright 2021, Feng Hui Software Corp."
#property link           "https://www.fenghui.hk"
#property strict

#include "ToMQL4.mqh"

#define BEGIN_TIME       (D'1970.01.01 00:00:00')
#define END_TIME         (D'3000.12.31 23:59:59') 
#define TRADER_TIME      (TimeGMT()+60*60*2)
#define ONE_DAY_TIME     (60*60*24)
#define FILE_PATH        ("account/")
#define ACCOUNT_INFO     (FILE_PATH+"account_info.json")
#define HOLD_FILE        (FILE_PATH+"hold_orders.json")
#define HISTORY_FILE     (FILE_PATH+"history_orders.json")
#define TODAY_FILE       (FILE_PATH+"today_orders.json")
#define LAST_DAY_FILE    (FILE_PATH+"last_day_orders.json")
#define MONTH_FILE       (FILE_PATH+"month_orders.json")
#define LAST_MONTH_FILE  (FILE_PATH+"last_month_orders.json")
#define YEAR_FILE        (FILE_PATH+"year_orders.json")
#define LAST_YEAR_FILE   (FILE_PATH+"last_year_orders.json")
#define CASH_FILE        (FILE_PATH+"cash_orders.json")
#define OTHER_FILE       (FILE_PATH+"other_orders.json")
#define WEEK_FILE        (FILE_PATH+"week_orders.json")
#define LAST_WEEK_FILE   (FILE_PATH+"last_week_orders.json")
#define LAST_7DAYS_FILE  (FILE_PATH+"last_7days_orders.json")

#define ORDER_BUY        (0)
#define ORDER_SELL       (1)

// 全局数组
long tem_arr[];            // 临时数组
int  magic_number_arr[];   // 魔术号列表
int  ticket_arr[];         // 订单号列表
int  close_arr[];          // 等待平仓的订单号

//+------------------------------------------------------------------+
//| 止损方式                                                         |
//+------------------------------------------------------------------+
enum ENUM_STOP_LOSS
{
   STOP_LOSS_PERCENT,  // 按照百分比止损
   STOP_LOSS_CAPITAL   // 按照金额止损
};
//+------------------------------------------------------------------+
//| 运行模式                                                         |
//+------------------------------------------------------------------+
enum ENUM_RUN_MODE
{
   NORMAL_MODE,  // (正常模式)可平仓,可加仓,可开订单组
   ADD_MODE,     // (加仓模式)可平仓,可加仓,不可开订单组
   CLOSE_MODE,   // (清仓模式)可平仓,不加仓,不可开订单组
   STOP_MODE     // (停止模式)不平仓,不加仓,不可开订单组
};
//+------------------------------------------------------------------+
//| 筛选订单的方式                                                         |
//+------------------------------------------------------------------+
enum ENUM_ORDER_TIME
{
   OPEN_TIME,    // 开单时间
   CLOSE_TIME,   // 平单时间
};
//+------------------------------------------------------------------+
//| 订单数据统计                                                     |
//+------------------------------------------------------------------+
struct ORDERS_COUNT
{
       int       total;        // 订单数量
       double    profit;       // 订单盈利
       double    real_profit;  // 订单纯利
       double    lots;         // 订单手数
       double    commission;   // 手续费
       double    swap;         // 库存费
       string    orders_list;  // 订单详情列表
};
// 最新一组订单信息
struct ORDERS_LATEST
{
       long      magic_number; // 魔术号
       datetime  open_time;    // 开仓时间
};
// 开仓失败的订单信息
struct OPEN_FAIL
{
       int       type;           // 类型
       double    lots;           // 手数
       long      magic_number;   // 魔术号
};
// 交易配置
struct TRADE_CONFIG
{
       string    first_symbol;   // 主货币对
       string    second_symbol;  // 辅货币对
       string    comment;        // 订单备注
};
TRADE_CONFIG     g_trade_config;
//+------------------------------------------------------------------+
//| 配置选项                                                         |
//+------------------------------------------------------------------+
enum ENUM_ORDER_PARAM
{
     FIRST_SYMBOL,    // 主货币对
     SECOND_SYMBOL,   // 辅货币对
     COMMENT,         // 订单备注
};