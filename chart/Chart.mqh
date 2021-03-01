//+------------------------------------------------------------------+
//|                                                        Chart.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>

class CChart : public CObject
  {
private:
                    
protected:

public:
   void              Create(string object_name,string text,int x,int y,int corner=10,color color_name=clrRed,string font_name="微软雅黑",int font_size=10);
   void              CreateArray(string object_name,const string & data[],int x,int y,int interval=20,color color_name=clrRed,string font_name="微软雅黑",int font_size=8);
   void              CreateBg(string object_name="bg_img",int x=0, int y=20);
   void              Delete();
   bool              ScreenShot(int width=800,int height=600);
   
  };
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| 固定位置标签                                                     |
//+------------------------------------------------------------------+
void CChart::Create(string object_name,string text,int x,int y,int corner,color color_name,string font_name,int font_size)
{
     //--- 画布的宽和高（用于绘制）
     #define IMG_WIDTH  50
     #define IMG_HEIGHT 100
     //--- 启用设置颜色格式
     ENUM_COLOR_FORMAT clr_format=COLOR_FORMAT_XRGB_NOALPHA;
     //--- 绘制数组（缓冲区） 
     uint ExtImg[IMG_WIDTH*IMG_HEIGHT];

   long chart_id=ChartID();
   ObjectCreate(chart_id,object_name,OBJ_LABEL,0,0,0); // 创建标签物件
   TextSetFont(font_name,font_size);
   
   TextOut(text,x,y,TA_LEFT|TA_TOP,ExtImg,IMG_WIDTH,IMG_HEIGHT,0xFFFFFFFF,clr_format); // 设置标签物件文字,大小,字型,颜色
}
//+------------------------------------------------------------------+
//| 创建图表标签对象                                                 |
//| object_name 标签名称，x轴，y轴，arr[]要显示的数据数组            |
//+------------------------------------------------------------------+
void CChart::CreateArray(string object_name,const string & arr[],int x,int y,int interval,color color_name,string font_name,int font_size)
{
   int count = ArraySize(arr);
   for(int i=0; i<count; i++)
   {
     string object_label = object_name + StringFormat("%d",i);
     Create(object_label,arr[i],x,y+(i*interval),interval,color_name,font_name,font_size);
   }
}
//+------------------------------------------------------------------+
//| 设置背景图片                                                     |
//+------------------------------------------------------------------+
void CChart::CreateBg(string object_name,int x, int y)
{
    long chart_id=ChartID();
    ObjectCreate(chart_id,object_name,OBJ_BITMAP_LABEL,0,0,0);
    ObjectSetString(chart_id,object_name,OBJPROP_BMPFILE,1,"/Images/bg.bmp");   
}
//+------------------------------------------------------------------+
//| 删除图表中的所有对象                                             |
//+------------------------------------------------------------------+
void CChart::Delete()
{
   long   chart_id = ChartID();
   for(int i=ObjectsTotal(ChartID());i>=0;i--)
   {
     #ifdef __MQL5__ 
        string object_name = ObjectName(chart_id,i);
        ObjectDelete(chart_id, object_name);
     #else 
        ObjectDelete(ObjectName(i));
     #endif 
   }
}
//+------------------------------------------------------------------+
//| 图表截图                                                         |
//+------------------------------------------------------------------+
bool CChart::ScreenShot(int width,int height)
{
    // 图片保存路径
    string path = "img/screen_shot.gif";
    long   chart_id = ChartID();
    bool   screen_shot;
    // 图表截图
   #ifdef __MQL5__ 
      screen_shot = ChartScreenShot(chart_id,path,width,height);
   #else
      screen_shot = WindowScreenShot(path,width,height);
   #endif
   
   return screen_shot;
}