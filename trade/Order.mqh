//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class COrder
  {
protected:

   
private:  
   

public:  
   // 计算指定订单类型的需要保证金
   int          total(void){return OrdersTotal();};
   ulong        getTicket(int index){return OrderGetTicket(index);};
   bool         select(ulong ticket){return OrderSelect(ticket);};
   bool         calcMargin(ENUM_ORDER_TYPE action,string symbol_name,double volume,double price,double& margin){return OrderCalcMargin(action,symbol_name,volume,price,margin);};
   bool         calcProfit(ENUM_ORDER_TYPE action,string symbol_name,double volume,double price_open,double price_close,double& profit){return OrderCalcProfit(action,symbol_name,volume,price_open,price_close,profit);};
   bool         check(MqlTradeRequest& request,MqlTradeCheckResult& result){return OrderCheck(request,result);};
   bool         send(MqlTradeRequest& request,MqlTradeResult& result){return OrderSend(request,result);};
   bool         sendAsync(MqlTradeRequest& request,MqlTradeResult& result){return OrderSendAsync(request,result);};
   
   long         getInteger(ENUM_ORDER_PROPERTY_INTEGER property){return OrderGetInteger(property);};
   bool         getInteger(ENUM_ORDER_PROPERTY_INTEGER property,long& value){return OrderGetInteger(property,value);};
   long         ticket(void){return getInteger(ORDER_TICKET);};                            // 持仓编号
   datetime     timeSetup(void){return (datetime)getInteger(ORDER_TIME_SETUP);};           // 开盘时间
   long         timeSetupMSC(void){return getInteger(ORDER_TIME_SETUP_MSC);};              // 开盘时间
   datetime     timeExpiration(void){return (datetime)getInteger(ORDER_TIME_EXPIRATION);}; // 开盘时间
   datetime     timeDone(void){return (datetime)getInteger(ORDER_TIME_DONE);};             // 持仓更改的时间(以秒为单位)
   long         timeDoneMSC(void){return getInteger(ORDER_TIME_DONE_MSC);};                // 持仓更改的时间(以毫秒为单位)    
   long         magic(void){return getInteger(ORDER_MAGIC);};                              // 魔术号
   long         positionID(void){return getInteger(ORDER_POSITION_ID);};                   // 马上建立一个订单
   long         positionByID(void){return getInteger(ORDER_POSITION_BY_ID);};              // 反向持仓标识符
   /* 
      订单类型:ORDER_TYPE_BUY(买入)、ORDER_TYPE_SELL(卖出)、ORDER_TYPE_BUY_LIMIT(限制买入)、ORDER_TYPE_SELL_LIMIT(限制卖出)、ORDER_TYPE_BUY_STOP(停止买入)、ORDER_TYPE_SELL_STOP(停止卖出)
      ORDER_TYPE_BUY_STOP_LIMIT(限制买入订单安置在停止限制价格中)、ORDER_TYPE_SELL_STOP_LIMIT(限制卖出订单安置在停止限制价格中)、ORDER_TYPE_CLOSE_BY(通过反向持仓平仓的订单)
   */
   ENUM_ORDER_TYPE         type(void){return (ENUM_ORDER_TYPE)getInteger(ORDER_TYPE);};
   
   ENUM_ORDER_STATE        state(void){return (ENUM_ORDER_STATE)getInteger(ORDER_STATE);};

   ENUM_ORDER_TYPE_FILLING typeFilling(void){return (ENUM_ORDER_TYPE_FILLING)getInteger(ORDER_TYPE_FILLING);};
   ENUM_ORDER_TYPE_TIME    typeTime(void){return (ENUM_ORDER_TYPE_TIME)getInteger(ORDER_TYPE_TIME);};  
   /*
      持仓原因:ORDER_REASON_CLIENT(桌面程序端的下单)、ORDER_REASON_MOBILE(移动程序端的下单)、ORDER_REASON_WEB(网页平台的下单)、ORDER_REASON_EXPERT(EA程序的下单)
      ORDER_REASON_SL(激活止损而下单)、ORDER_REASON_TP(激活止赢而下单)、ORDER_REASON_SO(Stop Out 事件而下单)
   */
   ENUM_ORDER_REASON       reason(void){return (ENUM_ORDER_REASON)getInteger(ORDER_REASON);};   
   
   double       getDouble(ENUM_ORDER_PROPERTY_DOUBLE property){return OrderGetDouble(property);};
   bool         getDouble(ENUM_ORDER_PROPERTY_DOUBLE property,double& value){return OrderGetDouble(property,value);};
   
   double       volumeInitial(void){return getDouble(ORDER_VOLUME_INITIAL);};           // 初始成交量
   double       volumeCurrent(void){return getDouble(ORDER_VOLUME_CURRENT);};           // 当前成交率
   double       priceOpen(void){return getDouble(ORDER_PRICE_OPEN);};                   //
   double       stopLoss(void){return getDouble(ORDER_SL);};                            // 止损
   double       takeProfit(void){return getDouble(ORDER_TP);};                          // 止盈
   double       priceCurrent(void){return getDouble(ORDER_PRICE_CURRENT);};             // 当前价位
   double       priceStopLimit(void){return getDouble(ORDER_PRICE_STOPLIMIT);};         // 盈利
            
   string       getString(ENUM_ORDER_PROPERTY_STRING property){return OrderGetString(property);};
   bool         getString(ENUM_ORDER_PROPERTY_STRING property,string& value){return OrderGetString(property,value);};
   string       symbol(void){return getString(ORDER_SYMBOL);};            // 交易品种
   string       comment(void){return getString(ORDER_COMMENT);};          // 注释
   
  };

