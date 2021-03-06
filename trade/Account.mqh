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
    long          infoInteger(ENUM_ACCOUNT_INFO_INTEGER property){return AccountInfoInteger(property);};       //
    double        infoDouble(ENUM_ACCOUNT_INFO_DOUBLE property){return AccountInfoDouble(property);};          //
    string        infoString(ENUM_ACCOUNT_INFO_STRING property){return AccountInfoString(property);};          //
    
    long          login(){return infoInteger(ACCOUNT_LOGIN);};                        // 交易账号,  MQL4还可使用 AccountNumber();
    long          leverage(){return infoInteger(ACCOUNT_LEVERAGE);};                   // 账户杠杆，MQL4还可使用AccountLeverage();
    int           limitOrders(){return (int)infoInteger(ACCOUNT_LIMIT_ORDERS);};       // 最多持仓订单数量   
    bool          tradeAllowed(){return (bool)infoInteger(ACCOUNT_TRADE_ALLOWED);};  // 是否允许账户交易
    bool          tradeExpert(){return (bool)infoInteger(ACCOUNT_TRADE_EXPERT);};    // 是否允许EA交易    
    int           currencyDigits(){return #ifdef __MQL5__ (int)infoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif ;};   // 账户货币的小数位数
    /*
     ACCOUNT_FIFO_CLOSE，仅限mql5可用
     表示只能通过FIFO规则平仓的一种指示。如果该属性值设为true，那么每个交易品种都将按照持仓的相同顺序进行平仓，从最早持仓的开始。
     如果试图以不同的顺序平仓，那么交易者将收到一个对应的错误提示。
     对于采用非锁仓持仓账户模式的账户 (ACCOUNT_MARGIN_MODE!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)，该属性值始终为false。
    */
    bool          fifoClose(){return (#ifdef __MQL5__ (bool)infoInteger(ACCOUNT_FIFO_CLOSE) #else false #endif);}; 
    long          stopOutLevel(){return #ifdef __MQL5__ 100 #else ::AccountStopoutLevel() #endif ;};   // 强制平仓水平
    /*
       ENUM_ACCOUNT_TRADE_MODE: 
       0.样本账户 ACCOUNT_TRADE_MODE_DEMO
       1.竞争账户 ACCOUNT_TRADE_MODE_CONTEST
       2.真实账户 ACCOUNT_TRADE_MODE_REAL
    */
    ENUM_ACCOUNT_TRADE_MODE    tradeMode(){return (ENUM_ACCOUNT_TRADE_MODE)infoInteger(ACCOUNT_TRADE_MODE);};         // 账户交易方式
    /*
      ENUM_ACCOUNT_STOPOUT_MODE:
      0.账户以百分比方式截止 ACCOUNT_STOPOUT_MODE_PERCENT
      1.账户以金额方式截止 ACCOUNT_STOPOUT_MODE_MONEY
    */
    ENUM_ACCOUNT_STOPOUT_MODE  marginSoMode(){return (ENUM_ACCOUNT_STOPOUT_MODE)infoInteger(ACCOUNT_MARGIN_SO_MODE);}; // 创建订单最少使用保证金方式
    /*
      ENUM_ACCOUNT_MARGIN_MODE:
      0.ACCOUNT_MARGIN_MODE_RETAIL_NETTING,用于场外交易市场“单边持仓”模式下的持仓说明 (一个交易品种只存在一个持仓）。
      1.ACCOUNT_MARGIN_MODE_EXCHANGE,用于交易所市场。预付款计算基于交易品种设置中指定的折扣。折扣由交易商设定，但不能低于交易所设定的值。
      2.ACCOUNT_MARGIN_MODE_RETAIL_HEDGING,用于交易所市场，在这里个体持仓成为可能（锁仓，一个交易品种可以存在多个持仓）。
    */
    ENUM_ACCOUNT_MARGIN_MODE   marginMode(){return #ifdef __MQL5__ (ENUM_ACCOUNT_MARGIN_MODE)infoInteger(ACCOUNT_MARGIN_MODE) #else ACCOUNT_MARGIN_MODE_RETAIL_HEDGING #endif ;};   	// 预付款计算模式
     
   //--- Account real properties
    double        balance(){return infoDouble(ACCOUNT_BALANCE);}; // MQL4还可使用AccountBalance();
    double        credit(){return infoDouble(ACCOUNT_CREDIT);};  // MQL4还可使用AccountCredit();
    double        profit(){return infoDouble(ACCOUNT_PROFIT);};  // MQL4还可使用AccountProfit();
    double        equity(){return infoDouble(ACCOUNT_EQUITY);};  // MQL4还可使用AccountEquity();
    double        margin(){return infoDouble(ACCOUNT_MARGIN);};  // MQL4还可使用AccountMargin();
    double        marginFree(){return infoDouble(ACCOUNT_MARGIN_FREE);};  // MQL4还可使用 AccountFreeMargin()
    double        marginLevel(){return infoDouble(ACCOUNT_MARGIN_LEVEL);};
    double        marginSoCall(){return infoDouble(ACCOUNT_MARGIN_SO_CALL);};
    double        marginSoSo(){return infoDouble(ACCOUNT_MARGIN_SO_SO);};
    double        marginInitial(){return infoDouble(ACCOUNT_MARGIN_INITIAL);};
    double        marginMaintenance(){return infoDouble(ACCOUNT_MARGIN_MAINTENANCE);};
    double        assets(){return infoDouble(ACCOUNT_ASSETS);};
    double        liabilities(){return infoDouble(ACCOUNT_LIABILITIES);};
    double        comissionBlocked(){return infoDouble(ACCOUNT_COMMISSION_BLOCKED);};
       
   //--- Account string properties
    string        name(){return infoString(ACCOUNT_NAME);};            // MQL4还可使用AccountName();
    string        server(){return infoString(ACCOUNT_SERVER);};        // MQL4还可使用AccountServer();
    string        currency(){return infoString(ACCOUNT_CURRENCY);};    // MQL4还可使用AccountCurrency()
    string        company(){return infoString(ACCOUNT_COMPANY);};      // MQL4还可使用AccountCompany();
  // mql4 特有属性
  #ifdef __MQL4__
    int           number(){return AccountNumber();}
    double        freeMarginMode(){return AccountFreeMarginMode();};
    double        freeMarginCheck(string symbol,int type,double lots){return AccountFreeMarginCheck(symbol,type,lots);};
  #endif
  };