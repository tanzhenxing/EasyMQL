//+------------------------------------------------------------------+
//|                                                 HistoryOrder.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CHistoryOrder
  {
private:

protected:

public:
   int          total(void){return HistoryOrdersTotal();};
   bool         select(ulong ticket){return HistoryOrderSelect(ticket);};
   ulong        getTicket(int index){return HistoryOrderGetTicket(index);};
   
   long         getInteger(ulong ticket,ENUM_ORDER_PROPERTY_INTEGER property){return HistoryOrderGetInteger(ticket,property);};
   bool         getInteger(ulong ticket,ENUM_ORDER_PROPERTY_INTEGER property,long& value){return HistoryOrderGetInteger(ticket,property,value);};
   long         ticket(ulong ticket){return getInteger(ticket,ORDER_TICKET);};                            // 持仓编号
   datetime     timeSetup(ulong ticket){return (datetime)getInteger(ticket,ORDER_TIME_SETUP);};           // 开盘时间
   long         timeSetupMSC(ulong ticket){return getInteger(ticket,ORDER_TIME_SETUP_MSC);};              // 开盘时间
   datetime     timeExpiration(ulong ticket){return (datetime)getInteger(ticket,ORDER_TIME_EXPIRATION);}; // 开盘时间
   datetime     timeDone(ulong ticket){return (datetime)getInteger(ticket,ORDER_TIME_DONE);};             // 持仓更改的时间(以秒为单位)
   long         timeDoneMSC(ulong ticket){return getInteger(ticket,ORDER_TIME_DONE_MSC);};                // 持仓更改的时间(以毫秒为单位)    
   long         magic(ulong ticket){return getInteger(ticket,ORDER_MAGIC);};                              // 魔术号
   long         positionID(ulong ticket){return getInteger(ticket,ORDER_POSITION_ID);};                   // 马上建立一个订单
   long         positionByID(ulong ticket){return getInteger(ticket,ORDER_POSITION_BY_ID);};              // 反向持仓标识符
   /* 
      订单类型:ORDER_TYPE_BUY(买入)、ORDER_TYPE_SELL(卖出)、ORDER_TYPE_BUY_LIMIT(限制买入)、ORDER_TYPE_SELL_LIMIT(限制卖出)、ORDER_TYPE_BUY_STOP(停止买入)、ORDER_TYPE_SELL_STOP(停止卖出)
      ORDER_TYPE_BUY_STOP_LIMIT(限制买入订单安置在停止限制价格中)、ORDER_TYPE_SELL_STOP_LIMIT(限制卖出订单安置在停止限制价格中)、ORDER_TYPE_CLOSE_BY(通过反向持仓平仓的订单)
   */
   ENUM_ORDER_TYPE         type(ulong ticket){return (ENUM_ORDER_TYPE)getInteger(ticket,ORDER_TYPE);};
   
   ENUM_ORDER_STATE        state(ulong ticket){return (ENUM_ORDER_STATE)getInteger(ticket,ORDER_STATE);};

   ENUM_ORDER_TYPE_FILLING typeFilling(ulong ticket){return (ENUM_ORDER_TYPE_FILLING)getInteger(ticket,ORDER_TYPE_FILLING);};
   ENUM_ORDER_TYPE_TIME    typeTime(ulong ticket){return (ENUM_ORDER_TYPE_TIME)getInteger(ticket,ORDER_TYPE_TIME);};  
   /*
      持仓原因:ORDER_REASON_CLIENT(桌面程序端的下单)、ORDER_REASON_MOBILE(移动程序端的下单)、ORDER_REASON_WEB(网页平台的下单)、ORDER_REASON_EXPERT(EA程序的下单)
      ORDER_REASON_SL(激活止损而下单)、ORDER_REASON_TP(激活止赢而下单)、ORDER_REASON_SO(Stop Out 事件而下单)
   */
   ENUM_ORDER_REASON       reason(ulong ticket){return (ENUM_ORDER_REASON)getInteger(ticket,ORDER_REASON);};   
   
   double       getDouble(ulong ticket,ENUM_ORDER_PROPERTY_DOUBLE property){return HistoryOrderGetDouble(ticket,property);};
   bool         getDouble(ulong ticket,ENUM_ORDER_PROPERTY_DOUBLE property,double& value){return HistoryOrderGetDouble(ticket,property,value);};
   double       volumeInitial(ulong ticket){return getDouble(ticket,ORDER_VOLUME_INITIAL);};           // 初始成交量
   double       volumeCurrent(ulong ticket){return getDouble(ticket,ORDER_VOLUME_CURRENT);};           // 当前成交率
   double       priceOpen(ulong ticket){return getDouble(ticket,ORDER_PRICE_OPEN);};                   //
   double       stopLoss(ulong ticket){return getDouble(ticket,ORDER_SL);};                            // 止损
   double       takeProfit(ulong ticket){return getDouble(ticket,ORDER_TP);};                          // 止盈
   double       priceCurrent(ulong ticket){return getDouble(ticket,ORDER_PRICE_CURRENT);};             // 当前价位
   double       priceStopLimit(ulong ticket){return getDouble(ticket,ORDER_PRICE_STOPLIMIT);};         // 盈利
            
   string       getString(ulong ticket,ENUM_ORDER_PROPERTY_STRING property){return HistoryOrderGetString(ticket,property);};
   bool         getString(ulong ticket,ENUM_ORDER_PROPERTY_STRING property,string& value){return HistoryOrderGetString(ticket,property,value);};
   string       symbol(ulong ticket){return getString(ticket,ORDER_SYMBOL);};            // 交易品种
   string       comment(ulong ticket){return getString(ticket,ORDER_COMMENT);};          // 注释
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
