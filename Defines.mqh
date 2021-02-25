//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property strict

#define BEGIN_TIME       (D'1970.01.01 00:00:00')
#define END_TIME         (D'3000.12.31 23:59:59') 
#define TRADER_TIME      (TimeGMT()+60*60)
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

// 全局数组
int tem_arr[];            // 临时数组
int magic_number_arr[];   // 魔术号列表
int ticket_arr[];         // 订单号列表
int close_arr[];          // 等待平仓的订单号

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
//| 订单参数                                                         |
//+------------------------------------------------------------------+
struct ENUM_ORDER_INFO
{
   int      ticket;
   int      magic_number;
   string   symbol;
   int      type;
   double   lots;
   datetime open_time;
   double   open_price;
   datetime close_time;
   double   close_price;
   double   stop_loss;
   double   take_profit;
   double   commission;
   double   taxes;
   double   swap;
   double   profit;
   string   comment;
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
       int       magic_number; // 魔术号
       datetime  open_time;    // 开仓时间
};
// 开仓失败的订单信息
struct OPEN_FAIL
{
       int       type;           // 类型
       double    lots;           // 手数
       int       magic_number;   // 魔术号
};
// 订单参数
struct ORDER_PARAM
{
       string    first_symbol;   // 主货币对
       string    second_symbol;  // 辅货币对
       string    comment_prefix; // 订单备注前缀
};
//+------------------------------------------------------------------+
//| 配置选项                                                         |
//+------------------------------------------------------------------+
enum ENUM_ORDER_PARAM
{
     FIRST_SYMBOL,    // 主货币对
     SECOND_SYMBOL,   // 辅货币对
     COMMENT,         // 订单备注
};
//+------------------------------------------------------------------+
//| 账户信息数据                                                     |
//+------------------------------------------------------------------+ 
struct ACCOUNT_DATA
{
      //--- Account integer properties
      long           login;                        // ACCOUNT_LOGIN (Account number)
      int            number;                       // current account number      
      long           leverage;                     // ACCOUNT_LEVERAGE (Leverage)
      long           limit_orders;                 // ACCOUNT_LIMIT_ORDERS (Maximum allowed number of active pending orders)
      int            margin_so_mode;               // ACCOUNT_MARGIN_SO_MODE (Mode of setting the minimum available margin level)
      bool           trade_allowed;                // ACCOUNT_TRADE_ALLOWED (Permission to trade for the current account from the server side)
      bool           trade_expert;                 // ACCOUNT_TRADE_EXPERT (Permission to trade for an EA from the server side)
      int            margin_mode;                  // ACCOUNT_MARGIN_MODE (Margin calculation mode)
      int            currency_digits;              // ACCOUNT_CURRENCY_DIGITS (Number of decimal places for the account currency)
      int            server_type;                  // Trade server type (MetaTrader 5, MetaTrader 4)
      bool           fifo_close;                   // The flag indicating that positions can be closed only by the FIFO rule
      bool           server_connect;               // 交易服务器连接状态
      ENUM_ACCOUNT_TRADE_MODE   trade_mode;         // ACCOUNT_TRADE_MODE (Trading account type)
      int            stop_out_mode;
      int            stop_out_level;
      
      //--- Account real properties
      double         balance;                      // ACCOUNT_BALANCE (Account balance in a deposit currency)
      double         credit;                       // ACCOUNT_CREDIT (Credit in a deposit currency)
      double         profit;                       // ACCOUNT_PROFIT (Current profit on an account in the account currency)
      double         equity;                       // ACCOUNT_EQUITY (Equity on an account in the deposit currency)
      double         margin;                       // ACCOUNT_MARGIN (Reserved margin on an account in a deposit currency)
      double         margin_free;                  // ACCOUNT_MARGIN_FREE (Free funds available for opening a position in a deposit currency)
      double         margin_level;                 // ACCOUNT_MARGIN_LEVEL (Margin level on an account in %)
      double         margin_so_call;               // ACCOUNT_MARGIN_SO_CALL (MarginCall)
      double         margin_so_so;                 // ACCOUNT_MARGIN_SO_SO (StopOut)
      double         margin_initial;               // ACCOUNT_MARGIN_INITIAL (Funds reserved on an account to ensure a guarantee amount for all pending orders)
      double         margin_maintenance;           // ACCOUNT_MARGIN_MAINTENANCE (Funds reserved on an account to ensure a minimum amount for all open positions)
      double         assets;                       // ACCOUNT_ASSETS (Current assets on an account)
      double         liabilities;                  // ACCOUNT_LIABILITIES (Current liabilities on an account)
      double         comission_blocked;            // ACCOUNT_COMMISSION_BLOCKED (Current sum of blocked commissions on an account)
      double         free_margin;
      double         free_margin_mode;
      
      //--- Account string properties
      string         name;                         // ACCOUNT_NAME (Client name)
      string         server;                       // ACCOUNT_SERVER (Trade server name)
      string         currency;                     // ACCOUNT_CURRENCY (Deposit currency)
      string         company;                      // ACCOUNT_COMPANY (Name of a company serving an account)
      string         expert_name;                  // ea名称
};