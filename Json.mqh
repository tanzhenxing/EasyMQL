//+------------------------------------------------------------------+
//|                                                         Json.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <EasyMQL\File.mqh>
#include <EasyMQL\DayTime.mqh>

// 全局变量
CFile     file;
CDayTime  day_time;

class CJson : public CObject
  {
private:

protected:     
     string          ToStr(string json_str);
     
public:
     string          Read(string path, string name);
     bool            Write(string path, string content, int total=1, int code=0);
     string          ReadStr(string content, string name);
     
  };

//+------------------------------------------------------------------+
//| 读取json文件内容                                                 |
//| json 文件字段顺序 code,time,account_number,server,total,data     |
//+------------------------------------------------------------------+
string CJson::Read(string path, string name)
{
    string result = "";
    // 读取json文件内容
    string json_str = file.Read(path);
    if(json_str=="")
    {
       Print("json文件:" + path + " 内容为空");
       return result;
    }
    return ReadStr(json_str,name);
}
//+------------------------------------------------------------------+
//| 返回json格式的结果                                               |
//+------------------------------------------------------------------+
bool CJson::Write(string path, string content, int total, int code)
{
   string result = "{"
   + "\"code\":\"" + IntegerToString(code) + "\", "
   + "\"time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\", "
   + "\"account_number\":\"" + IntegerToString(AccountNumber()) + "\", "
   + "\"server\":\"" + AccountServer() + "\", "
   + "\"total\":\"" + IntegerToString(total) + "\", "
   + "\"data\":" + content
   + "}";
   return file.Write(path, result);
}
//+------------------------------------------------------------------+
//| 读取json 字符串                                                  |
//+------------------------------------------------------------------+
string CJson::ReadStr(string content, string name)
{
    // 检查json字符串是否包含 data 部分
    string result = "";
    string json_str = "";
    content = StringTrimLeft(content); // 删除左边的空格
    content = StringTrimRight(content); // 删除右边边的空格
    StringReplace(content,", \"data\":",",\"data\":");
    int first_replace = StringReplace(content,",\"data\":","}|");
    // 拆分json字符串
    string json_base_str;
    string json_data_str;
    string json_array[10];
    int count = 0;
    if(first_replace==1)
    {
       json_str = content;
       count = StringSplit(json_str,StringGetCharacter("|",0),json_array);
    } else { // json数据不存在data字段
       count = 2;
       json_array[0] = content;
       json_array[1] = "{\"message\":\"no data\"}";
    }
    if(count==2)
    {
       for(int i=0;i<count;i++)
       {
          switch(i)
          {
             case 0:
                    json_base_str = json_array[0];
                    break;
             case 1: // 获取 data 部分
                    StringReplace(json_array[1],"[","");
                    StringReplace(json_array[1],"]}","");
                    StringReplace(json_array[1],"},","}|");
                    json_data_str = json_array[1];
                    break;
          }
       }
    } else {
         Print("json 数据非自定义标准格式");
         return result;
    }
    // 解析 json_data_str
    if(name=="data")
    {
       return json_data_str;
    }
    // 解析 json_base_str 为数组
    string json_base_array[];
    json_base_str = ToStr(json_base_str);
    int base_count = StringSplit(json_base_str,StringGetCharacter(",",0),json_base_array);
    if(base_count>1)
    {
       for(int i=0;i<base_count;i++)
       {
          string base_array[];
          int item_count = StringSplit(json_base_array[i],StringGetCharacter("=",0),base_array);
          if(item_count>1)
          {
             if(name==base_array[0])
             {
                return base_array[1];
             }
          }
       }
    } else {
        Print("json_base_str 有误");
        return result;
    }
    return result;
}
//+------------------------------------------------------------------+
//| json 转 字符串                                                   |
//+------------------------------------------------------------------+
string CJson::ToStr(string json_str)
{
   string result = "";
   json_str = StringTrimLeft(json_str); // 删除左边的空格
   json_str = StringTrimRight(json_str); // 删除右边边的空格
   int str_len = StringLen(json_str);
   // 判断是否为json格式
   if(StringSubstr(json_str, 0,1)!="{" || StringSubstr(json_str, str_len-1,1)!="}")
   {
     Print("不是json数据:"+json_str);
     return result;
   }
   // 解析json数据
   string json_array[];
   int count = StringSplit(json_str,StringGetCharacter(",",0),json_array);
   if(count>0)
   {
      for(int i=0;i<count;i++)
      {
         json_array[i] = StringTrimLeft(json_array[i]);
         json_array[i] = StringTrimRight(json_array[i]);
         StringReplace(json_array[i],"{","");
         StringReplace(json_array[i],"}","");
         StringReplace(json_array[i],"}","");
         StringReplace(json_array[i],"\": ","=");
         StringReplace(json_array[i],"\":","=");
         StringReplace(json_array[i],"\"","");
         if(i==(count-1))
         {
            result = result + json_array[i];
         }else {
            result = result + json_array[i] + ",";
         }
      }
   } else {
         Print("无法识别的json数据:"+json_str);
         return result;
   }
   return result;
}