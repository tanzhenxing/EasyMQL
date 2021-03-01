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
   int               Build(){return TerminalInfoInteger(TERMINAL_BUILD);};                                      // 版本号
   bool              CommunityAccount(){return (bool)TerminalInfoInteger(TERMINAL_COMMUNITY_ACCOUNT);};         // 判断程序端中存在MQL5.community 授权数据
   bool              CommunityConnection(){return (bool)TerminalInfoInteger(TERMINAL_COMMUNITY_CONNECTION);};   // 是否已经连接 MQL5.community
   bool              Connected(){return (bool)TerminalInfoInteger(TERMINAL_CONNECTED);};                        // 是否连接交易服务器
   bool              DllsAllowed(){return (bool)TerminalInfoInteger(TERMINAL_DLLS_ALLOWED);};                   // 是否允许使用DLL
   bool              TradeAllowed(){return (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);};                 // 是否允许交易
   bool              EmailEnabled(){return (bool)TerminalInfoInteger(TERMINAL_EMAIL_ENABLED);};                 // 是否允许使用SMTP-server发送邮件
   bool              FtpEnabled(){return (bool)TerminalInfoInteger(TERMINAL_FTP_ENABLED);};                     // 是否允许使用FTP-server发送报告
   bool              NotificationsEnabled(){return (bool)TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED);}; // 是否允许向手机发送通知
   int               MaxBars(){return TerminalInfoInteger(TERMINAL_MAXBARS);};                                  // 图表中的最大bar数量
   bool              MQID(){return (bool)TerminalInfoInteger(TERMINAL_MQID);};                                  // 是否存在MetaQuotes ID 数据 推送通知
   int               CodePage(){return TerminalInfoInteger(TERMINAL_CODEPAGE);};                                // 语言代码页
   int               CPUCores(){return TerminalInfoInteger(TERMINAL_CPU_CORES);};                               // 系统的CPU 内核数量
   int               DiskSpace(){return TerminalInfoInteger(TERMINAL_DISK_SPACE);};                             // MQL5\Files 文件夹的空闲磁盘空间，MB
   int               MemoryPhysical(){return TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL);};                   // 物理内存，MB
   int               MemoryTotal(){return TerminalInfoInteger(TERMINAL_MEMORY_TOTAL);};                         // 进程的可用内存，MB
   int               MemoryAvailable(){return TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE);};                 // 进程的空闲内存，MB
   int               MemoryUsed(){return TerminalInfoInteger(TERMINAL_MEMORY_USED);};                           // 已使用的内存，MB
   int               X64(){return TerminalInfoInteger(TERMINAL_X64);};                                          // 64位程序端
   int               OpenclSupport(){return TerminalInfoInteger(TERMINAL_OPENCL_SUPPORT);};                     // OpenCL 支持的版本格式 0x00010002 = 1.2。 "0" 表示OpenCL 不被支持
   int               ScreenDPI(){return TerminalInfoInteger(TERMINAL_SCREEN_DPI);};                             // 屏幕上显示信息的分辨率是以每英寸一行的点数计算的（DPI）
   int               Left();                                                                                    // 相对于虚拟屏幕的程序端的左坐标
   int               Top();                                                                                     // 相对于虚拟屏幕的程序端的顶部坐标
   int               Right();                                                                                   // 相对于虚拟屏幕的程序端的右坐标
   int               Bottom();                                                                                  // 相对于虚拟屏幕的程序端的底部坐标  
   int               ScreenLeft();                                                                              // 虚拟屏幕的左坐标
   int               ScreenTop();                                                                               // 虚拟屏幕的顶部坐标
   int               ScreenWidth();                                                                             // 虚拟屏幕的宽度
   int               ScreenHeight();                                                                            // 虚拟屏幕的高度
   int               PingLast(){return TerminalInfoInteger(TERMINAL_PING_LAST);};                               // 最后知道的交易服务器的微秒ping值。一秒包含一百万微秒
   bool              VPS(){return (bool)TerminalInfoInteger(TERMINAL_VPS);};                                    // 在MetaTrader虚拟主机服务器 (MetaTrader VPS)上启动
   // 按键标识符
   int               KeyStateLeft(){return TerminalInfoInteger(TERMINAL_KEYSTATE_LEFT);};                       // “左箭头”键状态
   int               KeyStateUp(){return TerminalInfoInteger(TERMINAL_KEYSTATE_UP);};                           // “向上箭头”键状态
   int               KeyStateRight(){return TerminalInfoInteger(TERMINAL_KEYSTATE_RIGHT);};                     // “右箭头”键状态
   int               KeyStateDown(){return TerminalInfoInteger(TERMINAL_KEYSTATE_DOWN);};                       // “向下箭头”键状态
   int               KeyStateShift(){return TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT);};                     // “Shift”键状态
   int               KeyStateControl(){return TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL);};                 // “Ctrl”键状态
   int               KeyStateMenu(){return TerminalInfoInteger(TERMINAL_KEYSTATE_MENU);};                       // “Windows”键状态
   int               KeyStateCapsLock(){return TerminalInfoInteger(TERMINAL_KEYSTATE_CAPSLOCK);};               // “CapsLock”键状态
   int               KeyStateNumLock(){return TerminalInfoInteger(TERMINAL_KEYSTATE_NUMLOCK);};                 // “NumLock”键状态
   int               KeyStateScrollLock(){return TerminalInfoInteger(TERMINAL_KEYSTATE_SCRLOCK);};              // “ScrollLock”键状态
   int               KeyStateEnter(){return TerminalInfoInteger(TERMINAL_KEYSTATE_ENTER);};                     // “Enter”键状态
   int               KeyStateInsert(){return TerminalInfoInteger(TERMINAL_KEYSTATE_INSERT);};                   // “Insert”键状态
   int               KeyStateDelete(){return TerminalInfoInteger(TERMINAL_KEYSTATE_DELETE);};                   // “Delete”键状态
   int               KeyStateHome(){return TerminalInfoInteger(TERMINAL_KEYSTATE_HOME);};                       // “Home”键状态
   int               KeyStateEnd(){return TerminalInfoInteger(TERMINAL_KEYSTATE_END);};                         // “End”键状态
   int               KeyStateTab(){return TerminalInfoInteger(TERMINAL_KEYSTATE_TAB);};                         // “Tab”键状态
   int               KeyStatePageUp(){return TerminalInfoInteger(TERMINAL_KEYSTATE_PAGEUP);};                   // “PageUp”键状态
   int               KeyStatePageDown(){return TerminalInfoInteger(TERMINAL_KEYSTATE_PAGEDOWN);};               // “PageDown”键状态
   int               KeyStateEscape(){return TerminalInfoInteger(TERMINAL_KEYSTATE_ESCAPE);};                   // “Escape”键状态
     
   double            CommunityBalance(){return TerminalInfoDouble(TERMINAL_COMMUNITY_BALANCE);};                // MQL5.community的结余
   double            Retransmission(){return TerminalInfoDouble(TERMINAL_RETRANSMISSION);};                     // 对于所有在指定计算机上运行应用程序和服务的TCP/IP协议中的现有网络数据包的百分比
   
   string            Language(){return TerminalInfoString(TERMINAL_LANGUAGE);};                                 // 程序端语言
   string            Company(){return TerminalInfoString(TERMINAL_COMPANY);};                                   // 公司名称
   string            Name(){return TerminalInfoString(TERMINAL_NAME);};                                         // 程序端名称
   string            Path(){return TerminalInfoString(TERMINAL_PATH);};                                         // 程序端启动文件夹
   string            DataPath(){return TerminalInfoString(TERMINAL_DATA_PATH);};                                // 程序端数据文件夹
   string            CommonDataPath(){return TerminalInfoString(TERMINAL_COMMONDATA_PATH);};                    // 程序端的普通路径
   
  };

int CTerminal::Left()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_LEFT);
   #endif
}

int CTerminal::Top()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_TOP);
   #endif
}

int CTerminal::Right()
{
   #ifdef __MQL4__
     return 1024;
   #else
     return TerminalInfoInteger(TERMINAL_RIGHT);
   #endif
}

int CTerminal::Bottom()
{
   #ifdef __MQL4__
     return 768;
   #else
     return TerminalInfoInteger(TERMINAL_BOTTOM);
   #endif
}

int CTerminal::ScreenLeft()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_LEFT);
   #endif
}

int CTerminal::ScreenTop()
{
   #ifdef __MQL4__
     return 0;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_LEFT);
   #endif
}

int CTerminal::ScreenHeight()
{
   #ifdef __MQL4__
     return 1080;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_HEIGHT);
   #endif
}

int CTerminal::ScreenWidth()
{
   #ifdef __MQL4__
     return 1920;
   #else
     return TerminalInfoInteger(TERMINAL_SCREEN_WIDTH);
   #endif
}