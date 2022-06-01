

+ 服务器  ：  在一些**硬件** + 操作系统 + 应用程序  ===输出 应用能力输出
+ tree -l 树形目录
+ Linux
  + centos、ubuntu、suse、redhat、debain、deepin
  + debian家族： ubuntu
    + 安装命令： apt  apt-get
    + .deb 
  + fedora家族： centos
    + yum  dnf
    + .rpm包
  + 统一的安装命令
    + tar.gz 安装包
    + 安装时，依赖 gcc  但是 不一定会安装 可能需要手工安装
    + make

# 

+ linux： centos 7
  + 无图像界面的服务器，一般才会作为 服务器
  + 通过客户端  xshell、putty、cmd、finalshell
    + 客户端工具要能连接到linux机器上，机器必须开发ssh服务，这个服务端口22
    + centos系统默认是安装了ssh服务，开放了22端口
    + ubuntu系统 默认没有安装ssh服务，所以，ubuntu这种图像界面系统，有时候不能通过客户端来连接。
    + 你想要连接到一台服务器上：
      + 1、服务器必须启动ssh服务，
      + 2、服务器要开放ssh服务的端口
      + 3、你本地与服务器之间网络要能通
        + 检查： telnet server_ip 22



 + linux 的根路径

   + /boot   核相关文件
   + **/bin**  存放系统中**可用的命令**
   + **/etc**  系统管理所需要的**所有配置文件**
   + **/usr** unix shared resource 用户共享程序文件夹
   + /opt  optional 给主机额外安装的软件目录  相当于window d盘
   + /home  它用户目录，它下一级文件夹，默认是被系统当作用户名的根路径
     	+ 在企业中，你们操作服务器，一般会给你们非root权限的账号，那这个账号，肯定会在/home目录下面有一个文件夹，文件夹的名称是你的用户名，你的所有操作权限，都受这个用户的权限控制，所以你默认的操作都是在这个路径下
   + /sys 系统配置文件，内核等相关
   + **/proc**  process进程，虚拟文件系统，存储当前内核运行状态的特殊文件
     	+ cpuinfo： 记录着系统在启动时，读取的cpu相关信息
     	+ meminfo:  记录着系统在启动时，读取的memory相关信息
     	+ 数字： 都是进程的id  pid  进入这个文件夹，可以查看这个进程启动时相关信息
   + **/var**  不断扩充的东西，**如日志**
     + /var/log/你的程序名称 日志文件

   sda：我们用虚拟机方式产生的硬盘，都是sd盘，其实就是 机械硬盘

   	hd是固态，  他们的区别是，接口不一样

   a\b\c.....  第几个硬盘

   a1\a2\a3....  第1个硬盘的第几个分区

   sda1：

+ ls -lth

  + d 目录  l 链接  - 文件
  + 每3个一组： r读  w写  x执

+ 安装： 

  + fedora家族
    + centos
    + 可执行文件   rpm
      + rmp -ivh *.rpm
    + yum
  + debain家族
    + ubuntu
    + 可执行文件  deb
      + dpkg -i *.deb
    + apt  apt-get

+ 获取命令的帮助：

  + 第一种： command **--help**
  + 第二种：man command   获取比上面更多的帮助
  + 第三种： info command



### linux性能分析命令

#### 1.top

+ top 查看系统**进程**的资源使用情况， 也可以查看线程

  <div align="left"> <img src="pics/linux-top.png"/> </div><br>

+ top - 21:28:23 up  1:30,  3 users,  load average: 0.00, 0.01, 0.05

  + 3 users ： 当前系统有几个用户连接进来， 这个用户，可以是同一个user
  + load average: 0.00, 0.01, 0.05  系统瓶颈负载值
    + 第1个： 系统过去**1分钟**系统的平均负载值
    + 第2个：系统过去**5分钟**系统的平均负载值
    + 第3个：系统过去**15分钟**系统的平均负载值
    + 系统负载值，不等于cpu使用率值。因为系统的负载值，它主要由两部分组成： cpu的使用率 + io使用率
      + 历史的经验，系统负载高低，与cpu的数量有一定关系。
      + io：换入 换出
      + cpu使用率高： 影响因素有us sy ni hi si
    + us：用户态使用cpu的时间占比
    + sy： 系统态  在cpu的内核中进行计算消耗的时间占比
    + ni：优先级切换
    + hi：hard interrupt 硬中断  中断会导致时间浪费，也会导致资源占用升高
    + si：soft interrupt 软中断
    + wa： wait 等待    等待资源
    + st：  管理者占用资源
    + id： 休闲
    + 系统负载值大于cpu数量，就一定负载高。--不一定(io使用率)
  + load average: 0.00, 0.01, 0.05  如何知道我们现在系统的负载情况？
    + 看第1个值 是上升趋势，还是下将======我们现在系统负载正在上升，可能还会继续上升
    + 第1个值小于第二值，现在系统负载正在下降，再过一段时间可能会恢复正常。
  + 数字 1  可以看到cpu的数量， 核数

+ Tasks: 112 total,   1 running, 111 sleeping,   0 stopped,   0 zombie

  + Tasks进程数：Threads:   可以按 H  来切换为线程 
    + 任务列表中， S列 对应
      + S sleep
      + R running
      + T  stoped
      + Z  zombie 

+ Mem :  1881936 total,   808532 free,   468140 used,   605264 buff/cache
  KiB Swap:  4063228 total,  4063228 free,        0 used.  1255740 avail Mem

  + buff/cache: 缓存
    + buffer 缓冲区
    + cache 缓存
  + swap: 交互分区
  + http://testingpai.com/article/1626769424453


+ load average: 
+ Task   Thread  两个数字不相同，  Thread数字大于Task数字， 因为 一个进程可能有多个线程

+ top命令中按数字1可以看到 多个核，每个核的cpu的使用情况
  + 在没有按1，  在我们用监控工具\平台来收集cpu的使用率
    + 看到是 所有cpu数量的一个总体的使用率

+ mem： buffer cache swap
  + buffer是磁盘虚拟出来的一个缓冲区，用于内存**读取**磁盘数据时，加快读取速度
  + cache 缓存，存在内存、cpu中，
  + swap  交互分区  主要是用来，交换内存空间。它也是由磁盘虚拟而来，一般为内存的2倍
+ 任何一个程序启动，都会在内存中占用：虚拟内存核物理内存

+ PID 进程id
+ USER      进程的归属用户
+ PR  优先级的级别
+ NI    优先级的值，越低，优先级越高

-----------

+ VIRT  虚拟内存  进程使用虚拟内存大小   默认是KB
+ RES    物理内存大小  进程使用的物理内存大小 默认是KB
+ SHR   共享内存大小 默认单位也是KB   

这三个都是进程的内存相关数据，按小写e  可以切换单位

------------

+ S  进程的状态
+ %CPU   进程占用的cpu率
+ %MEM     进程使用men率
+ TIME+  进程使用cpu的时间
+ COMMAND   进程名称

查看当前系统cpu使用率最高的4个进程： n  4 回车

top命令默认3秒钟刷新一次数据： s\d 数字

我只想看某个进程下的线程资源使用情况: top -H -p pid值

us\usr、sy\sys

+ ps
  + ps -ef\\-eF\\-ely 使用标准语法查看系统上的每个进程

ps aux |grep mysqld |grep -v grep 



+ vmstat  
  + 这个命令是系统自带
  + 虚拟内存统计的缩写，可对虚拟内存、进程、cpu活动进行监控

```sh
[root@vircent7 ~]# vmstat 1 1
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 1094548   2108 362988    0    0    58     7   40   52  0  0 100  0  0

```

+ procs
  + r  :  数字  显示cpu中有多少个进程正在等待
    + 如果r列是数字，大于cpu核数，那么说明现在现在有大量的进程在等待cpu进行计算，现在可能出现了cpu不够用的情况。----cpu成了我们的性能瓶颈，此时，可能需要去增加cpu数量；或者减少运行的进程数。
  + b ： 数字   现在有多少进程正在不可中断的休眠.   如果这个数字过大，就说明，资源不够用。

+ memory
  + swap
  + free
  + buff\buffer
  + cache

+ swap
  + si  交换分区中的换入
  + so 交换分区中的换出
+ io
  + bi  块设备的读
  + bo  块设备的写
+ system
  + in  interrupet  cpu中断   数字
  + cs  cpu上下文切换  数学
+ cpu
  + us 
  + sy 
  + id 
  + wa 
  + st
+ sysstat的工具包，这个工具包中带了很性能分析命令`yum install sysstat -y`
  + mpstat  查看cpu的相关数据
  + mpstat -P ALL 2 5
    +  %usr   
    +  %nice   
    +  %sys 
    +  %iowait    
    +  %irq    硬中断
    +  %soft  软中断
    +  %steal  
    +  %guest    显示cpu或cpu运行虚拟机处理器所花费的时间占比
    +  %gnice   显示cpu或cpu运行nices客户机所花费的时间占比
    +  %idle

+ pidstat： 能看磁盘、内存、cpu的数据，主要看cpu的上下文数据

  + pidstat -u -w 1 5
    + -u 用于查看cpu的数据
    + -w  看cpu的上下文数据
    + UID       PID   
    + cswch/s   自愿上下文切换次数
    + nvcswch/s   非自愿上下文切换次数
    + Command

  + 中断  VS  上下文切换：
    + 中断： 中断当前正在运行的，去做其他事情
    + 上下文切换： 资源的切换
    + 中断，一定会导致上下文切换，但是上下文切换，不一定会中断。

+ iostat：  看数据换入换出

  + iostat -dx 1 3    ------没有带m，数据单位，默认kb
    + rrqm/s    合并的每秒读请求
    + wrqm/s     合并的每秒写请求
    + r/s    读/秒
    + w/s    写/s
    + rkB/s     读kb/s
    + wkB/s 
    + avgrq-sz   平均情况的扇区数
    + avgqu-sz   等待大的请求数
    + await   等待的时间
    + r_await   读等待的时间
    + w_await  写等待的时间
    + svctm   实际请求的时间
    + %util   至少有一个活跃请求的所占的时间百分比

+ dstat
  + yum install dstat -y
  + dstat -lcmdry

# 

+ 性能分析命令：
  + top
  + vmstat
  + sysstat：
    + mpstat
    + iostat
    + pidstat
  + netstat
  + dstat
  + sar：  主要用在网络相关数据的查看
    + -n  网络相关数据统计
    + -d -b  磁盘驱动
    + -r  内存相关
    + -u  -P  cpu相关

块：从磁盘中读取数据的 最小单位

页：从内存中交互数据的 最小单位   页的大小要比 块要大

性能测试分析的思路：先分析硬件 、网络、 系统配置、应用程序

硬件： cpu、内存、磁盘、网络、io

+ cpu  中央处理器
  + 架构、主频、核
+ cpu：结构 主要物理结构是3个，实际是有4
  + 运算器： 真正进行计算的单元
  + 控制器： leader
  + 寄存器： 存储 指令、数据、地址
  + 时钟

内存： 程序代码、网络数据，外部数据进入cpu的桥梁，内存的速度，要比cpu的速度

cpu中： 内核、线程、架构

cpu的内核，医院中的医生

cpu的线程，医生配备的护士

cpu的架构，医院的结构

看cpu的数据信息： `top`  `lscpu`  `cat /proc/cpuinfo`

/proc  虚拟文件，操作系统启动时，读取的信息，这些信息放内存中

`cat /proc/cpuinfo |grep "physical id" |sort |uniq |wc -l ` 查看物理cpu数量

`cat /proc/cpuinfo | grep "cpu cores" |uniq `查看CPU的core数，即核数

`cat /proc/cpuinfo | grep "processor" |wc -l` 查看逻辑CPU数量

load average = cpuload  + ioload

+ 上下文切换：  寄存器中的资源进行切换
  + 自愿上下文切换： 资源不够，自觉的切换到另外指令上
  + 非自愿上下文切换： 有可能有优先级更高的指令、指令执行的时间已经到了，被迫中止当前的指令，去执行其他指令

# 

+ top、 mpstat

  + sys高 系统态cpu使用率高， 内核中计算
    + 程序进行计算，非内核态  进入 内核态，重点关注 上下文切换的数据
      + 自愿上下文切换， 资源不够用，所以要进行切换，===资源有关，===可能存在IO/内存资源
      + 非自愿上下文切换 -----强制进行资源切换 =====考虑cpu不够用
        + 解决：
          +  要么在服务器上，减少启动的程序
          +  要么增加cpu的数量

  + si 软中断高
  + us 用户态比较高 

+ 真正在做性能测试时，你要管理好你的被测服务器，loadaverage要恢复正常，第一个值，没有明显的上升或下降的趋势，也就是说第1个值，基本不变。

  + 要把服务器的资源监控弄起来，上课，用的grafana+prometheus + 硬件资源\应用资源

+ 服务器硬件资源监控： grafana(前端) + prometheus(时序数据库) + node_exporter(硬件资源收集器)

  + 被测服务器上 部署 node_exporter
    + node_exporter上传到被测服务器
    + 解压、启动   `./node_exporter`
    + 端口：9100
  + 监控平台机器上，启动 grafana + prometheus
    + 进入prometheus文件夹，修改Prometheus.yml的配置文件
    + 保存好配置文件，启动Prometheus  `./prometheus`    默认端口：9090
    + 启动grafana   `systemctl  restat grafana-server`  默认端口： 3000
    + http://grafanan_ip:3000  admin admin

+ stress-ng:  性能测试模拟工具，可以直接模拟服务器各种压力情况

  + stress-ng   我可以通过它，来模拟，你们企业中的响应有cpu相关性能问题
  + 安装

  ```shell
  # 安装epel源，更新系统
  yum install -y epel-release.noarch && yum -y update
  
  # 安装stess-ng 的工具
  yum install -y stress-ng
  
  ```

+ ## 进程上下文切换

```shell
(( proc_cnt = `nproc`*10 )); stress-ng --cpu $proc_cnt --pthread 1 --timeout 150
# nproc   这个命令可以获得服务器cpu的数量
# (( proc_cnt = `nproc`*10 ));   把cpu核的数量乘以10倍，给变量proc_cnt
# --cpu $proc_cnt  $proc_cnt shell编程中的变量引用
# --pthread  每个进程有多少个线程
# --timeout   超时时间，在命令执行多长时间之后自动结束
```

总结：

1、top命令，可以到 loadaverage 有持续上升，cpu被100%使用   us + sy + si

2 vmstat    proc中r列有非常大的数据  有非常多的进程在抢cpu的资源

	memory: free 数据变小， 内存有一部分被使用
	
	system： in有一点点， cs 有明显数据变大，说明有大量的 上下文切换

3 pidstat  -w 1----这个命令可以上下文的信息

	我们看到的大量 stress-ng--cpu  cswch/s 自愿  nvcswch/s非自愿上下文的值

现在可以得出 ，我们线程有大量的 进程上下文切换问题，而这个问题的进程：stress-ng--cpu



当你的服务器，使用top命令发现，系统负载比较高，所有的cpu的使用率接近或等于 100%，我们要排查问题，vmstat 1 ， 结果我们看到有procs 中r列 有大量数据，说明我们有大量进程在竞争cpu的资源。--------可能服务器的cpu数量不够， 也可能是 进程启动的太多

vmstat  我们还看 system中 cs  比较高 --------肯定有大量的上下文切换

	但是，此时，我并不知道，是哪个进程导致 抢占cpu，-----找具体是哪个进程

==== 应该是某个经常有大量的上下文切换，而导致的cpu使用率过高，系统负载过高的问题

---问题的关键点，找到具体的进程

pidstat -w 3      看到具体的 上下文切换的数据比较大的进程。-------**得到具体进程 和进程id**

+ 结论

  Ø1、top： load值一直在增加，而且增长的非常大

  Ø2、top：CPU的 us + sy ≈ 100%，us较高，sy较低

  Ø3、vmstat： procs的r 就绪队列长度，正在运行和等待的CPU进程数很大

  Ø4、vmstat： system的in(每秒中断次数) 和 cs(上下文切换次数) 都很大

  Ø5、vmstat：free、buff、cache变化不大

  Ø6、pidstat: nvcswch/s 非自愿上下文切换在逐步升高



只要系统运行，那么 中断和 上下文切换，就不可避免，只不过这些数据比较小



+ ## 线程上下文切换

```
stress-ng --cpu `nproc` --pthread 1024 --timeout 60
```

 +  分析命令： 
    +  top
       	+  vmstat 1
           	+  pidstat -w 5



+ 结论：

Ø1、top： load值一直在增加，而且增长的非常大

Ø2、top：CPU的 us + sy ≈ 100%，us较低，**sy较高**

Ø3、vmstat： procs的**r 就绪队列**长度，正在运行和等待的CPU进程数很大

Ø4、vmstat： system的in(每秒中断次数) 和 **cs(上下文切换次数) 都很大**

Ø5、vmstat：free变小、buff基本不变、cache变大

Ø6、pidstat: cswch/s **自愿上下文切换** 升高

# 

+ 实战

  + stress-ng  
    + 模拟了进程上下文切换
    + 模拟了线程上下文切换
    + IO密集型
      + IO不要再理解为：读写操作，换入换出

+ IO密集型，导致服务器平均负载比较高

  ```sh
  stress-ng  -i 6 --hdd 1 --timeout 150
  ```

  

  + top:
    + loadaverage  上升
    + cpu： wa值很大  us、sy不是很大， buff/cache有增大
  + vmstat  1: mem free减少， cache有明显的增大， **bo**有明显数据， 说明有大量磁盘数据交换
  + mpstat -P ALL 3  ： %iowat 数值比较大  再次证明，我们线程系统负载比较高的原因是，系统的磁盘读写测试性能瓶颈，  哪到底是哪个进程导致我们的磁盘读写高？
  + pidstat -w 1    stress-ng-hdd这个进程的 自愿上下文切换数据比较大，pid的值  进程id

===你们考虑一下，这个问题这么解决？

	----已经定位到了具体是哪个程序导致了
	
		要么换磁盘，要么迁移到io性能更好的服务器
	
			如果你是整体的迁移你的数据库，这个风险比较大，我们可以再另外一个IO性能比较好服务器，再安装一个数据库，做要给数据库读写分离。
	
		要么 减少io操作

要定位到具体代码：

思路：具体进程id之后， 找到进程线程id，然后把线程id进行16进制转换， 进程id日志打印出来，过滤出线程id(16进程)



+ 内存知识

  + 当打开一个软件，就会分配虚拟内存、物理内存空间，cpu读取虚拟内存
  + 程序在启动时，并不会把所有的数据，加到内存
  + 32位的系统，最大支持的内存条，只有4g，64位系统，最大可以支持128T
  + 程序在启动时，会有一个内存配置信息，就会告诉系统，我要在整改内存条中，申请多少m内存空间。

+ 内存中，内存地址与存储单元组成的

  + 存储单元中，就是来真正存储内容
  + 不同的数据类型，存储单元大小不一样
    + int float, char
    + 列表  数组
    + python：列表 [8,'nmb',['vip8','vip12'],]
      + 列表中，插入一个数据，要把插入位置之后的所有数据都移动位置
      + 所以，这种，速度是比较慢

+ 数据结构

  + 链表：  自行车链条
  + 每一个数据，都有自己的地址 + 数据 +下一个数据的地址
  + 插入数据时， 数据本身可以在内存空间的任意位置，然后，在插入数据的位置前一个数据改变下一个数据地址，指向我的这位置，我的数据位置记录的下一个位置......
  + 这种数据插入方式，速度要比列表要块
  + 但是，读取某个数据的速度降低，因为我们每查询一个数据，都要从链表的第1个数据开始查找，一直到找到为止，这个中间，我们可能要进行大量IO数据交互

+ 堆栈：  两种数据结构

  + 栈： LIFO

  + 队列：FIFO

  + 堆：

    

# 

+ 内存
  + 内存地址  + 内存存储单元
  + 内存中数据结构
    + 列表：往列表中插入数据，插入点之后的数据，全部都需要移动，这个插入速度比较慢
    + 链表：每一个数据，它都存储了下一个数据的地址(内存地址)，在插入数据的时候，我可以把数据放在任何位置
      + 链表在查数据时，它的链路可能会很长，那么它的IO可能消耗比较高
    + 二叉树
      + 它也链表
      + 插入数据时，数据进行比较，比数据小的在左边，比数据大的插入在右边
      + 查找数据时，比数据大的，我就去右边找，比数据小，我就去左边找，这个时候，IO就比链表要少很多。
+ 数据类型：
  + 栈stack： 存储的数据比较小，比如某个变量
    + LIFO  后进先出
      + 压入 push
      + 弹出 pop  弹出我们最后一个数据
  + 队列： FIFO   排队
    + 顺序队列，
    + 循环队列
  + 堆heap： 存储的数据比较复杂
    + 对象



+ 一个程序： 如： 这个程序启动要 256m

  + 先有一个虚拟内存地址  +  物理内存地址
  + 虚拟内存地址： 记录物理内存中存储了哪些数据，在什么地方

+ jvm： java虚拟机

  + 程序计数器、java虚拟机栈、本地方法栈、方法区、堆内存
  + 程序计数器：记录程序执行字节码的行号指示器

  + **内存泄漏**： 内存的资源不及时释放，一直占用，导致可用的内存资源越来越少。
  + **内存溢出**：内存泄漏到一定的时间，可用的空间就会越来越少，某一次我要用比较大的空间时，发现，我申请不到足够的空间了，我申请的空间已经超过最大可用空间，内存溢出。
    + 内存溢出，在错误日志，会出现
    + jmap
    + arthas

top:  进程列表中有3列，  虚拟内存、物理内存、共享内存

+ 堆内存：新生代、老年代、永久代(元空间)

  + 新生代new：昙花一现，朝生夕死的对
    + 如：你写的代码，方法里面变量
  + 老年代Tenured：
    + 新生代数据，经过copy算法，如copy了15次，

  

YGC:Young Generation   Minor GC

FGC:Major GC

资源回收的时候，都会出现卡顿，YGC的卡断时间会比较短，FGC卡顿的时间会比较长

性能测试中，就对于这个gc是要关注

+ 如果 新生代资源分配过多，那么，老年代这变就要少， 老年代的空间，我可能就要经常的进行FGC， FGC频率高了，那么累计的gc的时间就长，导致性能比较差

+ 如果 新生代分配的资源少了，那么老年代就分配多些，我的新生代的资源回收频率YGC就要高， 那么累计的ygc的时间也可能长，我的性能也可能较差



+ gc资源回收
  + 哪些是可以被回收？
    + 是否已死



-XX:SurivivorRatio=8   eden空间、from空间、to空间的比例 8:1:1

-XX:MaxMetaspaceSize   jdk1.7  jdk1.8这个元空间参数配置名称变了



+ 查看内存：

  + free -h

    

# 

+ oom项目环境部署
  + 准备一台linux
  + 检查 jdk1.8
  + tomcat   Jvmpertest.war 丢到webapps文件夹下
    + catalina.sh
    + `JAVA_OPTS="-Xms256m -Xmx256m -Xmn128m"`
  + 启动tomcat
  + jmeter调用： http://ip:8080/JvmPertest/pertest1
    + 设置性能场景进行调用

+ 确定oom问题：
  + 看请求的响应信息， 一般的情况下，出现内存溢出问题，在响应信息中都会有所体现`nested exception is java.lang.OutOfMemoryError: Java heap space`
  + 有些项目，在log日志中，会有体现，  ===不一定有
  + 我们看 系统的 内存
    + 内存并没有被完全消耗掉
+ 定位这个问题：
  + 生成内存溢出堆栈文件
    + 获得进程id  `ps -ef |grep java` `jps`
    + `jmap -dump:live,format=b,file=heap_jvmpertest_20210811002.hprof 2419`
    + 方法2：arthas
      + curl -O https://arthas.aliyun.com/arthas-boot.jar
      + 启动： `java -jar arthas-boot.jar pid`
      + `heapdump`  ，在出现内存溢出的错误是，执行这个命令，可以直接下载heapdump信息
  + MAT
    + 解压MemoryAnalyer工具
    + 打开工具，open hprof文件
    + 点击 histogram
    + 没有java基础的同学， hprof文件给开发去定位， 有基础的同学，mat工具自己来分析

看jvm的 gc信息： -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimestamps -XX:+PrintGCApplicationStopedTime

IO操作，所以，生产环境，一般不添加

`jstat -gcutil 3122 1000 10`  分析gc

ØS0：新生代susvivor0区

ØS1：新生代susvivor1区

ØE：新生代eden区

ØO：年老代

ØM：方法区回收比例 CCS：类空间回收比例

ØYGC：minor gc次数

ØYGCT： minor gc耗费的时间

ØFGC： full gc的次数

ØFGCT： full gc的耗时

ØGCT： gc总耗时



cpu相关问题，应用服务器中高频率

内存： 工作中，比较难

网络：见的多，但是不是最难，只是因为大家 见多，网络知识跟不上

磁盘问题： 相对来说问题是最少， 一般集中在 文件服务器\数据服务器

+ 磁盘
  + 服务器 最大存储空间，但是速度比较慢
  + 磁盘的格式化： 最大化的利用磁盘，以及加快磁盘的读写	

# 

+ 内存

  + 扇区扇区sector：磁盘组成的最小单元(512b)，磁盘磁道中一个弧段

  + 块Block：操作系统与**磁盘数据**交换的**最小单位**，块=2n x 扇区

    Ølinux：类似Ext4文件系统，就是磁盘分块

    Øwindows：类似NTFS文件系统，也是块，只是被叫做‘簇’

  + 页page：操作系统与**内存数据**交换的**最小单位**  一页的大小，一般是4K

  + 缓冲区buffer:

+ 磁盘阵列RAID:

  + RAID0: 数据分片存在2块磁盘，**读写速度**提升2倍，但是，数据没有冗余，万一数据出错，很难恢复
  + RAID1：相同数据冗余存入2块磁盘，**写**速度不变，**读**速度提升2倍，数据有冗余，恢复数据很简单
  + RAID5：数据分片和校验码混合存储3份，**读写速度提升2倍**，数据没有冗余，但是有校验，数据恢复时，比较容易。
  + RAID10：2块磁盘1组先做RAID1，多组RAID1，再做RAID0。读写速度N倍 n为组数

+ 测试磁盘**写**的速度

  + 1、先清空缓存： `echo 3 >/proc/sys/vm/drop_caches`
  + 2、写操作： `dd if=/dev/zero of=$PWD/optfile bs=20MB count=100`
    + 3、`vmstat 1`  cache增大， bo有明显数据，in也有明显数据变化
    + 4、`iostat -dx 1` wkB/s有非常大的数据， await也有数
  + 我现在磁盘的写速度大概时400MB/s

+ 测试磁盘**读**的速度

  + 1、先清空缓存 `echo 3 >/proc/sys/vm/drop_caches`
  + 2、写操作： `dd if=/dev/sda of=/dev/null bs=20MB count=100`
    + 3、`vmstat 1` buff 有明显的数据，cache有数据变化，但是不明显， bi有明显的数据
    + 4、`iostat -dx 1`  rKB/s有明显的数据，await有，但是不是很大

+ 测试内存的速度

  + 1、先清空缓存 `echo 3 >/proc/sys/vm/drop_caches`
  + 2、脚本： `dd if=/dev/zero of=/dev/null bs=10MB count=1000`

**结论**： 磁盘的读写速度，几百MB/s   内存 几GB/s  **内存速度比磁盘快很多**。

<span color="red">**写**</span>操作时，**cache**增大， **bo**有明显数据，

**读**数据时，**buff**增大， **bi**有明显数据