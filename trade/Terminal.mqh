//+------------------------------------------------------------------+
//|                                                     Terminal.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|  客户端属性                                                      |
//+------------------------------------------------------------------+
class CTerminal
  {
private:

protected:

public:
   int               InfoInteger(ENUM_TERMINAL_INFO_INTEGER property){return TerminalInfoInteger(property);};   
   int               build(){return InfoInteger(TERMINAL_BUILD);};                                      // 版本号
   bool              communityAccount(){return (bool)InfoInteger(TERMINAL_COMMUNITY_ACCOUNT);};         // 判断程序端中存在MQL5.community 授权数据
   bool              communityConnection(){return (bool)InfoInteger(TERMINAL_COMMUNITY_CONNECTION);};   // 是否已经连接 MQL5.community
   bool              connected(){return (bool)InfoInteger(TERMINAL_CONNECTED);};                        // 是否连接交易服务器
   bool              dllsAllowed(){return (bool)InfoInteger(TERMINAL_DLLS_ALLOWED);};                   // 是否允许使用DLL
   bool              tradeAllowed(){return (bool)InfoInteger(TERMINAL_TRADE_ALLOWED);};                 // 是否允许交易
   bool              emailEnabled(){return (bool)InfoInteger(TERMINAL_EMAIL_ENABLED);};                 // 是否允许使用SMTP-server发送邮件
   bool              ftpEnabled(){return (bool)InfoInteger(TERMINAL_FTP_ENABLED);};                     // 是否允许使用FTP-server发送报告
   bool              notificationsEnabled(){return (bool)InfoInteger(TERMINAL_NOTIFICATIONS_ENABLED);}; // 是否允许向手机发送通知
   int               maxBars(){return InfoInteger(TERMINAL_MAXBARS);};                                  // 图表中的最大bar数量
   bool              mqid(){return (bool)InfoInteger(TERMINAL_MQID);};                                  // 是否存在MetaQuotes ID 数据 推送通知
   int               codePage(){return InfoInteger(TERMINAL_CODEPAGE);};                                // 语言代码页
   int               cpuCores(){return InfoInteger(TERMINAL_CPU_CORES);};                               // 系统的CPU 内核数量
   int               diskSpace(){return InfoInteger(TERMINAL_DISK_SPACE);};                             // MQL5\Files 文件夹的空闲磁盘空间，MB
   int               memoryPhysical(){return InfoInteger(TERMINAL_MEMORY_PHYSICAL);};                   // 物理内存，MB
   int               memoryTotal(){return InfoInteger(TERMINAL_MEMORY_TOTAL);};                         // 进程的可用内存，MB
   int               memoryAvailable(){return InfoInteger(TERMINAL_MEMORY_AVAILABLE);};                 // 进程的空闲内存，MB
   int               memoryUsed(){return InfoInteger(TERMINAL_MEMORY_USED);};                           // 已使用的内存，MB
   int               x64(){return InfoInteger(TERMINAL_X64);};                                          // 64位程序端
   int               openclSupport(){return InfoInteger(TERMINAL_OPENCL_SUPPORT);};                     // OpenCL 支持的版本格式 0x00010002 = 1.2。 "0" 表示OpenCL 不被支持
   int               screenDPI(){return InfoInteger(TERMINAL_SCREEN_DPI);};                             // 屏幕上显示信息的分辨率是以每英寸一行的点数计算的（DPI）
   int               left();                                                                            // 相对于虚拟屏幕的程序端的左坐标
   int               top();                                                                             // 相对于虚拟屏幕的程序端的顶部坐标
   int               right();                                                                           // 相对于虚拟屏幕的程序端的右坐标
   int               bottom();                                                                          // 相对于虚拟屏幕的程序端的底部坐标  
   int               screenLeft();                                                                      // 虚拟屏幕的左坐标
   int               screenTop();                                                                       // 虚拟屏幕的顶部坐标
   int               screenWidth();                                                                     // 虚拟屏幕的宽度
   int               screenHeight();                                                                    // 虚拟屏幕的高度
   int               pingLast(){return InfoInteger(TERMINAL_PING_LAST);};                               // 最后知道的交易服务器的微秒ping值。一秒包含一百万微秒
   bool              vps(){return (bool)InfoInteger(TERMINAL_VPS);};                                    // 在MetaTrader虚拟主机服务器 (MetaTrader VPS)上启动
   // 按键标识符
   int               keyStateLeft(){return InfoInteger(TERMINAL_KEYSTATE_LEFT);};                       // “左箭头”键状态
   int               keyStateUp(){return InfoInteger(TERMINAL_KEYSTATE_UP);};                           // “向上箭头”键状态
   int               keyStateRight(){return InfoInteger(TERMINAL_KEYSTATE_RIGHT);};                     // “右箭头”键状态
   int               keyStateDown(){return InfoInteger(TERMINAL_KEYSTATE_DOWN);};                       // “向下箭头”键状态
   int               keyStateShift(){return InfoInteger(TERMINAL_KEYSTATE_SHIFT);};                     // “Shift”键状态
   int               keyStateControl(){return InfoInteger(TERMINAL_KEYSTATE_CONTROL);};                 // “Ctrl”键状态
   int               keyStateMenu(){return InfoInteger(TERMINAL_KEYSTATE_MENU);};                       // “Windows”键状态
   int               keyStateCapsLock(){return InfoInteger(TERMINAL_KEYSTATE_CAPSLOCK);};               // “CapsLock”键状态
   int               keyStateNumLock(){return InfoInteger(TERMINAL_KEYSTATE_NUMLOCK);};                 // “NumLock”键状态
   int               keyStateScrollLock(){return InfoInteger(TERMINAL_KEYSTATE_SCRLOCK);};              // “ScrollLock”键状态
   int               keyStateEnter(){return InfoInteger(TERMINAL_KEYSTATE_ENTER);};                     // “Enter”键状态
   int               keyStateInsert(){return InfoInteger(TERMINAL_KEYSTATE_INSERT);};                   // “Insert”键状态
   int               keyStateDelete(){return InfoInteger(TERMINAL_KEYSTATE_DELETE);};                   // “Delete”键状态
   int               keyStateHome(){return InfoInteger(TERMINAL_KEYSTATE_HOME);};                       // “Home”键状态
   int               keyStateEnd(){return InfoInteger(TERMINAL_KEYSTATE_END);};                         // “End”键状态
   int               keyStateTab(){return InfoInteger(TERMINAL_KEYSTATE_TAB);};                         // “Tab”键状态
   int               keyStatePageUp(){return InfoInteger(TERMINAL_KEYSTATE_PAGEUP);};                   // “PageUp”键状态
   int               keyStatePageDown(){return InfoInteger(TERMINAL_KEYSTATE_PAGEDOWN);};               // “PageDown”键状态
   int               keyStateEscape(){return InfoInteger(TERMINAL_KEYSTATE_ESCAPE);};                   // “Escape”键状态
   // 双精度属性  
   double            InfoDouble(ENUM_TERMINAL_INFO_DOUBLE property){return TerminalInfoDouble(property);};
   double            communityBalance(){return InfoDouble(TERMINAL_COMMUNITY_BALANCE);};                // MQL5.community的结余
   double            retransmission(){return InfoDouble(TERMINAL_RETRANSMISSION);};                     // 对于所有在指定计算机上运行应用程序和服务的TCP/IP协议中的现有网络数据包的百分比
   // 字符串属性
   string            InfoString(ENUM_TERMINAL_INFO_STRING property){return TerminalInfoString(property);};
   string            language(){return InfoString(TERMINAL_LANGUAGE);};                                 // 程序端语言
   string            company(){return InfoString(TERMINAL_COMPANY);};                                   // 公司名称
   string            name(){return InfoString(TERMINAL_NAME);};                                         // 程序端名称
   string            path(){return InfoString(TERMINAL_PATH);};                                         // 程序端启动文件夹
   string            dataPath(){return InfoString(TERMINAL_DATA_PATH);};                                // 程序端数据文件夹
   string            commonDataPath(){return InfoString(TERMINAL_COMMONDATA_PATH);};                    // 程序端的普通路径
   
  };

int CTerminal::left()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_LEFT);
   #endif
}

int CTerminal::top()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_TOP);
   #endif
}

int CTerminal::right()
{
   #ifdef __MQL4__
     return 1024;
   #else
     return TerminalInfoInteger(TERMINAL_RIGHT);
   #endif
}

int CTerminal::bottom()
{
   #ifdef __MQL4__
     return 768;
   #else
     return TerminalInfoInteger(TERMINAL_BOTTOM);
   #endif
}

int CTerminal::screenLeft()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_LEFT);
   #endif
}

int CTerminal::screenTop()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_LEFT);
   #endif
}

int CTerminal::screenHeight()
{
   #ifdef __MQL4__
     return 1080;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_HEIGHT);
   #endif
}

int CTerminal::screenWidth()
{
   #ifdef __MQL4__
     return 1920;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_WIDTH);
   #endif
}