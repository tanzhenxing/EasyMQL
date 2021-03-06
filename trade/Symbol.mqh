//+------------------------------------------------------------------+
//|                                                       Symbol.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CSymbol
  {
private:

protected:

public:
     int       total(bool selected=true){return SymbolsTotal(selected);}; // 返回可用交易品种数量,selected=true,市场窗口中的数量，selected=false，所有交易品种的数量。
     bool      exist(const string name,bool& is_custom){return SymbolExist(name,is_custom);}; // 检查指定名称的交易品种是否存在。
     string    name(int pos,bool selected=true){return SymbolName(pos,selected);}; // 交易品种名称
     bool      select(string name,bool selected=true){return SymbolSelect(name,selected);}; //
     bool      isSynchronized(string name){return SymbolIsSynchronized(name);}; //
     bool      infoMarginRate(string name,ENUM_ORDER_TYPE order_type,double& initial_margin_rate,double& maintenance_margin_rate){return SymbolInfoMarginRate(name,order_type,initial_margin_rate,maintenance_margin_rate);}; //
     bool      infoTick(string name,MqlTick& tick){return SymbolInfoTick(name,tick);}; //
     bool      infoSessionQuote(string name,ENUM_DAY_OF_WEEK day_of_week,uint session_index,datetime& from,datetime& to){return SymbolInfoSessionQuote(name,day_of_week,session_index,from,to);}; //
     bool      infoSessionTrade(string name,ENUM_DAY_OF_WEEK day_of_week,uint session_index,datetime& from,datetime& to){return SymbolInfoSessionTrade(name,day_of_week,session_index,from,to);}; //
         
     long      infoInteger(string name,ENUM_SYMBOL_INFO_INTEGER prop_id){return SymbolInfoInteger(name,prop_id);};  //
     bool      infoInteger(string name,ENUM_SYMBOL_INFO_INTEGER prop_id,long& value){return SymbolInfoInteger(name,prop_id,value);};
     
     ENUM_SYMBOL_SECTOR           sector(string name){return (ENUM_SYMBOL_SECTOR)infoInteger(name,SYMBOL_SECTOR);};
     ENUM_SYMBOL_INDUSTRY         industry(string name){return (ENUM_SYMBOL_INDUSTRY)infoInteger(name,SYMBOL_INDUSTRY);};
     ENUM_SYMBOL_CHART_MODE       chartMode(string name){return (ENUM_SYMBOL_CHART_MODE)infoInteger(name,SYMBOL_CHART_MODE);};
     ENUM_SYMBOL_CALC_MODE        tradeCalcMode(string name){return (ENUM_SYMBOL_CALC_MODE)infoInteger(name,SYMBOL_TRADE_CALC_MODE);};
     ENUM_SYMBOL_TRADE_MODE       tradeMode(string name){return (ENUM_SYMBOL_TRADE_MODE)infoInteger(name,SYMBOL_TRADE_MODE);};
     ENUM_SYMBOL_TRADE_EXECUTION  tradeExeMode(string name){return (ENUM_SYMBOL_TRADE_EXECUTION)infoInteger(name,SYMBOL_TRADE_EXEMODE);};
     ENUM_SYMBOL_SWAP_MODE        swapMode(string name){return (ENUM_SYMBOL_SWAP_MODE)infoInteger(name,SYMBOL_SWAP_MODE);};
     ENUM_DAY_OF_WEEK             swapRollOver3Days(string name){return (ENUM_DAY_OF_WEEK)infoInteger(name,SYMBOL_SWAP_ROLLOVER3DAYS);};
     ENUM_SYMBOL_ORDER_GTC_MODE   orderGtcMode(string name){return (ENUM_SYMBOL_ORDER_GTC_MODE)infoInteger(name,SYMBOL_ORDER_GTC_MODE);};
     ENUM_SYMBOL_OPTION_MODE      optionMode(string name){return (ENUM_SYMBOL_OPTION_MODE)infoInteger(name,SYMBOL_OPTION_MODE);};
     ENUM_SYMBOL_OPTION_RIGHT     optionRight(string name){return (ENUM_SYMBOL_OPTION_RIGHT)infoInteger(name,SYMBOL_OPTION_RIGHT);};
     
     double    infoDouble(string name,ENUM_SYMBOL_INFO_DOUBLE prop_id){return SymbolInfoDouble(name,prop_id);};  //
     bool      infoDouble(string name,ENUM_SYMBOL_INFO_DOUBLE prop_id,double& value){return SymbolInfoDouble(name,prop_id,value);};
     double    bid(string name){return infoDouble(name,SYMBOL_BID);};
     double    bidHigh(string name){return infoDouble(name,SYMBOL_BIDHIGH);};
     double    bidLow(string name){return infoDouble(name,SYMBOL_BIDLOW);};
     double    ask(string name){return infoDouble(name,SYMBOL_ASK);};
     double    askHigh(string name){return infoDouble(name,SYMBOL_ASKHIGH);};
     double    askLow(string name){return infoDouble(name,SYMBOL_ASKLOW);};
     
     string    infoString(string name,ENUM_SYMBOL_INFO_STRING prop_id){return SymbolInfoString(name,prop_id);};  //
     bool      infoString(string name,ENUM_SYMBOL_INFO_STRING prop_id,string& value){return SymbolInfoString(name,prop_id,value);};  
     string    basis(string name){return infoString(name,SYMBOL_BASIS);};
     string    category(string name){return infoString(name,SYMBOL_CATEGORY);};
     string    country(string name){return infoString(name,SYMBOL_COUNTRY);};
     string    sectorName(string name){return infoString(name,SYMBOL_SECTOR_NAME);};
     string    industryName(string name){return infoString(name,SYMBOL_INDUSTRY_NAME);};
     string    currencyBase(string name){return infoString(name,SYMBOL_CURRENCY_BASE);};
     string    currencyProfit(string name){return infoString(name,SYMBOL_CURRENCY_PROFIT);};
     string    currencyMargin(string name){return infoString(name,SYMBOL_CURRENCY_MARGIN);};
     string    bank(string name){return infoString(name,SYMBOL_BANK);};
     string    description(string name){return infoString(name,SYMBOL_DESCRIPTION);};
     string    exchange(string name){return infoString(name,SYMBOL_EXCHANGE);};
     string    formula(string name){return infoString(name,SYMBOL_FORMULA);};
     string    isin(string name){return infoString(name,SYMBOL_ISIN);};    // ISIN系统中交易品种的名称（国际证券识别号码）
     string    page(string name){return infoString(name,SYMBOL_PAGE);};
     string    path(string name){return infoString(name,SYMBOL_PATH);};
  };
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+