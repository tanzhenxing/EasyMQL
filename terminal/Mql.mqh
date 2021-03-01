//+------------------------------------------------------------------+
//|                                                          Mql.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

class CMql
  {
private:

protected:

public:
     int           MemoryLimit(){return MQLInfoInteger(MQL_MEMORY_LIMIT);};             // MQL程序最大可能的动态内存数，MB
     int           MemoryUsed(){return MQLInfoInteger(MQL_MEMORY_USED);};               // MQL程序使用的内存大小，MB    	     
     bool          DllsAllowed(){return (bool)MQLInfoInteger(MQL_DLLS_ALLOWED);};       // 是否允许dll
     bool          TradeAllowed(){return (bool)MQLInfoInteger(MQL_TRADE_ALLOWED);};     // 允许为已生效的程序交易
     bool          SignalsAllowed(){return (bool)MQLInfoInteger(MQL_SIGNALS_ALLOWED);}; // 允许为已生效的程序更改信号
     bool          Debug(){return (bool)MQLInfoInteger(MQL_DEBUG);};                    // 表示程序在调试模式下运行
     bool          Profiler(){return (bool)MQLInfoInteger(MQL_PROFILER);};              // 表示程序在代码分析模式下运行
     bool          Tester(){return (bool)MQLInfoInteger(MQL_TESTER);};                  // 表示程序在测试中运行
     bool          Forward(){return (bool)MQLInfoInteger(MQL_FORWARD);};                // 表示程序在前向测试过程中运行
     bool          Optimization(){return (bool)MQLInfoInteger(MQL_OPTIMIZATION);};      // 表示程序在优化模式下运行
     bool          VisualMode(){return (bool)MQLInfoInteger(MQL_VISUAL_MODE);};         // 表示程序在可视测试模式下运行
     bool          FrameMode(){return (bool)MQLInfoInteger(MQL_FRAME_MODE);};           // 表示EA交易在收集优化结果框架模式下运行
     ENUM_PROGRAM_TYPE          ProgramType(){return (ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE);};  // MQL程序类型
     /*
       ENUM_PROGRAM_TYPE: 
       PROGRAM_SCRIPT 脚本
       PROGRAM_EXPERT 专家
       PROGRAM_INDICATOR 指标
     */    
     ENUM_LICENSE_TYPE          LicenseType(){return (ENUM_LICENSE_TYPE)MQLInfoInteger(MQL_LICENSE_TYPE);};  // 模块的许可证类型
     /* ENUM_LICENSE_TYPE : 
        LICENSE_FREE 免费无限使用版 、 LICENSE_DEMO 市场付费产品的试用版仅在策略测试中工作、
        LICENSE_FULL 购买的授权版允许至少5次激活。激活次数由卖家设定。卖家可以提高允许的激活次数、 
        LICENSE_TIME 有期限限制的授权版
     */
     string        ProgramName(){return MQLInfoString(MQL_PROGRAM_NAME);};              // 已执行程序名称
     string        ProgramPath(){return MQLInfoString(MQL_PROGRAM_PATH);};              // 已执行系统路径

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

