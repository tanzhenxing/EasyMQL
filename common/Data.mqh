//+------------------------------------------------------------------+
//|                                                        Array.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include "Json.mqh"

CJson     json;

class CData
  {
private:

protected:

public:
   void              push(long number);             // 推送 正数到临时数组
   void              pushArr(const int &arr[]);    // 推送 数组到临时数组
   
  };

//+------------------------------------------------------------------+
//| 保存整数到临时数组，过滤重复                                     |
//+------------------------------------------------------------------+
void CData::push(long number)
{
     int size = ArraySize(tem_arr);
     if(size==0)
     {
        ArrayResize(tem_arr,size+1);
        tem_arr[size] = number;
        return;
     }
     // 检查魔术号是否存在
     int find = false;
     for(int i=0;i<size;i++)
     {
         if(tem_arr[i]==number)
         {
            find = true;
            return;
         }
     }
     if(find==false)
     {
        ArrayResize(tem_arr,size+1);
        tem_arr[size] = number;
     }
     ArraySort(tem_arr);
}
//+------------------------------------------------------------------+
//| 推送数组到临时数组，过滤重复                                     |
//+------------------------------------------------------------------+
void CData::pushArr(const int &arr[])
{
     int size = ArraySize(arr);
     for(int i=0;i<size;i++)
     {
         push(arr[i]);
     }
     return;
}