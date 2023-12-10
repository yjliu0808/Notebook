## tencent服务器部署步骤

所有的均安装到athena 文件夹

```
mkdir /athena 
cd /athena
mkdir mysql
mkdir jdk
mkdir redis
mkdir nginx
ls
```

重新安装系统后基本环境安装：

```
yum -y install wget
yum install gcc-c++ make -y
```

### 安装mysql8操作步骤

```
cd mysql
sudo rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum install mysql-server --nogpgcheck
sudo systemctl start mysqld
sudo systemctl status mysqld
sudo systemctl enable mysqld
systemctl restart mysqld

mysql -uroot -p  
密码默认是空，直接回车
ALTER USER 'root'@'localhost' IDENTIFIED BY 'gP%?qfZS>3/W';
use mysql;  
SHOW VARIABLES LIKE 'validate_password%';
install plugin validate_password soname 'validate_password.so';
SHOW VARIABLES LIKE 'validate_password%';
set global  validate_password_length=6;
set global validate_password_policy=LOW;
update user set host='%' where user='root';
flush privileges;
ALTER USER 'root'@'%' IDENTIFIED BY '123456';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
```





### 方式二安装mysql8操作步骤

```
原文链接：https://blog.csdn.net/qq_45731111/article/details/132866490
Linux安装mysql8.0.34
wget https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-8.0.34-linux-glibc2.28-x86_64.tar.gz

tar -zxvf mysql-8.0.34-linux-glibc2.28-x86_64.tar.gz

# 修改名字 
mv mysql-8.0.34-linux-glibc2.28-x86_64 mysql

# 将安装文件移动到/usr/local/ 下

mv mysql /usr/local/

# 创建mysql数据存放目录

mkdir -p /data/mysql
创建配置文件
vim /etc/my.cnf

[mysqld]
bind-address=0.0.0.0
port=3306
user=root
basedir=/usr/local/mysql
datadir=/data/mysql
socket=/tmp/mysql.sock
log-error=/data/mysql/mysql.err
pid-file=/data/mysql/mysql.pid
character_set_server=utf8mb4
symbolic-links=0
explicit_defaults_for_timestamp=true

安装mysql

# 进入到mysql 的bin目录下
cd /usr/local/mysql/bin/
# 执行初始化命令
./mysqld --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql/ --datadir=/data/mysql/ --initialize

如果出现异常： error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory

安装依赖即可解决：
yum install -y libaio
再次进行初始化， 没有任何报错就是初始化成功，
查看默认密码, 复制出来备用
less /data/mysql/mysql.err
# w!*qpAJ;P6Qf

3. mysql启动  
# 将mysql.server 复制到/etc/init.d目录下 ，名字为mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
# 启动mysql
service mysql start

如果出现： Failed to start mysql.service: Unit not found
修改/etc/init.d/mysql文件内容
vim /etc/init.d/mysql
# basedir 和datadir 是 my.cnf 配置中填写的文件
basedir=/usr/local/mysql
datadir=/data/mysql

重新启动即可成功
 service mysql start

进入数据库（ /usr/local/mysql/bin）执行
 ./mysql -u root -p

# 输入之前复制的密码即可进入
# w!*qpAJ;P6Qf
修改密码：
ALTER USER USER() IDENTIFIED BY '11231231addasda';
FLUSH PRIVILEGES; 　　 　　 #刷新 
设置外部访问
grant all privileges on *.* to 'root'@'%' with grant option;
FLUSH PRIVILEGES; 　　 　　 #刷新 


sudo dnf install libaio
o_bo?qUu&9gq
ALTER USER USER() IDENTIFIED BY '123456';

```

zabbix 

```
create user zabbix@localhost identified by '123456';

yum install glibc-langpack-zh.x86_64
```



### 安装JDK1.8操作步骤

[JDK1.8下载](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)



```
vim /etc/profile

export JAVA_HOME=/athena/jdk/jdk1.8.0_202
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

source /etc/profile
java -version
```

### 安装redis操作步骤

```
sudo dnf install -y epel-release
sudo dnf install -y redis
sudo systemctl start redis
sudo systemctl status redis
sudo systemctl enable redis
sudo systemctl restart redis
vim /etc/redis.conf
bind		    绑定的主机地址,如果需要设置远程访问则直接将这个属性#注释
protected-mode	如需外网连接rendis服务则需要将此属性改为no。
requirepass 123456
sudo systemctl restart redis  重启服务使生效
服务器开放6379端口后外网验证
telnet 101.35.51.221 6379 
```

安装redis操作步骤-方式2

```
cd redis
yum install gcc-c++ make -y
gcc -v
wget http://download.redis.io/releases/redis-6.0.8.tar.gz
ls
tar -zxvf redis-6.0.8.tar.gz
ls
cd redis-6.0.8
make PREFIX=/athena/redis/redisMake install
cd /athena/redis/redis-6.0.8/src
ls
./redis-server
./redis-cli shutdown
vim /etc/systemd/system/redis.service
```

```
[Unit]
Description=redis-server
After=network.target
[Service]
Type=forking
# 这行配置内容要根据redis的安装目录自定义路径
ExecStart=/athena/redis/redisMake/bin/redis-server /athena/redis/redis-6.0.8/redis.conf
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```

```
systemctl daemon-reload
systemctl enable redis
reboot
systemctl status redis
```

```
vim /athena/redis/redis-6.0.8/redis.conf

bind		    绑定的主机地址,如果需要设置远程访问则直接将这个属性#注释
protected-mode	如需外网连接rendis服务则需要将此属性改为no。
requirepass 123456
服务器开放6379端口后外网验证
telnet 101.35.51.221 6379 

netstat -ntulp
./redis-server --protected-mode no &
```

### 安装nginx操作步骤

```
sudo dnf install -y epel-release
sudo dnf install -y nginx
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx
reboot
sudo systemctl restart nginx
cd /usr/share/nginx/html
vim /etc/nginx/nginx.conf
```

```
/usr/share/nginx/html/dist   将打包好的dist文件上传即可
```



### 后台启动jar包服务



```
nohup java -jar mall2.jar > mall.log 2>&1 &
```

设置开机自启的步骤：

1、要实现在进程意外终止后自动重启Java应用程序 `mall.jar`，您可以编写一个脚本，并使用相应的工具来监控和重启进程。

2、下面是一个简单的示例，使用`systemd`来管理进程并实现自动重启：

/etc/systemd/system/mall.service    创建一个文本文件，例如 `mall.service`，并使用文本编辑器打开该文件：

```
[Unit]
Description=Mall Service
After=network.target

[Service]
User=root
ExecStart=/athena/mall -jar /athena/mall/mall.jar > /athena/mall/mall.log 2>&1
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

使用以下命令重新加载 `systemd` 配置并启动服务：

```
$ sudo systemctl daemon-reload
$ sudo systemctl start mall
$ sudo systemctl enable mall
```

s

### jenkins 集成github

```shell
wget https://repo.huaweicloud.com/jenkins/redhat-stable/jenkins-2.346.3-1.1.noarch.rpm
rpm -ivh jenkins-2.346.3-1.1.noarch.rpm
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

启动报错：原因：因为`Jenkins-2.396` 依赖于`Java 11` 版本才能启动。

```
yum install java-11-openjdk-devel java-11-openjdk
sudo systemctl start jenkins
```

```

更换默认的端口
vim /etc/sysconfig/jenkins 

JENKINS_PORT="8082"   #8080换成8082


vim /lib/systemd/system/jenkins.service

# 修改端口号
Environment="JENKINS_PORT=9898"

systemctl daemon-reload
sudo systemctl restart jenkins
```



### Personal access tokens (classic)

```
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
```

### POP3/IMAP/SMTP/Exchange/CardDAV 授权码已生成

```
POP3/IMAP/SMTP/Exchange/CardDAV 授权码已生成
在第三方客户端登录时，密码框请输入以下授权码：
dhmgpnupdjvidghe
你可以拥有多个授权码，无需记住该授权码，为了安全请勿告知其他人。
```



zabbix  启动失败原因：配置文件被注释了

```
create user zabbix@localhost identified by 'gP%?qfZS>3/W';
```



安装git

```
yum -y install git
 git --version
```

