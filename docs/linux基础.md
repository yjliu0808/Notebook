

[Linux视频](https://www.bilibili.com/video/BV1mW411i7Qf?p=4&spm_id_from=pageDriver)

### linux发展历史

- 内核相同,发行版本不一致，选择linux系统，以CentOS


<div align="center"> <img src="pics/linux1.png" width="800"/> </div><br>

```
Linux
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
  

```



### 第一讲、Linux系统简介



<div align="center"> <img src="pics/linux2.png" width="800"/> </div><br>

- 开源软件:apache、nginx、mysql、php、samba、python
- lamp:linux、apache、mysql、php(编程语言)

- www.netcraft.com 踩点技术、扫描
- 为什么选择命令行：定位不同，一般不用图形界面
- 解决问题的智慧：不是马上问别人，自学能力
- 1.提示信息、帮助文档、示例、查找
- 2.英文的困惑：Command not found、No Such file or directory
- linux中主要英文单词的背诵、
- 计划、坚持、专注、练习、



linux服务器

+ 服务器  ：  在一些**硬件** + 操作系统 + 应用程序  ===输出 应用能力输出

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

  + 第三种： info commandlinux服务器

    + 服务器  ：  在一些**硬件** + 操作系统 + 应用程序  ===输出 应用能力输出

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

    


### 第二讲、linux系统安装

一、vmware虚拟机系统安装与使用

VMware官方网站：http://www.vmware.com

虚拟硬件设置：内存调整

有快照功能：当前设置记录

克隆：完整克隆复制当前的原始虚拟机

二、系统分区、

主分区：

扩展分区：

逻辑分区：

格式化（高级格式化对操作系统而言）：写入文件系统

文件系统例如默认：EXT4

进入格式化

block数据块

linux分区、格式化、分区直接建立硬件设备文件名

硬件设备文件名系统固定的。

分区设备文件名

分区设备文件名默认为硬件设备文件名加1，2系统固定

挂载：必须分区：/根分区，swap分区，推荐分区：/boot(启动分区，200MB)

正常使用步骤：分区-格式化-给分期建立硬件设备文件名-分区设备文件名-挂载点

/根目录linux最高目录

三、linux系统安装

设置密码原则：复杂性：8位字符以上、大小写字母、数字、符号、不能是英文单词 

四、远程登录管理工具

secureCRT 、winSCP、xftp和xshell

### 第三讲、给初学者的建议

linux命令及文件、用户名、配置文件严格区分大小写

linux中所有以文件的形式保存（硬盘、网段等也是写入的文件）

操作文件管理对应的硬件

linux不靠扩展名区分文件类型

不写如下这些也可以，约定俗称的写了更容易

压缩包：“*.gz”、“*.bz2”、"*tar.bz2"

linux各目录的作用

/bin/普通用户和超级用户都可以执行

服务器注意事项

远程服务器不允许关机，只能重启

重启时应该关闭服务

不要在服务器访问高峰运行高负载命令

远程配置防火墙时不要把自己踢出服务器（执行定时任务：每分钟清除等全部配置完）

防火墙作用：过滤、ip地址、mac地址、端口号、病毒伪装正常可以正常攻击电脑

制定合理规范密码定期更新、合理分配权限、定期备份重要数据和日志

### 第四讲、linux常用命令

#### 4.1文件处理命令

##### **4.1.1命令格式与目录处理命令ls**

命令格式：命令 [-选项] [参数]

eg: ls -la /etc

说明：

- 个别命令使用不遵循此格式
- 当有多个选项时，可以写在一起
- 简化选项与完整选项  -a 等于--all

ls 显示当前文件

ls -l 显示当前文件信息

ls -lh 文件大小不是默认字节单位

文件类型：-开头表示文件、d表示文件夹、l软链接

<div align="center"> <img src="pics/linux_命令.png" width="800"/> </div><br>
rw- r-- r--

所有者、所属组、o其他人

r读  w写 x执行

ls -a  显示所有文件，包括隐藏文件

ls -l   详细信息的显示

ls -d  查看目录属性

ls -i  查看文件对应的id

tree -l 树形目录

##### **4.1.2目录处理命令**

**目录处理命令 mkdir**

语法：mkdir -p  [目录名] 

eg: mkdir  -p  /tmp/[目录名]   创建新目录

-p 递归创建

eg: mkdir -p  /tmp/lyj/a /tmp/lyj/b

**目录处理命令pwd**

pwd:显示当前目录

**cd :切换目录**

cd /tmp/lyj

cd .. 返回上一级目录

**rmdir:删除空目录**

**cp:复制文件或目录**

语法：cp -rp[原文件或目录] [目标文件]

​           -r 复制目录

​           -p保留文件属性

复制的同时可以改名

eg:cp -r /tmp/lyj_2 /root/lyj

eg:cp /toot/a.log /tmp

**mv:剪切文件、改名**

eg:mv -/tmp/a /root/lyj

**rm:删除文件**

eg:rm /a/a.txt 删除文件

eg：rm -rf /root/a 删除目录（谨慎不能删除系统配置文件）

总结：mkdir、mkdir -p、cd  pwd cp -r -p 、mv、 rm -rf

##### 4.1.3文件处理命令

- touch: 创建文件

  eg:touch  /root/lyj/a.log  

  eg：touch /root/lyj/a b  空格表示创建2个文件

- cat :查看系统文件

  eg:  cat /root/a.txt

  tac反向显示

  more 比较长的文件内容，可以用空格键:翻页 、用回车键：换行、Q键：退出

  回翻文件内容可以用命令：less，eg:less /root/a.txt  

  less可以上下翻页和搜索（N表示next继续搜索）

  head:显示文件几行
  
  eg:head -n 7
  
  tail [文件名]  :显示文件后面的几行
  
  -n 指定文件后面几行、-f 动态显示文件末尾内容
  
  eg:tail -n  18 /etc/services

##### 4.1.4链接命令

**ln -s:创建软链接**

eg:ln -s a /tmp/a.rln -s a /tmp/a.r

- 软链接特征：类似于Windows快捷方式
- 1.权限默认：  l wrxwrxwrx   2文件大小-只是符号链接  3./tmp/a.r ->/tmp/a箭头指向源文件

硬链接特征：

拷贝cp -p 

硬链接实时备份、同步更新

通过i节点识别、i节点映射多个文件

硬链接不能夸分区（/tmp/a  类似D盘C盘）

硬链接不能针对目录使用

#### 4.2权限管理命令

##### 4.2.1  权限管理命令chmod

所有者：谁创建的只有1个、

如何更改文件权限？------一个文件只有所有者和root用户可以有权限

chmod [{ugoa}{+-=}] [文件或目录]  u所有者、g所属者、o其他人、a所有人

​             [mode=421]   [文件或目录]

​               -R递归修改

功能描述：改变文件或目录的权限

eg: chmod g+w,o-r lyj.txt

r  4、  w  2、 x   1    权限对应数字

532  r-x-wx-w-

数字对应的权限修改eg: chmod  532  lyj.txt

递归修改 a目录改为权限532，a目录下的子目录b, eg：chmod -R 532 /a/b

r w x 对文件权限

r w x 对目录权限     x进去该目录     r查看该目录权限

eg：对改目录下的文件有写的权限也就是对改目录下的 

删除一个文件的前提是对该文件所在的目录有写权限，若只对改文件有写权限是无法删除的  

##### 4.2.2其他权限管理命令

改变文件或目录的所有者  chown [用户] [文件或目录]

eg: chown liuyujuan    b  (改变文件b的所有者为liuyujuan )

不能使用无效的用户  

改变文件或目录的所属组 charp   [用户] [文件或目录]
eg:charg liu b  更改文件b的所属组为liu

- 谁创建的文件就是这个文件的所有者，文件的缺省组就文件的所属组。

**umsk [-S]**：可以线下文件缺省权限

touch 文件是没有可执行权限的

缺省创建的文件是没有可执行权限 	 

#### 4.3文件搜索命令

##### 4.3.1文件搜索命令find

Windows 搜索文件软件：Everything

linux搜索占用服务器资源

find [搜索范围] [匹配条件]

功能描述：文件搜索

eg:find  /etc  init  搜索etc下的文件名为init的文件

eg:find /etc -name* init *  包含init的文件

（inint???  以init开头结尾3个字符的文化、

eg ：eg:find /etc -iname* init *   -iname不区分大小写

eg:find / -size +204800  在根目录查找大于100MB的文件

+204800 大于  -204800小于  204800等于

1个数据块 512字节 0.5k

100MB=102400KB=204800

eg：find  /root  -user  lyj  在root目录查找所有者为lyj的文件

eg：find  /root  -group  lyj  在root目录查找所属组为lyj的文件

find   /etc -cmin -5

查找5分钟年内改变过属性的文件和目录

-amin 访问时间 access

-cmin 文件属性 change

-mmin 文件内容 modify

eg:find 、etc -size +163840 -a -size -204800

在/etc下查找大于80MB小于100MB的文件

-a 两个条件同时满足

-o两个条件满足任意一个即可



eg：find /etc -name lyj -excec ls -l{}\

在etc下查找lyj文件并显示其详细信息

-exec/-ok {}\;对文件的搜索

-type 根据文件类型查找

f 文件 d 目录 i软链接文件

-inum 根据i节点查找

eg: find . -nium 31531 -exec rm {}\.

在当前目录下删除i节点为31531的文件

<div align="center"> <img src="pics/linux命令find.jpg" width="1000"/> </div><br>

##### 4.3.2其他命令搜索

文件搜索命令：locate

eg:locate lyj  查找文件lyj的文件位置    

速度快的原因：在文件资料库中查找文件，但是当新建的文件没有被收入资料库无法被查到。

相对应更新资料库命令  update

#### 4.4帮助命令

#### 4.5用户管理命令

#### 4.6压缩解压命令

#### 4.7网络命令

#### 4.8关机重启命令

###    第十讲 Shell基础 

####  10.1Shell概述

- Shell解释执行的脚本语言，在shell中可直接调用Linux系统命令 

#### 10.2第一个脚本:

```shell
vim hello.sh 
#!/bin/bash
#!第一个脚本
echo "Hello , Athna, this is sunday!"
脚本执行：
赋予执行权限，直接运行：
chmod 755 hello.sh
./hello.sh
通过bash调用执行脚本
bash hello.sh

```



待





​         