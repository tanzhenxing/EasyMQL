//+------------------------------------------------------------------+
//|                                                    Positions.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CPosition
  {
private:

protected:

public:
   int          total(void){return PositionsTotal();};
   string       getSymbol(int index){return PositionGetSymbol(index);};
   ulong        getTicket(int index){return PositionGetTicket(index);};
   bool         select(string symbol_name){return PositionSelect(symbol_name);};
   bool         selectByTicket(ulong ticket){return PositionSelectByTicket(ticket);};

   long         getInteger(ENUM_POSITION_PROPERTY_INTEGER property){return PositionGetInteger(property);};
   bool         getInteger(ENUM_POSITION_PROPERTY_INTEGER property,long& value){return PositionGetInteger(property,value);};
   long         ticket(void){return getInteger(POSITION_TICKET);};                         // 持仓编号
   datetime     time(void){return (datetime)getInteger(POSITION_TIME);};                   // 开盘时间
   long         timeMSC(void){return getInteger(POSITION_TIME_MSC);};                      // 持仓的时间(以毫秒为单位)
   datetime     timeUpdate(void){return (datetime)getInteger(POSITION_TIME_UPDATE);};      // 持仓更改的时间(以秒为单位)
   long         timeUpdateMSC(void){return getInteger(POSITION_TIME_UPDATE_MSC);};         // 持仓更改的时间(以毫秒为单位)  
   long         magic(void){return getInteger(POSITION_MAGIC);};                           // 魔术号
   long         identifier(void){return getInteger(POSITION_IDENTIFIER);};                 // 标识码
   // 持仓类型:POSITION_TYPE_BUY(买入)、POSITION_TYPE_SELL(卖出)
   ENUM_POSITION_TYPE         type(void){return (ENUM_POSITION_TYPE)getInteger(POSITION_TYPE);};         
   // 持仓原因:POSITION_REASON_CLIENT(桌面程序端的下单)、POSITION_REASON_MOBILE(移动程序端的下单)、POSITION_REASON_WEB(网页平台的下单)、POSITION_REASON_EXPERT(EA程序的下单)
   ENUM_POSITION_REASON       reason(void){return (ENUM_POSITION_REASON)getInteger(POSITION_REASON);};   
   
   double       getDouble(ENUM_POSITION_PROPERTY_DOUBLE property){return PositionGetDouble(property);};
   bool         getDouble(ENUM_POSITION_PROPERTY_DOUBLE property,double& value){return PositionGetDouble(property,value);};
   double       volume(void){return getDouble(POSITION_VOLUME);};                          // 成交量
   double       priceOpen(void){return getDouble(POSITION_PRICE_OPEN);};                   // 开盘价格
   double       stopLoss(void){return getDouble(POSITION_SL);};                            // 止损
   double       takeProfit(void){return getDouble(POSITION_TP);};                          // 止盈
   double       priceCurrent(void){return getDouble(POSITION_PRICE_CURRENT);};             // 当前价位
   double       swap(void){return getDouble(POSITION_SWAP);};                              //
   double       profit(void){return getDouble(POSITION_PROFIT);};                          // 盈利
            
   string       getString(ENUM_POSITION_PROPERTY_STRING property){return PositionGetString(property);};
   bool         getString(ENUM_POSITION_PROPERTY_STRING property,string& value){return PositionGetString(property,value);};
   string       symbol(void){return getString(POSITION_SYMBOL);};            // 交易品种
   string       comment(void){return getString(POSITION_COMMENT);};          // 注释
   string       externalID(void){return getString(POSITION_EXTERNAL_ID);};   // 外部交易系统（交易所）中的持仓ID
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

