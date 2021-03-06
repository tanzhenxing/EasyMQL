//+------------------------------------------------------------------+
//|                                                 HistoryOrder.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CHistoryDeal
  {
private:

protected:

public:
   int           total(void){return HistoryDealsTotal();};
   bool          select(ulong ticket){return HistoryDealSelect(ticket);};
   ulong         getTicket(int index){return HistoryDealGetTicket(index);};

   long          getInteger(ulong ticket,ENUM_DEAL_PROPERTY_INTEGER property){return HistoryDealGetInteger(ticket,property);};
   bool          getInteger(ulong ticket,ENUM_DEAL_PROPERTY_INTEGER property,long& value){return HistoryDealGetInteger(ticket,property,value);};
   long          ticket(ulong ticket){return (long)getInteger(ticket,DEAL_TICKET);};                         // 订单编号
   long          order(ulong ticket){return getInteger(ticket,DEAL_ORDER);};                           // 订单编号
   datetime      time(ulong ticket){return (datetime)getInteger(ticket,DEAL_TIME);};                   // 开盘时间
   long          timeMSC(ulong ticket){return getInteger(ticket,DEAL_TIME_MSC);};                      // 持仓的时间(以毫秒为单位)
   long          magic(ulong ticket){return getInteger(ticket,DEAL_MAGIC);};                           // 魔术号
   long          positionID(ulong ticket){return getInteger(ticket,DEAL_POSITION_ID);};                // 
   // 持仓类型:POSITION_TYPE_BUY(买入)、POSITION_TYPE_SELL(卖出)
   ENUM_DEAL_TYPE         type(ulong ticket){return (ENUM_DEAL_TYPE)getInteger(ticket,DEAL_TYPE);};       
   ENUM_DEAL_ENTRY        entry(ulong ticket){return (ENUM_DEAL_ENTRY)getInteger(ticket,DEAL_ENTRY);};     
   // 持仓原因:POSITION_REASON_CLIENT(桌面程序端的下单)、POSITION_REASON_MOBILE(移动程序端的下单)、POSITION_REASON_WEB(网页平台的下单)、POSITION_REASON_EXPERT(EA程序的下单)
   ENUM_DEAL_REASON       reason(ulong ticket){return (ENUM_DEAL_REASON)getInteger(ticket,DEAL_REASON);}; 
      
   double        getDouble(ulong ticket,ENUM_DEAL_PROPERTY_DOUBLE property){return HistoryDealGetDouble(ticket,property);};
   bool          getDouble(ulong ticket,ENUM_DEAL_PROPERTY_DOUBLE property,double& value){return HistoryDealGetDouble(ticket,property,value);};
   double        volume(ulong ticket){return getDouble(ticket,DEAL_VOLUME);};                          // 成交量
   double        price(ulong ticket){return getDouble(ticket,DEAL_PRICE);};                   // 开盘价格
   double        commission(ulong ticket){return getDouble(ticket,DEAL_COMMISSION);};                            // 止损  
   double        swap(ulong ticket){return getDouble(ticket,DEAL_SWAP);};                              //
   double        profit(ulong ticket){return getDouble(ticket,DEAL_PROFIT);};                          // 盈利
   double        fee(ulong ticket){return getDouble(ticket,DEAL_FEE);};                          // 止盈
   
   string        getString(ulong ticket,ENUM_DEAL_PROPERTY_STRING property){return HistoryDealGetString(ticket,property);};
   bool          getString(ulong ticket,ENUM_DEAL_PROPERTY_STRING property,string& value){return HistoryDealGetString(ticket,property,value);};
   string        symbol(ulong ticket){return getString(ticket,DEAL_SYMBOL);};            // 交易品种
   string        comment(ulong ticket){return getString(ticket,DEAL_COMMENT);};          // 注释
   string        externalID(ulong ticket){return getString(ticket,DEAL_EXTERNAL_ID);};   // 外部交易系统（交易所）中的持仓ID
                
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

