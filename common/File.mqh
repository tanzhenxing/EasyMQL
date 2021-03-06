//+------------------------------------------------------------------+
//|                                                         File.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CFile
  {
private:

protected:

public:
     string          read(string path, int row=0);
     bool            write(string path, string content, int mode=0);
     
                    
  };

//+------------------------------------------------------------------+
//| 读取文件中的内容                                                 |
//| string path:文件路径, int row：0文件中的全部内容，>0 指定行的内容|
//+------------------------------------------------------------------+
string CFile::read(string path, int row)
{
   string result = "";
   if(!FileIsExist(path))
   {
      Print("文件: " + path + "不存在," + "错误码：" + IntegerToString(GetLastError()));
      return result;
   }
   int handle = FileOpen(path,FILE_READ|FILE_TXT);
   if(handle==INVALID_HANDLE) // 打开文件失败
   {
      Print("打开文件: " + path + " 失败," + "错误码：" + IntegerToString(GetLastError()));
      return result;
   }
   if(row==0)
   { // 默认读取文件中的全部内容
      while(!FileIsEnding(handle))
      {
         result = result + FileReadString(handle);
      }
   } else {  // 读取指定行数
         int i = 1;
         while(!FileIsEnding(handle))
         {
           if(row==i) {
               result = FileReadString(handle);
               break;
           }
           i++;
         }
   }
   FileClose(handle); // 关闭文件
   return result;
}
//+------------------------------------------------------------------+
//| 把字符串写入到文件（0.覆盖模式,1.追加模式）                      |
//+------------------------------------------------------------------+
bool CFile::write(string path, string content, int mode)
{
    // 把字符串写入到文件中
    if(mode==0)
    {  // 覆盖模式写入
       int handle = FileOpen(path,FILE_READ|FILE_WRITE|FILE_CSV);
       if(handle==INVALID_HANDLE)
       {
          Print("打开文件：" + path + "失败， 覆盖模式写入字符串出错," + "错误码：" + IntegerToString(GetLastError()));
          return false;
       } else {
          FileWriteString(handle, content);
          FileClose(handle);
          return true;
       }
    } else {  // 追加内容到最后一行
         int handle = FileOpen(path,FILE_READ|FILE_WRITE|FILE_CSV);
         if(handle==INVALID_HANDLE)
         {
            Print("文件：" + path + " 追加模式写入字符串失败," + "错误码：" + IntegerToString(GetLastError()));
            return false;
         } else {
             FileSeek(handle, 0, SEEK_END);
             FileWriteString(handle, content);
             FileClose(handle);
             return true;
         }
    }
    return false;
}