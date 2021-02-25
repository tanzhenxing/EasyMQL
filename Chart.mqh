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
   bool              ScreenShot(int width=800,int height=600,int bar=-1,int scale=-1,int mode=-1);
   
  };
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| 固定位置标签                                                     |
//+------------------------------------------------------------------+
void CChart::Create(string object_name,string text,int x,int y,int corner,color color_name,string font_name,int font_size)
{
   ObjectCreate(object_name,OBJ_LABEL,0,0,0); // 创建标签物件
   ObjectSetText(object_name,text,font_size,font_name,color_name); // 设置标签物件文字,大小,字型,颜色
   ObjectSet(object_name,OBJPROP_XDISTANCE,x); // 设置x轴距离
   ObjectSet(object_name,OBJPROP_YDISTANCE,y); //设置y轴距离
   ObjectSet(object_name,OBJPROP_CORNER,corner); // 固定角内
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
    ObjectCreate(0,object_name,OBJ_BITMAP_LABEL,0,0,0);
    ObjectSetString(0,object_name,OBJPROP_BMPFILE,1,"/Images/bg.bmp");
    ObjectSet(object_name,OBJPROP_XDISTANCE,x); // 设置x轴距离
    ObjectSet(object_name,OBJPROP_YDISTANCE,y); //设置y轴距离
}
//+------------------------------------------------------------------+
//| 删除图表中的所有对象                                             |
//+------------------------------------------------------------------+
void CChart::Delete()
{
   for(int i=ObjectsTotal();i>=0;i--)
   {
     ObjectDelete(ObjectName(i));
   }
}
//+------------------------------------------------------------------+
//| 图表截图                                                         |
//+------------------------------------------------------------------+
bool CChart::ScreenShot(int width,int height,int bar,int scale,int mode)
{
    // 图片保存路径
    string path = "img/screen_shot.gif";
    // 图表截图
    if(WindowScreenShot(path,width,height,bar,scale,mode))
    {
        return true;
    } else {
        Print("保存截图文件:"+path+"失败");
        return false;
    }
}