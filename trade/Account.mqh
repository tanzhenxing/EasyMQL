//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CAccount
  {
private:
    
protected:    
    
public:
    long          Login(){return AccountInfoInteger(ACCOUNT_LOGIN);};                        // 交易账号,  MQL4还可使用 AccountNumber();
    long          Leverage(){return AccountInfoInteger(ACCOUNT_LEVERAGE);};                   // 账户杠杆，MQL4还可使用AccountLeverage();
    int           LimitOrders(){return (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);};       // 最多持仓订单数量   
    bool          TradeAllowed(){return (bool)::AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);};  // 是否允许账户交易
    bool          TradeExpert(){return (bool)::AccountInfoInteger(ACCOUNT_TRADE_EXPERT);};    // 是否允许EA交易    
    int           CurrencyDigits(){return #ifdef __MQL5__ (int)::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif ;};   // 账户货币的小数位数
    /*
     ACCOUNT_FIFO_CLOSE，仅限mql5可用
     表示只能通过FIFO规则平仓的一种指示。如果该属性值设为true，那么每个交易品种都将按照持仓的相同顺序进行平仓，从最早持仓的开始。
     如果试图以不同的顺序平仓，那么交易者将收到一个对应的错误提示。
     对于采用非锁仓持仓账户模式的账户 (ACCOUNT_MARGIN_MODE!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)，该属性值始终为false。
    */
    bool          FifoClose(){return (#ifdef __MQL5__ (bool)AccountInfoInteger(ACCOUNT_FIFO_CLOSE) #else false #endif);}; 
    long          StopOutLevel(){return #ifdef __MQL5__ 100 #else ::AccountStopoutLevel() #endif ;};   // 强制平仓水平
    /*
       ENUM_ACCOUNT_TRADE_MODE: 
       0.样本账户 ACCOUNT_TRADE_MODE_DEMO
       1.竞争账户 ACCOUNT_TRADE_MODE_CONTEST
       2.真实账户 ACCOUNT_TRADE_MODE_REAL
    */
    ENUM_ACCOUNT_TRADE_MODE    TradeMode(){return (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);};         // 账户交易方式
    /*
      ENUM_ACCOUNT_STOPOUT_MODE:
      0.账户以百分比方式截止 ACCOUNT_STOPOUT_MODE_PERCENT
      1.账户以金额方式截止 ACCOUNT_STOPOUT_MODE_MONEY
    */
    ENUM_ACCOUNT_STOPOUT_MODE  MarginSoMode(){return (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);}; // 创建订单最少使用保证金方式
    /*
      ENUM_ACCOUNT_MARGIN_MODE:
      0.ACCOUNT_MARGIN_MODE_RETAIL_NETTING,用于场外交易市场“单边持仓”模式下的持仓说明 (一个交易品种只存在一个持仓）。
      1.ACCOUNT_MARGIN_MODE_EXCHANGE,用于交易所市场。预付款计算基于交易品种设置中指定的折扣。折扣由交易商设定，但不能低于交易所设定的值。
      2.ACCOUNT_MARGIN_MODE_RETAIL_HEDGING,用于交易所市场，在这里个体持仓成为可能（锁仓，一个交易品种可以存在多个持仓）。
    */
    ENUM_ACCOUNT_MARGIN_MODE   MarginMode(){return #ifdef __MQL5__ (ENUM_ACCOUNT_MARGIN_MODE)::AccountInfoInteger(ACCOUNT_MARGIN_MODE) #else ACCOUNT_MARGIN_MODE_RETAIL_HEDGING #endif ;};   	// 预付款计算模式
     
   //--- Account real properties
    double        Balance(){return AccountInfoDouble(ACCOUNT_BALANCE);}; // MQL4还可使用AccountBalance();
    double        Credit(){return AccountInfoDouble(ACCOUNT_CREDIT);};  // MQL4还可使用AccountCredit();
    double        Profit(){return AccountInfoDouble(ACCOUNT_PROFIT);};  // MQL4还可使用AccountProfit();
    double        Equity(){return AccountInfoDouble(ACCOUNT_EQUITY);};  // MQL4还可使用AccountEquity();
    double        Margin(){return AccountInfoDouble(ACCOUNT_MARGIN);};  // MQL4还可使用AccountMargin();
    double        MarginFree(){return AccountInfoDouble(ACCOUNT_MARGIN_FREE);};  // MQL4还可使用 AccountFreeMargin()
    double        MarginLevel(){return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);};
    double        MarginSoCall(){return AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);};
    double        MarginSoSo(){return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);};
    double        MarginInitial(){return AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);};
    double        MarginMaintenance(){return AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);};
    double        Assets(){return AccountInfoDouble(ACCOUNT_ASSETS);};
    double        Liabilities(){return AccountInfoDouble(ACCOUNT_LIABILITIES);};
    double        ComissionBlocked(){return AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);};
       
   //--- Account string properties
    string        Name(){return AccountInfoString(ACCOUNT_NAME);};            // MQL4还可使用AccountName();
    string        Server(){return AccountInfoString(ACCOUNT_SERVER);};        // MQL4还可使用AccountServer();
    string        Currency(){return AccountInfoString(ACCOUNT_CURRENCY);};    // MQL4还可使用AccountCurrency()
    string        Company(){return AccountInfoString(ACCOUNT_COMPANY);};      // MQL4还可使用AccountCompany();
  // mql4 特有属性
  #ifdef __MQL4__
    int           Number(){return AccountNumber();}
    double        FreeMarginMode(){return AccountFreeMarginMode();};
    double        FreeMarginCheck(string symbol,int type,double lots){return AccountFreeMarginCheck(symbol,type,lots);};
  #endif
  };