//+------------------------------------------------------------------+
//|                                                        Chart.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict


class CChart
  {
private:
                    
protected:

public:
   long              id(){return ChartID();};
   long              open(string symbol="",int period=0){return ChartOpen(symbol,period);}
   bool              applyTemplate(const string path,long id=0){return ChartApplyTemplate(id,path);};
   bool              saveTemplate(const string file_name,long id=0){return ChartSaveTemplate(id,file_name);};
   int               windowFind(const string short_name,long id=0){return ChartWindowFind(id,short_name);};
   bool              timePriceToXY(datetime time,double price,int x,int y,int sub_window=0,long id=0){return ChartTimePriceToXY(id,sub_window,time,price,x,y);};  
   bool              xyToTimePrice(int x,int y,datetime time,double price,int sub_window=0,long id=0){return ChartXYToTimePrice(id,x,y,sub_window,time,price);};
   long              first(){return ChartFirst();};  // 客户端第一图表ID
   long              next(long id=0){return ChartNext(id);} // 图表旁边的图表ID,0表示“返回第一图表”, 如果在图表列表末端，返回-1 。
   bool              close(long id=0){return ChartClose(id);};
   string            symbol(long id=0){return ChartSymbol(id);}; // 指定图表的交易品种名称
   ENUM_TIMEFRAMES   period(long id=0){return ChartPeriod(id);}; // 指定图表的时间表 周期 
   void              redraw(long id=0){ChartRedraw(id);}; // 指定图表被迫重画调用此函数,通常更改物件属性之后使用该函数
   bool              setDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,double value,long id=0){return ChartSetDouble(id,prop_id,value);}; // 设置指定图表相关属性值。
   bool              setInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int value,long id=0){return ChartSetInteger(id,prop_id,value);}; //
   bool              setInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int value,int sub_window=0,long id=0){return ChartSetInteger(id,prop_id,sub_window,value);}; //
   bool              setString(ENUM_CHART_PROPERTY_STRING prop_id,string value,long id=0){return ChartSetString(id,prop_id,value);}; //
   bool              setSymbolPeriod(ENUM_TIMEFRAMES  period=0,string symbol=NULL,long id=0){return ChartSetSymbolPeriod(id,symbol,period);}; //
   double            getDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,int sub_window=0,long id=0){return ChartGetDouble(id,prop_id,sub_window);}; //
   bool              getDouble(ENUM_CHART_PROPERTY_DOUBLE prop_id,double value,int sub_window=0,long id=0){return ChartGetDouble(id,prop_id,sub_window,value);}; //
   long              getInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,int sub_window=0,long id=0){return ChartGetInteger(id,prop_id,sub_window);}; //
   bool              getInteger(ENUM_CHART_PROPERTY_INTEGER prop_id,long& value,int sub_window=0,long id=0){return ChartGetInteger(id,prop_id,sub_window,value);}; //
   string            getString(ENUM_CHART_PROPERTY_STRING prop_id,long id=0){return ChartGetString(id,prop_id);}; // 
   bool              getString(ENUM_CHART_PROPERTY_STRING prop_id,string& value,long id=0){return ChartGetString(id,prop_id,value);}; //   
   bool              indicatorAdd(int handle,int sub_window=0,long id=0){return ChartIndicatorAdd(id,sub_window,handle);}; // 
   bool              indicatorDelete(const string shortname,int sub_window=0,long id=0){return ChartIndicatorDelete(id,sub_window,shortname);}; //
   int               indicatorGet(const string shortname,int sub_window=0,long id=0){return ChartIndicatorGet(id,sub_window,shortname);}; //
   string            indicatorName(int index,int sub_window=0,long id=0){return ChartIndicatorName(id,sub_window,index);}; //
   int               indicatorTotal(int sub_window=0,long id=0){return ChartIndicatorsTotal(id,sub_window);}; //
   int               windowOnDropped(){return ChartWindowOnDropped();}; // 
   double            priceOnDropped(){return ChartPriceOnDropped();}; // 
   datetime          timeOnDropped(){return ChartTimeOnDropped();}; // 
   int               xOnDropped(){return ChartXOnDropped();}; //
   int               yOnDropped(){return ChartYOnDropped();}; //
   bool              screenShot(string path="img/screen_shot.gif",int width=800,int height=600,ENUM_ALIGN_MODE align_mode=ALIGN_RIGHT,long id=0);
  };

//+------------------------------------------------------------------+
//| 图表截图                                                         |
//+------------------------------------------------------------------+
bool CChart::screenShot(string path,int width,int height,ENUM_ALIGN_MODE align_mode,long id)
{
   bool screen_shot;
    // 图表截图
   #ifdef __MQL5__ 
      screen_shot = ChartScreenShot(id,path,width,height,align_mode);
   #else
      screen_shot = WindowScreenShot(path,width,height);
   #endif
   
   return screen_shot;
}