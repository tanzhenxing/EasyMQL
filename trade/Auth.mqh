//+------------------------------------------------------------------+
//|                                                         Auth.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#import "wininet.dll"
int InternetAttemptConnect (int x);
int InternetOpenW(string sAgent, int lAccessType, string sProxyName = "", string sProxyBypass = "", int lFlags = 0);
int InternetOpenUrlW(int hInternetSession, string &sUrl, string &sHeaders, int lHeadersLength,int lFlags, int lContext);
int InternetReadFile(int hFile,uchar &sBuffer[],int lNumBytesToRead,int &lNumberOfBytesRead);
int InternetConnectW(int hInternet,string &lpszServerName,int nServerPort,string &lpszUsername,string &lpszPassword,int dwService,int dwFlags,int dwContext);
int HttpOpenRequestW(int hConnect,string &lpszVerb,string &lpszObjectName,string &lpszVersion,string &lpszReferer,string &lplpszAcceptTypes,uint dwFlags,int dwContext);
int HttpSendRequestW(int hRequest,string &lpszHeaders,int dwHeadersLength,uchar &lpOptional[],int dwOptionalLength);
int HttpQueryInfoW(int hRequest,int dwInfoLevel,uchar &lpvBuffer[],int &lpdwBufferLength,int &lpdwIndex);
int InternetCloseHandle(int hInet);
#import

#define OPEN_TYPE_PRECONFIG           0  // 使用默认配置
#define FLAG_KEEP_CONNECTION 0x00400000  // 保持连接
#define FLAG_PRAGMA_NOCACHE  0x00000100  // 无缓冲
#define FLAG_RELOAD          0x80000000  // 当请求时重新加载页面
#define SERVICE_HTTP                  3  // Http 服务
#define HTTP_QUERY_CONTENT_LENGTH     5

#include "Terminal.mqh"
#include "..\common\Data.mqh"

CTerminal    terminal;

// 全局变量
string oauth_message = ""; // 授权验证返回的消息内容
double oauth_days = 0;     // 当前日期在一年中的天数 DayOfYear()

class CAuth
  {
private:

protected:
    string           server();
    
public:  
    bool             check();
                      
  };

//+------------------------------------------------------------------+
//| 服务器授权验证                                                   |
//+------------------------------------------------------------------+
string CAuth::server()
{
     string result = "{\"code\":\"1\", \"message\":\"试用版，没有订单交易功能，请联系管理员QQ：1507655607授权\"}";
     // 服务端api 接口 网址
     string url = "https://api.qianbailang.com/v4/auth/server";
     if(!terminal.dllsAllowed())
     {
        result = "{\"code\":\"1\", \"message\":\"授权失败，勾选【允许DLL导入】，然后运行EA\"}";
        return result;
     }
     if(InternetAttemptConnect(0) != 0)
     {
        result = "{\"code\":\"1\", \"message\":\"授权失败，没有连接网络\"}";
        return result;
     }
     string UserAgent="Mozilla"; string nill="";
     int hInternetSession = InternetOpenW(UserAgent,OPEN_TYPE_PRECONFIG,nill,nill,0);
     if(hInternetSession <= 0)
     {
        result = "{\"code\":\"1\", \"message\":\"授权失败，Internet Session出错\"}";
        InternetCloseHandle(hInternetSession);
        return result;
     }
     int hURL = InternetOpenUrlW(hInternetSession, url, nill, 0, FLAG_PRAGMA_NOCACHE, 0);
     if(hURL <= 0)
     {
        result = "{\"code\":\"1\", \"message\":\"授权失败，授权接口网址无法访问\"}";
        InternetCloseHandle(hURL);
        return result;
     }
     // 读取页面
     uchar cBuffer[256];
     int dwBytesRead;
     string text = "";
     while(!IsStopped())
     {
       bool bResult = InternetReadFile(hURL, cBuffer, 1024, dwBytesRead);
       if(dwBytesRead <= 0)
       {
           break;
       }
       result = text + CharArrayToString(cBuffer,0,dwBytesRead);
       return result;
     }
     // 关闭资源连接
     InternetCloseHandle(hInternetSession);
     InternetCloseHandle(hURL);
     return result;
}
//+------------------------------------------------------------------+
//| 授权检查                                                         |
//+------------------------------------------------------------------+
bool CAuth::check()
{
   MqlDateTime mql_time;
   TimeToStruct(day_time.nowTime(),mql_time);  
   double days = mql_time.year + mql_time.day_of_year * 0.001;
   
   string message="";
   if(days==oauth_days)
   {  // 授权成功，当日不重复检查授权
      message = "丰汇智能@"+IntegerToString(mql_time.year)+" √正版授权";
      // createObject("oauth_check",message,5,435,10,clrGreen,"微软雅黑",9);
      return true;
   } else {
       string get_oauth = server();
       string code = json.readStr(get_oauth,"code");
       message = json.readStr(get_oauth,"message");
       if(code=="0")
       {
          oauth_days = days;
          return true;
       } else {
          if(message=="fail")
          {
             message = "试用版，没有订单交易功能，请联系管理员 QQ：1507655607";
          }
          // createObject("oauth_check",message,5,435,10,clrRed,"微软雅黑",9);
       }
   }
   oauth_message = message;
   return false;
}