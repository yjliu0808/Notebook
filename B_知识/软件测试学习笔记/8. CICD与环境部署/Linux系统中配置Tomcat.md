###  Linux系统中部署tomcat

- 前提准备：成功安装jdk环境[（jdk安装步骤）](https://blog.csdn.net/weixin_41982514/article/details/109005972)

- 检查linux系统版本，下载对应的tomcat安装包

- ```
   uname -a   查看下系统信息
  ```

<div align="left"><img src="pics/tomcat1.png" width="500"/> </div><br>


 1. 下载tomcat 安装包 [（tomcat下载地址）](http://tomcat.apache.org/download-90.cgi)

     <div align="left"><img src="pics/tomcat2.png" width="500"/> </div><br>

 2. 上传tomcat安装包并解压 

  <div align="left"><img src="pics/tomcat3.png" width="500"/> </div><br>

 3. 配置环境变量
```java
vim /etc/profile  进去profile文件
```
 4. 输入 I 键，切换成可输入模式。
 5. 复制配置信息，粘贴到如图profile文件中（在 unset i 的前面输入）
```java
export CATALINA_HOME=/usr/local/java/tomcat/apache-tomcat-9.0.38  设置为自己的tomcat目录位置
export CLASSPATH=.:$JAVA_HOME/lib:$CATALINA_HOME/lib
export PATH=$PATH:$CATALINA_HOME/bin
```
<div align="left"><img src="pics/tomcat4.png" width="500"/> </div><br>

 6. 按 Esc 键，退出insert模式，输入 :wq 保存并退出
```java
:wq 保存，退出
:q! 不管编辑或未编辑都不保存退出
```
```java
source /etc/profile   文件修改生效命令 
```
 7. 验证tomcat是否安装成功 (默认是8080端口)

```java
systemctl stop firewalld.service     关闭防火墙
```
```java
cd /usr/local/java/tomcat/apache-tomcat-9.0.38/bin      进入Tomcat下的bin目录
```
```java
./startup.sh  Tomcat     开启命令
```
 8. 如图tomcat启动成功，可以通过浏览器访问 192.168.23.282:8080 (不要添加https://)

  <div align="left"><img src="pics/tomcat5.png" width="500"/> </div><br>

  <div align="left"><img src="pics/tomcat6.png" width="500"/> </div><br>
  附加：tomcat调试，启动防火墙的相关命令
```java
./shutdown.sh           Tomcat关闭命令
./startup.sh  Tomcat    Tomcat 开启命令
chmod 755 -R*           更新当前目录权限
```
```java
systemctl stop firewalld.service        关闭防火墙
systemctl start firewalld               开启防火墙，没有任何提示即开启成功
systemctl restart firewalld             重启防火墙
systemctl disable firewalld.service     禁止firewall开机启动
```

