# EasyMQL
EasyMQL is a MetaQuotes Language(MQL) framework, easy and quick development of MetaTrader programs. 

## 命名规范
### 一.目录和文件命名

1.目录使用小写+下划线；

2.类文件采用驼峰法命名（首字母大写），以.mqh为后缀；

### 二.类、函数、属性命名

1.类的命名采用驼峰法（首字母大写），例如 DayTime；

2.函数的命名使用小写字母和下划线（小写字母开头）的方式，例如 account_info；

3.方法的命名使用驼峰法（首字母小写），例如 getAccountName；

4.属性的命名使用驼峰法（首字母小写），例如 serverName、orders；

### 常量和配置

常量以大写字母和下划线命名，例如 LOG_PATH;

配置参数以小写字母和下划线命名，例如 file_path 和url_convert；

环境变量定义使用大写字母和下划线命名，例如EA_DEBUG；

### 数据表和字段
数据表和字段采用小写加下划线方式命名，并注意字段名不要以下划线开头，例如 em_user 表和 account_name字段，不建议使用驼峰和中文作为数据表及字段命名。
