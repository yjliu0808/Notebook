### 性能测试—jmeter脚本

#### 1.环境及项目部署

- 本地安装VMware虚拟机：[下载地址](https://pan.baidu.com/s/1Nfq1LnkovlEOXeHsXWq99A)

- 下载test项目：[下载地址](https://pan.baidu.com/s/1FxHr_C1pWM1OOknRAV2v9Q)

- VMware中导入test项目(.ova)文件

- 备注：

  1. 首次导入出现报错提示，尝试重试即可

  2. 编辑虚拟机设置：修改内存、处理器、网络配置项（可用NAT模式）

     <div align="left"> <img src="pics/vmware1.png" width="800"/> </div><br>

  3. 登录账密（root/123456）ifconfig查看本机ip：

     <div align="left"> <img src="pics/vmware2.png" width="800"/> </div><br>

     

#### 2.启动tomcat

- 项目基本信息：
  1. tomcat安装路径：   /opt/apache-tomcat-8
  2. jdk版本：1.7  
  3. docker方式安装的mysql，开机自启动mysql

- **启动tomcat**

  ```shell
  cd /opt/apache-tomcat-8.5.56/bin
  ./startup.sh  
  ```

#### 3.API文档

- [查看](https://github.com/yjliu0808/Notebook/blob/master/docs/Athena%E9%A1%B9%E7%9B%AE%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3.md)

#### 4.运行简单的jmeter脚本

- 测试计划：脚本的根文件夹

- 包括：线程组、取样器、监听器
- 当请求体为json， 一定要有请求头 Content-Type：application/json

<div align="left"> <img src="pics/jmeter-脚本.png" width="800"/> </div><br>

#### 5.jmeter路径说明

+ bin：启动配置文件

+ docs:文档用于jmeter进行二次开发调用的api接口文档

+ extras  扩展   CICD 性能测试持续集成

+ lib：jar包 、工具自身jar、以及第三方jar包、ext文件(第三方插件管理)

+ printable_docs:离线帮助文档

+ 在线帮助文档:

  <div align="left"> <img src="pics/jmeter-文档A.png" width="800"/> </div><br>

  <div align="left"> <img src="pics/jmeter-路径.png" width="800"/> </div><br>

#### 6.jmeter脚本元件（持续补充）

<div align="left"> <img src="pics/jmeter元件.png" width="800"/> </div><br>

##### 1.线程组

+ 线程组：**进行性能场景设计**(模拟多个用户)
+ setup线程组:之前执行
+ teardown线程组:之后执行

##### 2.配置元件

+ 优先级是最高（请求之前最先运行）
+ **用户定义变量**

##### 3.监听器

+ 性能结果进行监控，展示结果数据
+ 不同的元件，是从不同的角度，展示结果数据
+ 监听器： 调试脚本时使用，**性能测试执行时**，**禁用**

不管哪种监听器，都是对结果数据进行不同维度的展示，这些展示，是需要消耗本地资源的

##### 4.取样器

- 根据不同的协议，使用不同的取样器**编写脚本**
- 用户参数

##### 5.定时器

- 脚本功能增强 前面接口的响应信息，有动态值，作为后续接口的参数参数

#### 7.【用户定义的变量】和【用户参数】区别

- 用户定义的变量
  1. 位置：测试计划/配置元件/用户定义的变量
  2. 作用域：全局变量,作用整个测试计划
  3. 每次启动运行获取一次值，过程中不再改变，运行过程无法动态获取值
- 用户参数
  1. 位置：测试计划/前置处理器/用户参数、线程组/前置处理器/用户参数
  2. 作用域：<u>局部变量,当前线程组或者当前的取样器</u>
  3. 每次启动运行获取值，运行过程可以动态获取值

- 应用场景

  1. 添加【定义变量】和【用户参数】

     <div align="left"> <img src="pics/jmeter用户变量1.png" width="800"/> </div><br>

  2. 使用自定义变量语法：${变量名称}

     ```java
     {"mobile":"${mobile1}","password":"123456","code":"1234","platform":"windows"}
     ```

  3. 通过调试取样器-查看作用域效果

     <div align="left"> <img src="pics/jmeter用户变量2.png" width="800"/> </div><br>

  4. 启动过程中的变量取值规则：

     <div align="left"> <img src="pics/jmeter用户变量3.png" width="800"/> </div><br>

  5. 【用户定义的变量】设置为手机号,线程数设置3,运行注册+登录接口：1次注册success,3次登录success

  6. 【用户参数】设置为手机号，线程数设置3，运行注册+登录接口：3次注册success，0次登录success

#### 8.jmeter函数助手

- tools/函数助手对话框 ----点击帮助可进入[官方API](https://jmeter.apache.org/usermanual/functions.html)

- 举例随机函数用法：__Random 生成随机数 

  ```
  1. ${__Random(a,b,c)} ----一个范围内最小的随机数a,允许最大的随机数b，存储结果的变量名c.第3个参数不是必填。
  2. ${__Random(0,100,)} ----[0-100]之间的随机整数
  3. ${__Random(0,100,num)}----[0-100]之间的随机整数，结果可以存储到num变量中。可以通过 ${num}去使用。
  ```

  <div align="left"> <img src="pics/jmeter-函数助手2.png" width="800"/> </div><br>

  <div align="left"> <img src="pics/jmeter-函数助手.png" width="800"/> </div><br>

- 常用函数：

  | 函数名称         | 含义                   |
  | ---------------- | ---------------------- |
  | __Random         | 生成随机整数           |
  | __RandomDate     | 生成随机日期           |
  | __RandomString   | 生成随机字符串         |
  | __setProperty    | 设置属性               |
  | __property       | 读取属性               |
  | __P              | 读取属性               |
  | __V              | 拼接字符串             |
  | __time           | 返回指定格式的当前时间 |
  | __MD5            | 将字符串MD5加密        |
  | __UUID           | 生成随机UUID字符串     |
  | __threadNum      | 线程的编号             |
  | __TestPlanName   | 测试计划名称           |
  | __StringFromFile | 从文件中读取一行       |
  | __strLen         | 字符串长度             |
  | __split          | 将字符串拆分为变量     |
  | __substring      | 提取字符串的子串       |
  | __machineName    | 机器名                 |
  | __machineIP      | 机器IP                 |
  | __isDefined      | 判断变量是否已存在     |
  | __BeanShell      | 可执行beanshell脚本    |
  | __char           | 根据unicode生成字符    |
  | __chooseRandom   | 从指定的范围里面取值   |
  | __counter        | 计数器                 |
  | __env            | 获取环境变量的值       |
  | __eval           | 读取变量表达式         |
  | __FileToString   | 读取文件               |
  | __intSum         | 两个或多个整数的总和   |
  | __longSum        | 两个或多个长值的总和   |
  | __digest         | 将字符串加密           |
  | __if             | if 判断                |
  | __iterationNum   | 线程循环次数           |
  | __timeshift      | 时间移动               |

#### 9

















